import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["container", "showButton", "hideButton"];

  toggle() {
    const that = this;

    if ((that.containerTarget.style.display === "none") || that.containerTarget.classList.contains("d-none")) {
      that.open();
    } else {
      that.close();
    }
  }

  open() {
    const that = this;

    that.containerTarget.classList.remove("d-none");
    that.containerTarget.classList.remove("d-flex");
    that.containerTarget.style.display = "flex";

    that.showButtonTarget.classList.remove("d-block");
    that.showButtonTarget.classList.add("d-none");

    that.hideButtonTarget.classList.add("d-block");
    that.hideButtonTarget.classList.remove("d-none");
  }

  close() {
    const that = this;
    
    that.containerTarget.classList.remove("d-flex");
    that.containerTarget.classList.remove("d-none");
    that.containerTarget.style.setProperty("display", "none", "important");

    that.showButtonTarget.classList.remove("d-none");
    that.showButtonTarget.classList.add("d-block");

    that.hideButtonTarget.classList.add("d-none");
    that.hideButtonTarget.classList.remove("d-block");

    that.saveSettingSidebarOpen("false");
  }

  async saveSettingSidebarOpen(value) {
    const that = this;

    const response = await post("/editor/settings", {
      body: JSON.stringify({ settings: { sidebar_open: value } })
    });

    if (!response.ok) {
      const json = await response.json;

      that.dispatch("error", {target: document, prefix: null, detail: {json: json}});
    }
  }
}
