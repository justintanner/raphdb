import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-button"
export default class extends Controller {
  open(event) {
    const frame = document.getElementById("edit_item_frame")
    const offCanvasElement = document.getElementById("edit_item_offcanvas")

    frame.src = event.params.url

    const bsOffcanvas = new bootstrap.Offcanvas(offCanvasElement)
    bsOffcanvas.show()
  }
}
