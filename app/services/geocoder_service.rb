class GeocoderService
  attr_reader :address, :latitude, :longitude, :cache_key

  def initialize(address)
    @address = address
    @latitude = nil 
    @longitude = nil 
    @cache_key = nil 
    search_geocode()
  end

  private

  def search_geocode()
    response = Geocoder.search(@address)
    validate_response(response)
    data = parse_response(response)
    populate_coordinates(data)
  end
  
  def populate_coordinates(data)
    @latitude = data["lat"].to_f
    @longitude = data["lon"].to_f
    @cache_key = set_cache_key(data)
  end

  private 

  def set_cache_key(data)
    # in some instances, postcode does not come back from the ESRI ArcGIS API
    # if that is the case, use the place_id which is unique and always comes back
    if data["address"]["postcode"]
      return data["address"]["postcode"]
    else
      return data["place_id"]
    end
  end

  def validate_response(response)
    response or raise IOError.new "Geocoder error"
    response.length > 0 or raise IOError.new "Geocoder is empty: #{response}"
  end

  def parse_response(response)
    data = response.first.data
    validate_data(data)
    validate_lat(data)
    validate_lon(data)
    validate_address(data)
    data
  end

  def validate_data(data)
    data or raise IOError.new "Geocoder data error"
  end

  def validate_lat(data)
    data["lat"] or raise IOError.new "Geocoder latitude is missing"
  end

  def validate_lon(data)
    data["lon"] or raise IOError.new "Geocoder longitude is missing"
  end

  def validate_address(data)
    data["address"] or raise IOError.new "Geocoder address is missing" 
  end
end
