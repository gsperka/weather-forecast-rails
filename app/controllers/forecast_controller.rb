class ForecastController < ApplicationController
  def show
    @address = params[:address]

    if @address
      @geocode = GenerateCoordinatesService.new(@address)
      @forecast_cache_key = "#{@geocode.cache_key}"
      @forecast_cache_key_exist = Rails.cache.exist?(@forecast_cache_key)
      @forecasts = Rails.cache.fetch(@forecast_cache_key, expires_in: 30.minutes) do
        PopulateForecastService.new(@geocode.latitude, @geocode.longitude).forecasts          
      end
    end
  end
end
