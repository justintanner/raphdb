import {Controller} from "@hotwired/stimulus"
import "vanillajs-datepicker"

// Connects to data-controller="datepicker"
export default class extends Controller {
  static values = {format: String};

  connect() {
    const datepicker = new Datepicker(this.element, {
      format: this.formatValue,
    })
  }
}
