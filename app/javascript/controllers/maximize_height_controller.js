import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maximize-height"
export default class extends Controller {
  static values = { marginBottom: Number };
  static targets = ["wrapper", "footer"];

  connect() {
    const that = this;

    that.style();
  }

  style() {
    const that = this;
    const newHeight = window.innerHeight - that.element.offsetTop - that.marginBottom() - that.footerHeight();

    let target = that.element;

    if (that.hasWrapperTarget) {
      target = that.wrapperTarget;
    }

    target.style.setProperty("max-height", newHeight + "px", "important");
    target.style.setProperty("height", newHeight + "px", "important");
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
