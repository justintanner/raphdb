import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maximize-height"
export default class extends Controller {
  static values = { marginBottom: Number };
  static targets = ["footer"];

  connect() {
    const that = this;

    that.style();
  }

  style() {
    const that = this;

    let offset = 0;

    console.log(that.element, that.footerTarget);

    if (that.hasMarginBottomValue) {
      offset += that.marginBottomValue;
      console.log("offset", offset);
    }

    if (that.hasFooterTarget) {
      offset += that.footerTarget.offsetHeight;
      console.log("offset", offset);
    }

    const newHeight = window.innerHeight - that.element.offsetTop - offset;
    that.element.style.setProperty("max-height", newHeight + "px", "important");
    that.element.style.setProperty("height", newHeight + "px", "important");
  }
}
