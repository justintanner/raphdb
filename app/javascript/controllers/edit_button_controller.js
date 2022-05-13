import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="edit-button"
export default class extends Controller {
  static targets = ["turboFrame", "offCanvas"];

  open(event) {
    const that = this;

    that.turboFrameTarget.src = event.params.url;

    const bsOffcanvas = new bootstrap.Offcanvas(that.offCanvasTarget);
    bsOffcanvas.show();
  }
}
