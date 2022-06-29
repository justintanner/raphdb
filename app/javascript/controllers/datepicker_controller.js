import {Controller} from "@hotwired/stimulus"
import "vanillajs-datepicker"

// Connects to data-controller="datepicker"
export default class extends Controller {
  static values = {format: String}

  connect() {
    const that = this

    that.datepicker = new Datepicker(that.element, {
      showDaysOfWeek: false,
      autohide: true,
      maxView: 3,
      startView: 2,
      format: this.formatValue,
    })

    that.element.addEventListener("changeDate", function (_e, _details) {
      // This will get picked up by the filter-controller.
      that.element.dispatchEvent(new Event("input"))
    })
  }
}
