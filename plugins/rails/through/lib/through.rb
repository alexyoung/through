require 'open-uri'

module Through
  SERVER = 'http://through.helicoid.net'
  
  def self.locate(options = {})
    request "/location/#{options[:ip]}"
  end
  
  def self.time_zone(options = {})
    request "/time_zone/#{options[:ip]}"
  end
  
  def self.request(url)
    response = open(SERVER + url).read
    ActiveSupport::JSON.decode response
  end
end