import { Controller } from "@hotwired/stimulus"
import Trix from "trix"

// Connects to data-controller="page_editor_controller"
export default class extends Controller {
  static values = { paddingBottom: Number };

  connect() {
    const that = this;

    that.maxHeight();

    /* TODO: Alignment does not work with headings */
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

  maxHeight() {
    const that = this;

    const newHeight = window.innerHeight - that.element.offsetTop - that.paddingBottomValue;
    that.element.style.setProperty("max-height", newHeight + "px", "important");
  }
}
