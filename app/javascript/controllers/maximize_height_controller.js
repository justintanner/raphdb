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
    const newHeight = window.innerHeight - that.element.offsetTop - that.marginBottom() - that.footerHeight();

    that.element.style.setProperty("max-height", newHeight + "px", "important");
    that.element.style.setProperty("height", newHeight + "px", "important");
  }

  marginBottom() {
    const that = this;

    if (that.hasMarginBottomValue) {
      return that.marginBottomValue;
    }
    return 0;
  }

  footerHeight() {
    const that = this;

    if (that.hasFooterTarget) {
      return that.footerTarget.offsetHeight;
    }
    return 0;
  }
}
