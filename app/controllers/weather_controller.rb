class WeatherController < ActionController::Base
  def index
    @weather, @location = DarkSkyService.get_the_weather
  end
end
