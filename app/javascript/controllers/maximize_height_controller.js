import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="maximize-height"
export default class extends Controller {
  static values = { marginBottom: Number }
  static targets = ["wrapper", "footer"]

  connect() {
    this.style()
  }

  style() {
    const newHeight = window.innerHeight - this.element.offsetTop - this.marginBottom() - this.footerHeight()

    let target = this.element

    if (this.hasWrapperTarget) {
      target = this.wrapperTarget
    }

    target.style.setProperty("max-height", newHeight + "px", "important")
    target.style.setProperty("height", newHeight + "px", "important")
  }

  marginBottom() {
    if (this.hasMarginBottomValue) {
      return this.marginBottomValue
    }
    return 0
  }

  footerHeight() {
    if (this.hasFooterTarget) {
      return this.footerTarget.offsetHeight
    }
    return 0
  }
}
