import {Controller} from "@hotwired/stimulus"
import store from "storejs"

// Connects to data-controller="keep-focus"
export default class extends Controller {
  connect() {
    const that = this

    that.key = `keep_focus_for_${that.element.id}`
    that.refocus()

    that.element.addEventListener("focus", (event) => {
      that.saveId(event.target)
    }, true)
  }

  refocus() {
    const id = store.get(this.key)

    if (id) {
      const element = document.getElementById(id)

      if (element) {
        const endPosition = element.value.length
        element.focus()
        element.setSelectionRange(endPosition, endPosition)
      }
    }
  }

  saveId(target) {
    store.set(this.key, target.id)
  }
}
