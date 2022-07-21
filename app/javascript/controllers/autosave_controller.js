import {DispatchController} from "./dispatch_controller"
import {useDebounce} from "stimulus-use"
import {FetchRequest} from "@rails/request.js"

// Connects to data-controller="autosave"
export default class extends DispatchController {
  static targets = ["form"]
  static values = {"dirty": Boolean}
  static debounces = ["submit"]

  connect() {
    useDebounce(this, {wait: 250})
  }

  submit() {
    if (this.hasDirtyValue && this.dirtyValue) {
      this.formTarget.requestSubmit()
    } else {
      this.submitFormWithJson()
    }
  }

  async submitFormWithJson() {
    const form = this.formTarget
    const methodInput = form.querySelector("input[name='_method']")
    let method = "post"

    if (methodInput) {
      method = methodInput.value
    }

    const request = new FetchRequest(method, form.action + ".json", {body: new FormData(form)})
    const response = await request.perform()

    if (response.statusCode === 422) {
      // Resubmit the form to get form errors rendered on the page.
      this.formTarget.requestSubmit()
    } else if (response.statusCode !== 200) {
      this.dispatchError(response)
    }
  }
}
