require 'test_helper'

class ForecastServiceTest < ActiveSupport::TestCase

  test "called with valid parameters" do
    # Example address 201 E Randolph St, Chicago, IL 60602 (the Bean)
    latitude = 41.882629
    longitude = -87.623474

    forecasts = ForecastService.new(latitude, longitude)
    forecasts_array = forecasts.instance_variable_get(:@forecasts)
    single_forecast = forecasts_array.first

    # length is two because of current forecast and tomorrow forecast
    assert_equal(forecasts_array.length, 2)
    assert_includes 10..70, single_forecast.temperature
    assert_includes 10..70, single_forecast.temperature_min
    assert_includes 10..70, single_forecast.temperature_max
    assert_includes 0..100, single_forecast.humidity
    assert_includes 900..1100, single_forecast.pressure
    refute_empty single_forecast.description
  end

end
