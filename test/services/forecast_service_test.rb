require 'test_helper'
require 'rspec'

class ForecastServiceTest < ActiveSupport::TestCase

  test "called with valid parameters" do
    # Example address 201 E Randolph St, Chicago, IL 60602 (the Bean)
    latitude = 41.882629
    longitude = -87.623474

    forecasts = ForecastService.new(latitude, longitude).forecasts
    ## finish test
  end

end
