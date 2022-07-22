import {Controller} from "@hotwired/stimulus"
import ClipboardJS from "clipboard"

// Connects to data-controller="share"
export default class extends Controller {
  connect() {
    const that = this

    const clipboard = new ClipboardJS(that.element)
    const originalHtml = that.element.innerHTML

    clipboard.on("success", function(e) {
      that.element.innerHTML = '<i class="bi bi-check"></i><span class="ms-1"><small>Copied!</small></span>'

      setTimeout(function() {
        that.element.innerHTML = originalHtml
      }, 2000)
    })
  }
}
