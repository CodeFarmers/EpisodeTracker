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
    series_ids = elements_from_xml("seriesid", xml)
    series_names = elements_from_xml("SeriesName", xml)
    series_overviews = elements_from_xml("Overview", xml)
    ##When an overview is not present, wrong series get the wrong overviews
    ap series_overviews
    series_list = []
    series_ids.length.times do |i|
      series_list << {:series_id => series_ids[i].try(:text), :series_name => series_names[i].try(:text), :series_overview => series_overviews[i].try(:text)}
    end
    series_list
  end

  def get_response_body_for(url)
    url = URI.parse(url)
    res = Net::HTTP.get_response(url)
    res.body
  end
  See Dad Run
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
end
