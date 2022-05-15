import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["submit", "spinner"];

  connect() {
  }

  submit() {
    const that = this;
    that.submitTarget.click();
    // TODO: Need to scroll to the bottom when there are many images.
    that.spinnerTarget.classList.remove("d-none");
  }
}
