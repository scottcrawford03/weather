class DarkSkyService

  class << self
    def get_the_weather
      response = darksky_request
      [response.parsed_response["currently"]["summary"].downcase, "#{location.city}, #{location.state}"] if response
    end

    private

    def location
      Geocoder.search("37.8267,-122.4233").first
    end

    def darksky_request
      if number_of_calls_for_today <= 1000
        HTTParty.get("#{darksky_url_base}/#{darksky_api_key}/37.8267,-122.4233").tap do |response|
          new_number_of_calls = response.headers.fetch("x-forecast-api-calls").to_i
          update_number_of_calls(new_number_of_calls)
        end
      end
    end

    def update_number_of_calls(new_number_of_calls = 0)
      Rails.cache.delete("number_of_calls_for_today")
      expires_in_seconds = Time.now.end_of_day - Time.now
      Rails.cache.fetch("number_of_calls_for_today", expires_in: expires_in_seconds) do
        new_number_of_calls
      end
    end

    def darksky_api_key
      Rails.application.secrets.fetch(:darksky_api_key)
    end

    def darksky_url_base
      "https://api.darksky.net/forecast"
    end

    def number_of_calls_for_today
      Rails.cache.read("number_of_calls_for_today") || update_number_of_calls
    end
  end
end
