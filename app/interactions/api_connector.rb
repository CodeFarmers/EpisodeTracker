class ApiConnector
  require 'net/http'
  require "rexml/document"
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
      create_series_hash(xml)
    else
      unknown_series
    end
  end

  def create_series_hash(xml)
    series_ids = elements_from_xml("seriesid", xml)
    series_names = elements_from_xml("SeriesName", xml)
    series_overviews = elements_from_xml("Overview", xml)
    series_hash = {}
    series_ids.length.times do |i|
      series_hash[i] = { :series_id => series_ids[i].text, :series_name => series_names[i].text, :series_overview =>series_overviews[i].text }
    end
    series_hash
  end

  def get_response_body_for(url)
    url = URI.parse(url)
    res = Net::HTTP.get_response(url)
    res.body
  end

  def download_series_zip(url)
    #url = URI.parse(url)
    #Net::HTTP.get_response(url)
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
