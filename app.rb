require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "YOUR-API-KEY"

get "/" do
  view "geocode"
end

get "/map" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    "#{lat_long[0]} #{lat_long[1]}"
end 

# configure the Dark Sky API with your API key
ForecastIO.api_key = "8553542a76795ffd115abd7a4c012a1e"

# do the heavy lifting, use Global Hub lat/long
forecast = ForecastIO.forecast(42.0574063,-87.6722787).to_hash

# pp = pretty print
# use instead of `puts` to make reading a hash a lot easier
# e.g. `pp forecast`
pp forecast
current_temperature = forecast["currently"]["temperature"]
conditions = forecast["currently"]["summary"]
puts "In Evanston, it is currently #{current_temperature} and #{conditions}"
# puts high_temperature
# puts forecast["daily"]["data"][0]["temperatureHigh"]

for day in forecast["daily"]["data"]
    puts "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
end
