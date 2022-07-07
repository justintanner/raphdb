import {DispatchController} from "./dispatch_controller"
import { patch } from "@rails/request.js"

// Connects to data-controller="set-default"
export default class extends DispatchController {
  static values = { updatePath: String }

  set() {
    this.updateView()
  }

  async updateView() {
    const payload = { "view": { "default": true } }
    const response = await patch(this.updatePathValue, { body: JSON.stringify(payload) })

    this.dispatchError(response)
  }
}
