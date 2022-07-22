import {Controller} from "@hotwired/stimulus"
import Trix from "trix"

// Connects to data-controller="page_editor_controller"
export default class extends Controller {
  connect() {
    // TODO: Alignment does not work with headings
    Trix.config.blockAttributes.left = {
      tagName: "align-left",
      parse: false,
      nestable: true,
      exclusive: true
    }

    Trix.config.blockAttributes.center = {
      tagName: "align-center",
      parse: false,
      nestable: true,
      exclusive: true
    }

    Trix.config.blockAttributes.right = {
      tagName: "align-right",
      parse: false,
      nestable: true,
      exclusive: true
    }
  }
}
