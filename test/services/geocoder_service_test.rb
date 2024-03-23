require 'test_helper'

class GeocoderServiceTest < ActiveSupport::TestCase

  test "called with valid parameters and valid zipcode as cache key" do
    address = "201 E Randolph St, Chicago, IL 60602"
    geocode = GeocoderService.new(address)
    address = geocode.instance_variable_get(:@address)
    latitude = geocode.instance_variable_get(:@latitude)
    longitude = geocode.instance_variable_get(:@longitude)
    cache_key = geocode.instance_variable_get(:@cache_key)
    
    assert_equal(address, "201 E Randolph St, Chicago, IL 60602")
    assert_equal(latitude, 41.884274553396665)
    assert_equal(longitude, -87.62394217073906)
    assert_equal(cache_key, "60601")
  end

  test "called with valid parameters and place_id is set as cache key" do
    address = "London, UK" # has no zipcode
    geocode = GeocoderService.new(address)
    address = geocode.instance_variable_get(:@address)
    cache_key = geocode.instance_variable_get(:@cache_key)
    
    assert_equal(address, "London, UK")
    assert_equal(cache_key, 273845995)
  end

end
