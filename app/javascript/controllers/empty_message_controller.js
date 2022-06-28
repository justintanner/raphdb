import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="empty-message"
export default class extends Controller {
  connect() {
    const frame = document.getElementById("filters")

    if (frame.innerHTML.includes("filter_uuid_")) {
      this.element.classList.add("d-none")
    } else {
      this.element.classList.remove("d-none")
    }
  }
}
