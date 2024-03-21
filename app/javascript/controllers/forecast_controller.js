import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"];

  connect() {
    if (typeof(google) != undefined) {
      this.initAutocomplete()
    }
  }

  initAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete((this.fieldTarget), {
      types: ['geocode']	
    });
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
  }

  placeChanged() {
    let place = this.autocomplete.getPlace();
    
    if (!place.geometry) {
      window.alert(`No details are available for input:" ${place.name}`)
      return;
    }
  }

  keydown(event) {
    if (event.key == "Enter") {
      event.preventDefault();
    }
  }
}
