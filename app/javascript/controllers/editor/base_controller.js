import { Controller } from "@hotwired/stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
  static targets = ["sidebar", "showSidebarButton", "hideSidebarButton"];

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

  async saveSettingSidebarOpen(value) {
    const response = await post("/editor/settings", {
      body: JSON.stringify({ settings: { sidebar_open: value } })
    });

    if (response.ok) {
      console.log("ok", response);
    } else {
      console.log("error", response);
    }
  }
}
