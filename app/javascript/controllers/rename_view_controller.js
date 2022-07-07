import {Controller} from "@hotwired/stimulus"
import {useClickOutside} from "stimulus-use"

// Connects to data-controller="rename-view"
export default class extends Controller {
  static targets = ["input"]

  // TODO: Escape should also submit the form.
  connect() {
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(0, this.inputTarget.value.length)

    useClickOutside(this, {element: this.inputTarget})
  }

  clickOutside() {
    this.element.requestSubmit()
  }
}
