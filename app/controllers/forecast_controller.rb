class ForecastController < ApplicationController
  def show
    @address = params[:address]

    if @address
      begin
        @geocode = GeocoderService.new(@address)
        @forecast_cache_key = "#{@geocode.cache_key}"
        @forecast_cache_key_exist = Rails.cache.exist?(@forecast_cache_key)
        @forecasts = Rails.cache.fetch(@forecast_cache_key, expires_in: 30.minutes) do
          ForecastService.new(@geocode.latitude, @geocode.longitude).forecasts          
        end
        flash.clear 

      rescue => e
        flash.alert = e.message
      end
    end
  end
end
