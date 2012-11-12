class ApiConnector
  require 'net/http'

  def initialize
    mirror_path = "http://thetvdb.com"
    api_key = "4F5EC797A9F93512"
    api_url = mirror_path + "/api/" + api_key
    url = URI.parse("#{mirror_path}/api/Updates.php?type=none")
    res = Net::HTTP.get_response(url)
    ap res.body
    get_time_from_response(res)

  end

  def get_time_from_response(response)
    ap response.body
  end

  def getSeries
    #self.get_response_from_url("/GetSeries.php?seriesname=")
  end

end