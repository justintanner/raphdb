import {Controller} from "@hotwired/stimulus"
import {useDebounce} from "stimulus-use"
import {FetchRequest} from "@rails/request.js"
import toastError from "../toast_error"

// Connects to data-controller="filter-autosave"
export default class extends Controller {
  static targets = ["form"]
  static debounces = ["submit"]

  connect() {
    useDebounce(this, {wait: 250})
  }

  submit() {
    this.formTarget.requestSubmit()
  }

  xhr() {
    this.submitFormWithXhr()
  }

  async submitFormWithXhr() {
    const form = this.formTarget
    const methodInput = form.querySelector("input[name='_method']")
    let method = "post"

    if (methodInput) {
      method = methodInput.value
    }

    const request = new FetchRequest(method, form.action + ".json", {body: new FormData(form)})
    const response = await request.perform()

    if (response.statusCode === 422) {
      // Refetching the form from the backend to refresh dropwdown options.
      this.submit()
    } else if (response.statusCode !== 200) {
      toastError(this, response)
    }
  }
}
