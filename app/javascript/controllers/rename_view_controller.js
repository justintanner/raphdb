import {Controller} from "@hotwired/stimulus"
import {useClickOutside} from "stimulus-use"

// Connects to data-controller="rename-view"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    const that = this
    that.inputTarget.focus()
    that.inputTarget.setSelectionRange(0, that.inputTarget.value.length)

    useClickOutside(that, {element: that.inputTarget})

    that.inputTarget.addEventListener("keydown", function(event) {
      if (event.key === "Escape") {
        that.submit();
      }
    }, true);
  }

  clickOutside() {
    this.submit()
  }

  submit() {
    this.element.requestSubmit()
  }
}
