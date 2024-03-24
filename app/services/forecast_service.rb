require 'time'

class ForecastService
  attr_reader :forecasts

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @forecasts = []
    call_weather_api()
  end

  def call_weather_api
    conn = Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json
      f.request :retry
      f.response :json 
    end    

    today = get_current_weather(conn)
    parse_response(today.body)

    tomorrow = get_tomorrow_weather(conn)
    parse_response(tomorrow.body['list'].last) # this list contains 8 3-hour forecasts and we want the last one for tomorrow

    @forecasts
  end
  
  private 

  def get_current_weather(conn)
    conn.get('/data/2.5/weather', {
      appid: Rails.application.credentials.openweather_api_key,
      lat: @latitude,
      lon: @longitude,
      units: "imperial" # uses Farenheit instead of Celcius
    })
  end

  def get_tomorrow_weather(conn)
    conn.get('/data/2.5/forecast', {
      appid: Rails.application.credentials.openweather_api_key,
      lat: @latitude,
      lon: @longitude,
      cnt: 8,  # a count of 8 includes data for tomorrow
      units: "imperial"
    })
  end

  def parse_response(response)
    validate_response(response)
    validate_main(response)
    validate_temp(response)
    validate_weather(response)
    validate_date(response)
    create_forecast(response)
  end
    
  def validate_response(response)
    response or raise IOError.new "OpenWeather response body failed"
  end

  def validate_main(response)
    response["main"] or raise IOError.new "OpenWeather main section is missing"
  end

  def validate_temp(response)
    response["main"]["temp"] or raise IOError.new "OpenWeather temperature is missing"
    response["main"]["temp_min"] or raise IOError.new "OpenWeather temperature minimum is missing"
    response["main"]["temp_max"] or raise IOError.new "OpenWeather temperature maximum is missing"
  end

  def validate_date(response)
    response["dt"] or raise IOError.new "OpenWeather date section is missing"
  end

  def validate_weather(response)
    response["weather"] or raise IOError.new "OpenWeather weather section is missing"
    response["weather"].length > 0 or raise IOError.new "OpenWeather weather section is empty"
    response["weather"][0]["description"] or raise IOError.new "OpenWeather weather description is missing"
  end
 
  def create_forecast(weather_data)
    forecast = OpenStruct.new
    forecast.temperature = weather_data["main"]["temp"]
    forecast.temperature_min = weather_data["main"]["temp_min"]
    forecast.temperature_max = weather_data["main"]["temp_max"]
    forecast.humidity = weather_data["main"]["humidity"]
    forecast.pressure = weather_data["main"]["pressure"]
    forecast.date = format_date(weather_data["dt"])
    forecast.description = weather_data["weather"][0]["description"]
    @forecasts << forecast
  end

  def format_date(unix_time)
    unix = Time.at(unix_time)
    unix.localtime().strftime("%m/%d/%Y")
  end
end
