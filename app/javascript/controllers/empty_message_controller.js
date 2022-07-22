import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="empty-message"
export default class extends Controller {
  static values = {prefix: String}

  connect() {
    const frame = document.getElementById(this.prefixValue + "s")

    if (frame.innerHTML.includes(this.prefixValue + "_uuid_")) {
      this.element.classList.add("d-none")
    } else {
      this.element.classList.remove("d-none")
    }
  }
}
