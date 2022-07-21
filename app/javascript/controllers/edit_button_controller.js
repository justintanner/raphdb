import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="edit-button"
export default class extends Controller {
  open(event) {
    const frame = document.getElementById("edit_item_frame")
    frame.src = event.params.url

    this.showOffCanvas()
  }

  switchTabs(event) {
    const frame = document.getElementById("edit_item_frame")
    frame.src = event.params.url
  }

  showOffCanvas() {
    const frame = document.getElementById("edit_item_frame")
    const offCanvasElement = document.getElementById("edit_item_offcanvas")
    const bsOffcanvas = new bootstrap.Offcanvas(offCanvasElement)
    bsOffcanvas.show()

    // Save data, If the user edits and quickly closes the offcanvas.
    offCanvasElement.addEventListener("hidden.bs.offcanvas", () => {
      const form = frame.querySelector("form")
      if (form) {
        form.requestSubmit();
      }
    })
  }
}

