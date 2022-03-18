import { Controller } from "@hotwired/stimulus"
import ClipboardJS from "clipboard"

// Connects to data-controller="clipboard"
export default class extends Controller {
  connect() {
    const that = this;

    const clipboard = new ClipboardJS("#copy-link");
    const originalHtml = that.element.innerHTML;

    clipboard.on("success", function(e) {
      that.element.innerHTML = that.svgCheck() + '<span class="ms-1"><small>Copied!</small></span>';

      setTimeout(function() {
        that.element.innerHTML = originalHtml;
      }, 2000);
    });
  }

  svgCheck() {
    return '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check" viewBox="0 0 16 16"><path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/></svg>';
  }
}
