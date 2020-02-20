require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "8553542a76795ffd115abd7a4c012a1e"

get "/" do
  # lat: ± 90.0
  # long: ± 180.0
  @lat = rand(-90.0..90.0)
  @long = rand(-180.0..180.0)
  @lat_long = "#{@lat},#{@long}"
  view "geocode"
end