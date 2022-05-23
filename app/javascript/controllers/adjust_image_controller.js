import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="adjust-image"
export default class extends Controller {
  connect() {
    const that = this;

    that.modalElement = document.getElementById("adjust-image-modal");
    that.modal = bootstrap.Modal.getOrCreateInstance(that.modalElement);
  }

  open(event) {
    const that = this;

    //  CropperJS initializes incorrectly if initialized before the modal is shown.
    that.modalElement.addEventListener("shown.bs.modal", () => {
      document.getElementById("image_editor_frame").src = event.params.url;
    });

    that.modal.show();
  }
}
