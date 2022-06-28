import {DispatchController} from "./dispatch_controller"
import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

// Connects to data-controller="set-default"
export default class extends DispatchController {
  static values = { updatePath: String }

  set() {
    const that = this

    that.updateView()
  }

  async updateView() {
    const that = this
    const payload = { "view": { "default": true } }
    const response = await patch(that.updatePathValue, { body: JSON.stringify(payload) })

    that.dispatchError(response)
  }
}
