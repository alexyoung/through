require 'rubygems'
require 'sinatra'
require 'geoip_city'
require 'fastercsv'

# For to_json
require 'active_support'

class Locate
  CITY_DATA_FILE = 'data/GeoLiteCity.dat'
  TIME_ZONE_FILE = 'data/timezone.txt'
  
  def initialize
    @db = GeoIPCity::Database.new CITY_DATA_FILE
    @time_zones = FCSV.parse(File.read(TIME_ZONE_FILE), :col_sep => "\t")
  end
  
  def from_ip(remote_ip)
    @db.look_up remote_ip
  end
  
  # This returns a TZInfo-compatible identifier
  def time_zone_for_location(location)
    time_zone = @time_zones.find do |country, region, zone|
      if location[:country_code] == 'US' and country == 'US' and region == location[:region]
        true
      elsif country != 'US' and location[:country_code] == country
        true
      end
    end
    
    { :country_code => time_zone[0], :region => time_zone[1], :country_name => time_zone[2] }
  end
end

locator = Locate.new

# http://localhost:4567/location/80.68.87.32
get '/location/*' do
  location = locator.from_ip params[:splat].first
  location.to_json
end

# Return the time zone for a given IP
# http://localhost:4567/time_zone/80.68.87.32
get '/time_zone/*' do
  location = locator.from_ip params[:splat].first
  locator.time_zone_for_location(location).to_json
end