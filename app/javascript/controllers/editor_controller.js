import { Controller } from "@hotwired/stimulus";
import { post } from "@rails/request.js";

// Connects to data-controller="editor"
export default class extends Controller {
  static targets = ["sidebar", "showSidebarButton", "hideSidebarButton", "editItemFrame", "editItemOffcanvas"];

  toggleSidebar() {
    const that = this;
    const sidebar = this.sidebarTarget;
    const showButton = this.showSidebarButtonTarget;
    const hideButton = this.hideSidebarButtonTarget;

    if ((sidebar.style.display === "none") || sidebar.classList.contains("d-none")) {
      sidebar.classList.remove("d-none");
      sidebar.classList.remove("d-flex");
      sidebar.style.display = "flex";

      showButton.classList.remove("d-block");
      showButton.classList.add("d-none");

      hideButton.classList.add("d-block");
      hideButton.classList.remove("d-none");

      that.saveSettingSidebarOpen("true");
    } else {
      sidebar.classList.remove("d-flex");
      sidebar.classList.remove("d-none");
      sidebar.style.setProperty("display", "none", "important");

      showButton.classList.remove("d-none");
      showButton.classList.add("d-block");

      hideButton.classList.add("d-none");
      hideButton.classList.remove("d-block");

      that.saveSettingSidebarOpen("false");
    }
  }

  edit(event) {
    const that = this;
    const turboFrame = that.editItemFrameTarget;
    turboFrame.src = event.params.editUrl;

    const bsOffcanvas = new bootstrap.Offcanvas(that.editItemOffcanvasTarget);
    bsOffcanvas.show();
  }

  async saveSettingSidebarOpen(value) {
    const response = await post("/editor/settings", {
      body: JSON.stringify({ settings: { sidebar_open: value } })
    });

    if (!response.ok) {
      const json = await response.json;

      let message = "Please reload the page"
      if (Array.isArray(json.errors)) {
        message = json.errors.join(", ");
      }

      that.dispatch("error", {target: document, prefix: null, detail: {message: message}});
    }
  }
}
