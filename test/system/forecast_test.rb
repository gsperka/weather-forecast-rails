require "application_system_test_case"

class ForecastTest < ApplicationSystemTestCase

  test "show" do
    address = Faker::Address.full_address
    visit url_for \
      controller: "forecast", 
      action: "show", 
      params: { 
        address: address 
      }
      
    assert_selector "h1", text: "Forecast#show"
  end

end