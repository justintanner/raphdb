import {Controller} from "@hotwired/stimulus"
import {Sortable} from "sortablejs"

// Connects to data-controller="reorder-sorts"
export default class extends Controller {
  static targets = ["container", "form", "uuid", "position"]

  connect() {
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
