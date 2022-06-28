import {DispatchController} from "./dispatch_controller"
import {useDebounce} from "stimulus-use"
import {FetchRequest} from "@rails/request.js"

// Connects to data-controller="filter"
export default class extends DispatchController {
  static targets = ["form", "label", "hiddenValue"]
  static debounces = ["save"]

  connect() {
    useDebounce(this, { wait: 250 })
    this.prettyLabels()
  }

  prettyLabels() {
    const filters = document.getElementById("filters")
    const rows = filters.querySelectorAll(".filter-row")
    const index = Array.from(rows).indexOf(this.element)

    if (index === 0) {
      this.labelTarget.innerHTML = "Where"
    } else {
      this.labelTarget.innerHTML = "and"
    }
  }

  reload() {
    console.log("filter_controller.js: reload()")
    this.formTarget.requestSubmit()
  }

  save() {
    this.submitForm()
  }

  async submitForm() {
    const form = this.formTarget
    const methodInput = form.querySelector("input[name='_method']")
    let method = "post"

    if (methodInput) {
      method = methodInput.value
    }

    const request = new FetchRequest(method, form.action + ".json", {body: new FormData(form)})
    const response = await request.perform()

    // Expecting filters to return 422 when as the user submits partially completed filters.
    if ((response.statusCode !== 200) && (response.statusCode !== 422)) {
      this.dispatchError(response)
    }
  }
}
