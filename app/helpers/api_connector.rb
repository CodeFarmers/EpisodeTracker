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
    time = attribute_from_xml("Time", xml)
    @previous_time = time[0].text
  end

  def get_series(name)
    url = @mirror_path + "/GetSeries.php?seriesname=#{name}"
    xml = get_response_body_for(url)
    puts attribute_from_xml("seriesid", xml)

  end

  def get_response_body_for(url)
    url = URI.parse(url)
    res = Net::HTTP.get_response(url)
    res.body
  end

  def download_series_zip(url)
    url = URI.parse(url)
    Net::HTTP.get_response(url)
  end

  def attribute_from_xml(attr, xml)
    parsed_xml = Document.new xml
    XPath.match( parsed_xml, "//#{attr}")
  end
end
