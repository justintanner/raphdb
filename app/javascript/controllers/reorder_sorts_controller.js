import {DispatchController} from "./dispatch_controller"
import {Sortable} from "sortablejs"

// Connects to data-controller="reorder-sorts"
export default class extends DispatchController {
  static targets = ["container", "form", "uuid", "position"]

  connect() {
    console.log("connecting to reorder-sorts")
    const that = this

    that.sortable = Sortable.create(that.containerTarget, {
      handle: ".handle",
      filter: "#sort_empty_message",
      animation: 150,
      onEnd: that.submitForm.bind(that),
    })
  }

  submitForm(event) {
    const uuid = event.item.id.replace("sort_uuid_", "")
    // Would add +1 to position below, but the empty message turbo frame is at position 0.
    const position = event.newIndex

    this.uuidTarget.value = uuid
    this.positionTarget.value = position
    this.formTarget.requestSubmit()
  }
}
