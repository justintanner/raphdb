import {DispatchController} from "./dispatch_controller"
import {post} from "@rails/request.js"

// Connects to data-controller="sidebar"
export default class extends DispatchController {
  static targets = ["container", "showButton", "hideButton"]

  toggle() {
    if ((this.containerTarget.style.display === "none") || this.containerTarget.classList.contains("d-none")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.containerTarget.classList.remove("d-none")
    this.containerTarget.classList.remove("d-flex")
    this.containerTarget.style.display = "flex"

    this.showButtonTarget.classList.remove("d-block")
    this.showButtonTarget.classList.add("d-none")

    this.hideButtonTarget.classList.add("d-block")
    this.hideButtonTarget.classList.remove("d-none")

    this.saveSettingSidebarOpen("true")
  }

  close() {
    this.containerTarget.classList.remove("d-flex")
    this.containerTarget.classList.remove("d-none")
    this.containerTarget.style.setProperty("display", "none", "important")

    this.showButtonTarget.classList.remove("d-none")
    this.showButtonTarget.classList.add("d-block")

    this.hideButtonTarget.classList.add("d-none")
    this.hideButtonTarget.classList.remove("d-block")

    this.saveSettingSidebarOpen("false")
  }

  async saveSettingSidebarOpen(value) {
    const response = await post("/editor/settings", {
      body: JSON.stringify({ settings: { sidebar_open: value } })
    })

    this.dispatchError(response)
  }
}
