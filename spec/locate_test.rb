require 'sinatra'
require 'spec/interop/test'
require 'sinatra/test/unit'

include Sinatra::Test::Methods

Sinatra::Application.default_options.merge!(
  :env => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

describe 'Locate' do
  require 'locate'

  it 'should look up IP addresses' do
    get_it '/location/80.68.87.32'
    @response.should be_ok
    @response.body.should match(/United Kingdom/)
  end

  it 'should look up time zones' do
    get_it '/time_zone/80.68.87.32'
    
    @response.should be_ok
    @response.body.should match(%r{Europe/London})
  end
end
