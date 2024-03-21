class ForecastController < ApplicationController
  def show
    @address = params[:address]

    if @address
      response = Geocoder.search(@address)
    end
  end
end
