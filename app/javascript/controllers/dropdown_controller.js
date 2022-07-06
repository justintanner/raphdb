import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["button"]
  static classes = ["buttonActive"]
  static values = {type: String}

  connect() {
    const that = this

    that.element.addEventListener("hidden.bs.dropdown", () => {
      that.setActive()
    })
  }

  close() {
    const dropdown = bootstrap.Dropdown.getOrCreateInstance(this.buttonTarget)

    dropdown.hide()
  }

  setActive() {
    if (this.isActive()) {
      this.buttonTarget.classList.add(this.buttonActiveClass)
    } else {
      this.buttonTarget.classList.remove(this.buttonActiveClass)
    }
  }

  isActive() {
    return document.getElementById(this.typeValue + "s").innerHTML.includes(`${this.typeValue}_uuid_`)
  }
}
