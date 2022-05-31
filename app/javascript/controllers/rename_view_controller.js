import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"
import { patch } from "@rails/request.js"

// Connects to data-controller="rename-view"
export default class extends Controller {
  static targets = ["dropdown", "container", "input"]
  static values = { updatePath: String }
  show(event) {
    const that = this

    that.dropdownTarget.classList.add("d-none")
    that.containerTarget.classList.remove("d-none")

    that.inputTarget.focus()
    that.inputTarget.setSelectionRange(0, that.inputTarget.value.length)

    useClickOutside(that)
  }

  clickOutside() {
    const that = this

    that.dropdownTarget.classList.remove("d-none")
    that.containerTarget.classList.add("d-none")

    that.rename(that.inputTarget.value)
  }

  async rename(title) {
    const that = this;
    const payload = { "view": { "title": title } };
    const response = await patch(that.updatePathValue, { body: JSON.stringify(payload) });

    if (!response.ok) {
      const json = await response.json;

      that.dispatch("error", {target: document, prefix: null, detail: {json: json}});
    }
  }
}
