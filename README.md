# Weather Forecast app with Ruby on Rails 

## To View Staging

Visit https://weather-forecast-rails.onrender.com/.

This is a free service hosted on [Render](https://render.com/) and it will take roughly 30 seconds to load.

## To View Locally: Clone Repo

This app was created on an M3 Macbook Air using Sonoma 14.4. It uses Rails 7 and Ruby 3.3.0.

```
cd ~/Desktop 
git clone https://github.com/gsperka/weather-forecast-rails.git
cd weather-forecast-rails
bundle install
```

# API Credentials - Sign Up is Needed
## ArcGIS

[Arcgis API](https://developers.arcgis.com/sign-up/) is needed in order to utilize the Geocoder gem to get the latitude and longitude.

Create `config/initializers/geocoder.rb`:

```ruby
Geocoder.configure(
    esri: {
        api_key: [
            Rails.application.credentials.arcgis_api_user_id, 
            Rails.application.credentials.arcgis_api_secret_key,
        ], 
        for_storage: true
    }
)
```

Edit Rails credentials and add keys locally:

```sh
EDITOR="code --wait"  bin/rails credentials:edit
```

```ruby
arcgis_api_user_id: abc
arcgis_api_secret_key: xyz
```

## OpenWeather API

[OpenWeather API](https://openweathermap.org) is used to get the actual weather forecast data.

Edit Rails credentials and add keys locally:

```sh
EDITOR="code --wait"  bin/rails credentials:edit
```

```ruby
openweather_api_key: xyz
```

## Google API

[The Google Autocomplete API](https://developers.google.com/maps/documentation/places/web-service/autocomplete) is used for the autocomplete functionality in the search input field. 


Edit Rails credentials and add keys locally:

```sh
EDITOR="code --wait"  bin/rails credentials:edit
```

```ruby
google_geocode_api_key: xyz
```

### Enable the cache

Enable the Rails development cache as this is used for caching the forecast result.

```sh
bin/rails dev:cache
```

## Test and Run Locally

```sh
% bin/rails test
% bin/rails server -d
```

Browse to <http://127.0.0.1:3000>

## Known Issues

- The Openweather API has a paid plan that gives your the daily forecast for 16 day. This is ideal for a production envivonment. 
 
  - To get the forecast for tomorrow (for free), a second call to a different endpoint is needed to get the five day forecast in three hour intervals. This presents problems with timezones being displayed on the UI. 
   

- The directions ask for zipcodes being stored as the cache key. The ArcGIS API doesn't always return a zipcode. If this is the case, the `place_id` is stored instead. A test was written to cover this: 

```
  test "called with valid parameters and place_id is set as cache key" do
    address = "London, UK" # has no zipcode
    geocode = GeocoderService.new(address)
    address = geocode.instance_variable_get(:@address)
    cache_key = geocode.instance_variable_get(:@cache_key)
    
    assert_equal(address, "London, UK")
    assert_equal(cache_key, 273845995)
  end

```