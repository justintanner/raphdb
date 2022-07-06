import {DispatchController} from "./dispatch_controller"
import {useDebounce} from "stimulus-use"

// Connects to data-controller="debounced-form"
export default class extends DispatchController {
  static targets = ["form"]
  static debounces = ["save"]

  connect() {
    useDebounce(this, { wait: 250 })
  }

  submit() {
    this.formTarget.requestSubmit()
  }
}
