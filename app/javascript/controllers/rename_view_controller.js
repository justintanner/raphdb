import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rename-view"
export default class extends Controller {
  static targets = ["dropdown", "form", "input"];

  show() {
    const that = this;

    that.dropdownTarget.classList.add("d-none");
    that.formTarget.classList.remove("d-none");
    that.inputTarget.focus();
  }

  hide() {
    const that = this;

    that.dropdownTarget.classList.remove("d-none");
    that.formTarget.classList.add("d-none");
  }
}
