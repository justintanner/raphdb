import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="adjust-link"
export default class extends Controller {
  connect() {
    const that = this;

    that.modalElement = document.getElementById("image_editor_modal");
    that.modal = bootstrap.Modal.getOrCreateInstance(that.modalElement);
  }

  open(event) {
    const that = this;
    const frame = document.getElementById("image_editor_frame");
    const innerContainer = that.modalElement.querySelector(".image-editor-inner-container");

    //  CropperJS loads incorrectly if initialized before the modal is shown.
    that.modalElement.addEventListener("shown.bs.modal", () => {
      frame.src = event.params.url;
    });

    // Prevents the previously adjusted image from showing up on load.
    innerContainer.innerHTML = "";
    that.modal.show();
  }
}
