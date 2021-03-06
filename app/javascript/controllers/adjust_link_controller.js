import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="adjust-link"
export default class extends Controller {
  connect() {
    this.modalElement = document.getElementById("image_editor_modal")
    this.modal = bootstrap.Modal.getOrCreateInstance(this.modalElement)
  }

  open(event) {
    const that = this
    const frame = document.getElementById("image_editor_frame")

    //  CropperJS loads incorrectly if initialized before the modal is shown.
    that.modalElement.addEventListener("shown.bs.modal", () => {
      frame.src = event.params.url
    })

    // Prevents the previously adjusted image from showing up on load.
    frame.innerHTML = ""
    that.modal.show()
  }
}
