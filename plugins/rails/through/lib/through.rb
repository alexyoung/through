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
    time_zone
  end
  
  def self.request(url)
    Timeout::timeout(3) do
      response = open(SERVER + url).read
      ActiveSupport::JSON.decode response
    end
  rescue Timeout::Error
    nil
  end
end