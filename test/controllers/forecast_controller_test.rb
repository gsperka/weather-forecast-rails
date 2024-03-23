require "test_helper"

class ForecastControllerTest < ActionDispatch::IntegrationTest

  test "show with a valid input address" do
    address = '2543 North California Avenue, Chicago, IL, USA'
    get '/', params: { address: address }
    assert_response :success
  end

  test "show throws a flash error message with an invalid input address" do
    address = Faker::Address.full_address
    get '/', params: { address: address }
    assert_equal 'Geocoder is empty: []', flash[:alert]
  end
end