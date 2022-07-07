import {DispatchController} from "./dispatch_controller"
import { useClickOutside } from "stimulus-use"
import { patch } from "@rails/request.js"

// Connects to data-controller="rename-view"
export default class extends DispatchController {
  static targets = ["dropdown", "container", "input"]
  static values = { updatePath: String }

  show() {
    this.dropdownTarget.classList.add("d-none")
    this.containerTarget.classList.remove("d-none")

    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(0, this.inputTarget.value.length)

    useClickOutside(this)
  }

  submit(event) {
    event.preventDefault()

    this.rename()
  }

  clickOutside() {
    this.rename()
  }

  rename() {
    this.dropdownTarget.classList.remove("d-none")
    this.containerTarget.classList.add("d-none")

    this.updateView(this.inputTarget.value)
  }

  async updateView(title) {
    const payload = { "view": { "title": title } }
    const response = await patch(this.updatePathValue, { body: JSON.stringify(payload) })

    this.dispatchError(response)
  }
}
