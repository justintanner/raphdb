import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="filter-single-select"
export default class extends Controller {
  connect() {
    new TomSelect(this.element, {
      plugins: ['dropdown_input'],
      persist: false
    })
  }
}
