import { Controller } from "@hotwired/stimulus"
import Trix from "trix"

// Connects to data-controller="trix_editor_controller"
export default class extends Controller {
  static values = { paddingBottom: Number };

  connect() {
    const that = this;

    that.maxHeight();

    console.log("Trix editor connected");

    Trix.config.blockAttributes.heading2 = {
      tagName: "h2",
      terminal: true,
      breakOnReturn: true,
      group: false
    }

    const button ='<button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="Increase Level" tabIndex="-1" disabled="">Increase Level</button>';

    const groupElement = document.querySelector(".trix-button-group--block-tools");
    groupElement.insertAdjacentHTML("beforeend", button);
  }

  maxHeight() {
    const that = this;

    const newHeight = window.innerHeight - that.element.offsetTop - that.paddingBottomValue;
    that.element.style.setProperty("max-height", newHeight + "px", "important");
  }
}
