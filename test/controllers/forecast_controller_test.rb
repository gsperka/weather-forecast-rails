require "test_helper"

class ForecastControllerTest < ActionDispatch::IntegrationTest

  test "show with a valid input address" do
    address = '2543 North California Avenue, Chicago, IL, USA'
    get '/', params: { address: address }
    assert_response :success
  end

end