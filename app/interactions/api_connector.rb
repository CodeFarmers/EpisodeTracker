class ApiConnector
  require 'net/http'
  require "rexml/document"
  require "zip/zip"
  require 'open-uri'
  include REXML

  def initialize
    @mirror_path = "http://thetvdb.com/api"
    api_key = "/4F5EC797A9F93512"
    @api_url = @mirror_path + api_key
  end

  def set_previous_time()
    xml = get_response_body_for("#{@mirror_path}/Updates.php?type=none")
    time = elements_from_xml("Time", xml)
    @previous_time = time[0].text
  end

  def get_series_from_remote(name)
    url = @mirror_path + "/GetSeries.php?seriesname=#{htmlize(name)}"
    xml = get_response_body_for(url)
    if !series_name_unknown?(xml)
      create_series_list(xml)
    else
      unknown_series
    end
  end

  def create_series_list(xml)
    series = elements_from_xml("Series", xml)
    series_list = []
    series.each do |series|
      id = series.elements["seriesid"].text
      name = series.elements["SeriesName"].text
      overview = series.elements["Overview"].try(:text)
      series_list << { series_id: id, series_name: name, series_overview: overview, last_remote_update: set_previous_time }
    end
    series_list
  end

  def get_response_body_for(url)
    url = URI.parse(url)
    res = Net::HTTP.get_response(url)
    res.body
  end

  def create_handle_for_zip(series_id)
    url = @api_url + "/series/#{series_id}/all/en.zip"
    open(url)
 end

  def unzip(zip)
    files = []
    Zip::ZipFile.open(zip) do |zipfile|
      zipfile.each do |entry|
        fpath = File.join("tmp/", entry.to_s)
        FileUtils.mkdir_p(File.dirname(fpath))
        zipfile.extract(entry, fpath){ true }
        files << File.open(fpath)
      end
    end
    files
  end

  def get_episodes(series_id)
    ziphandle = create_handle_for_zip(series_id)
    files = unzip(ziphandle)
    parsed_xml = Document.new files[0]
    root = parsed_xml.root
    root.elements.to_a('//Episode')
  end

  def elements_from_xml(attr, xml)
    parsed_xml = Document.new xml
    parsed_xml.elements.to_a("//#{attr}")
  end

  def htmlize(string)
    string.gsub(" ", "%20")
  end

  def series_name_unknown?(xml)
    elements_from_xml("seriesid", xml).first.nil?
  end

  def unknown_series
    raise ActionController::RoutingError.new('Series not found')
  end

  def retrieve_updates(previous_time)
    get_response_body_for("http://thetvdb.com/api/Updates.php?type=all&time=#{previous_time}")
  end

  def get_series_update(remote_id)
    url = @api_url + "/series/#{remote_id}/en.xml"
    get_response_body_for(url)
  end

  def get_episode_update(remote_id)
    url = @api_url + "/episodes/#{remote_id}/en.xml"
    get_response_body_for(url)
  end
end