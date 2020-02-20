require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "YOUR-API-KEY"

get "/location" do
  # show a view that asks for the location
    @lat = rand(-90.0..90.0)
    @long = rand(-180.0..180.0)
    @lat_long = "#{@lat},#{@long}"
end

