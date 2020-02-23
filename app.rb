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
  # show a view that asks for the location
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    @location = params["q"]
  # News API
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=0007a9bfcdcf4108bd2f99b97bd7b655"
    news = HTTParty.get(url).parsed_response.to_hash
  # Define the lat and long
    lat_long = results.first.coordinates # => [lat, long]
    lat = "#{lat_long [0]}"
    long = "#{lat_long [1]}"
    forecast = ForecastIO.forecast("#{lat}","#{long}").to_hash
    @current_temperature = forecast["currently"]["temperature"]
    @conditions = forecast["currently"]["summary"]
    @forecast = forecast ["daily"]["data"]
    @paper = news ["articles"] 
    view "news"
end