Geocoder.configure(
  timeout: 3,                 # geocoding service timeout (secs)
  language: :en,              # ISO-639 language code
  use_https: true,            # use HTTPS for lookup requests? (if supported)

  esri: {
    api_key: [
        Rails.application.credentials.arcgis_api_user_id, 
        Rails.application.credentials.arcgis_api_secret_key,
    ], 
    for_storage: true
  }
)
