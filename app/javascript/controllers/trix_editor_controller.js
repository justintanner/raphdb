import { Controller } from "@hotwired/stimulus"
import Trix from "trix"

// Connects to data-controller="trix_editor_controller"
export default class extends Controller {
  static values = { paddingBottom: Number };

  connect() {
    const that = this;

    that.maxHeight();

    console.log("Trix editor connected");

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
