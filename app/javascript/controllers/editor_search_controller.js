import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="editor-search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    const that = this

    that.inputTarget.onkeydown = (event) => {
      if (that.isEscape(event)) {
        that.clear();
      }
    };
  }

  isEscape(event) {
    if ("key" in event) {
      return (event.key === "Escape" || event.key === "Esc")
    } else {
      return (event.keyCode === 27)
    }
  }

  clear() {
    this.inputTarget.value = ""
    this.element.requestSubmit()
  }
}
