import {Controller} from "@hotwired/stimulus"
import {useDebounce} from "stimulus-use"
import {FetchRequest} from "@rails/request.js"
import toastError from "../toast_error"

// Connects to data-controller="autosave"
export default class extends Controller {
  static targets = ["form"]
  static debounces = ["submit", "xhr"]

  connect() {
    useDebounce(this, {wait: 250})
  }

  submit() {
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

    this.clearAllErrors()

    if (response.statusCode === 422) {
      const json = await response.json
      this.displayErrors(json)
    } else if (response.statusCode !== 200) {
      toastError(this, response)
    }
  }

  displayErrors(json) {
    json.errors.forEach(error => {
      const field = document.getElementById(error.id)
      const feedback = document.getElementById(error.id + "_feedback")

      if (field) {
        field.classList.add("is-invalid")
      }
      if (feedback) {
        feedback.innerHTML = error.message
      }
    })
  }

  clearAllErrors() {
    const fields = document.querySelectorAll(".is-invalid")
    fields.forEach(field => {
      field.classList.remove("is-invalid")
    })

    const feedbacks = document.querySelectorAll(".invalid-feedback")
    feedbacks.forEach(feedback => {
      feedback.innerHTML = ""
    })
  }
}
