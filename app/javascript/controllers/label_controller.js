import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="label"
export default class extends Controller {
  static values = { first: String, nth: String, containerId: String }

  connect() {
    const container = document.getElementById(this.containerIdValue)
    const labels = Array.from(container.querySelectorAll("[data-controller='label']"))

    if (!labels) {
      return
    }

    const index = labels.indexOf(this.element)

    if (index === 0) {
      this.element.innerHTML = this.firstValue
    } else {
      this.element.innerHTML = this.nthValue
    }
  }
}
