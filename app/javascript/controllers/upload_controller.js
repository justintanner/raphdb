import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["submit", "spinner"]

  submit() {
    this.submitTarget.click()
    // TODO: Need to scroll to the bottom when there are many images.
    this.spinnerTarget.classList.remove("d-none")
  }
}
