import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

// Connects to data-controller="set-default"
export default class extends Controller {
  static values = { updatePath: String }

  set() {
    const that = this

    that.updateView()
  }

  async updateView() {
    const that = this
    const payload = { "view": { "default": true } }
    const response = await patch(that.updatePathValue, { body: JSON.stringify(payload) })

    if (!response.ok) {
      const json = await response.json

      that.dispatch("error", {target: document, prefix: null, detail: {json: json}})
    }
  }
}
