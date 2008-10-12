require 'open-uri'

module Through
  SERVER = 'http://through.helicoid.net'
  
  def self.locate(options = {})
    request "/location/#{options[:ip]}"
  end
  
  def self.time_zone(options = {})
    time_zone = request "/time_zone/#{options[:ip]}"
    if time_zone
      time_zone['rails'] = ActiveSupport::TimeZone::MAPPING.index(time_zone['country_name'])
    end
  end
  
  def self.request(url)
    response = open(SERVER + url).read
    ActiveSupport::JSON.decode response
  end
end