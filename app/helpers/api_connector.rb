class ApiConnector
  require 'net/http'
  require "rexml/document"
  include REXML

  def initialize
    mirror_path = "http://thetvdb.com"
    api_key = "4F5EC797A9F93512"
    api_url = mirror_path + "/api/" + api_key
    url = URI.parse("#{mirror_path}/api/Updates.php?type=none")
    res = Net::HTTP.get_response(url)
    time_from_response = get_time_from_response(res)
    set_previous_time(time_from_response)

  end

  def set_previous_time(previous_time)
    @previous_time = previous_time
  end

  def get_time_from_response(res)
    parsed_body = Document.new res.body
    time = XPath.match( parsed_body, "//Time" )
    time[0].text
  end

  def getSeries
    #self.get_response_from_url("/GetSeries.php?seriesname=")
  end

end