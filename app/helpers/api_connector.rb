class ApiConnector
  require 'net/http'

  def initialize
    @mirror_path = "http://thetvdb.com"
    @api_key = "4F5EC797A9F93512"
    @api_url = @mirror_path + "/api/" + @api_key

    self.get_response_from_url("/Updates.php?type=none")
    ap "Hello"

  end



  def getSeries
    self.get_response_from_url("/GetSeries.php?seriesname=")
  end




  def get_response_from_url(url)
    url = URI.parse("#{@mirror_path}/api#{url}")
    ap url
    res = Net::HTTP.get_response(url)
    #req = Net::HTTP::Get.new(url.path)
    #res = Net::HTTP.start(url.host, url.port) {|http|
    #  ap req
    #  http.request(req)
    #}
    ap res
  end
end