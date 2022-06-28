import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="filter-multiple-select"
export default class extends Controller {
  static targets = ["values", "value"]

  connect() {
    new TomSelect(this.valuesTarget, {
      plugins: {
        remove_button: {
          title: "Remove this item",
        }
      },
      persist: false,
      onChange: (values) => {
        this.valueTarget.value = values.join(",")
        this.valueTarget.dispatchEvent(new Event("change"))
      }
    });
  }
}
