require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "8553542a76795ffd115abd7a4c012a1e"

# News API
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=0007a9bfcdcf4108bd2f99b97bd7b655"
    news = HTTParty.get(url).parsed_response.to_hash

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates #=> [lat, long]
    location = results.first.city
  # Define the lat and long
    @lat = "#{lat_long [0]}"
    @long = "#{lat_long [1]}"
    @lat_long = "#{@lat},#{@long}"
  # Results from Geocoder
    forecast = ForecastIO.forecast("#{lat_long [0]}","#{lat_long[1]}").to_hash
    current_temperature = forecast["currently"]["temperature"]
    conditions = forecast["currently"]["summary"]
  # high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
  # puts high_temperature
  # puts forecast["daily"]["data"][1]["temperatureHigh"]
  # puts forecast["daily"]["data"][2]["temperatureHigh"]
    view "news"
end