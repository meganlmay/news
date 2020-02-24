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
  # do everything else

results = Geocoder.search(params["q"])
    @lat_long = results.first.coordinates # => [lat, long]
    @location = results.first.city

# Define the lat and long
@lat = "#{@lat_long [0]}"
@long = "#{@lat_long [1]}"

# Results from Geocoder
@forecast = ForecastIO.forecast("#{@lat}" , "#{@long}").to_hash

@current_temperature = @forecast["currently"]["temperature"]
@current_conditions = @forecast["currently"]["summary"]

# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]

  @daily_temperature = []
  @daily_conditions = []
  @daily_wind = []
  @daily_humidity = []

for @day_forecast in @forecast["daily"]["data"] do
  @daily_temperature << @day_forecast["temperatureHigh"]
  @daily_conditions << @day_forecast["summary"]
  @daily_wind << @day_forecast["windSpeed"]
  @daily_humidity << @day_forecast["humidity"]
end
@list = @daily_temperature, @daily_conditions, @daily_wind, @daily_humidity

# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=0007a9bfcdcf4108bd2f99b97bd7b655"
@news = HTTParty.get(url).parsed_response.to_hash

  @news_title = []
  @story_url = []

for daily_news in @news["articles"] do
  @news_title << daily_news["title"]
  @story_url << daily_news["url"]
  
end
@newslist = @news_title, @story_url

view "news"

end