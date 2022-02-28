import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "showSidebarButton", "hideSidebarButton", "hot"];

  toggleSidebar() {
    const sidebar = this.sidebarTarget;
    const showButton = this.showSidebarButtonTarget;
    const hideButton = this.hideSidebarButtonTarget;

    if (sidebar.style.display === "none") {
      sidebar.style.display = "flex";

      showButton.classList.remove("d-block");
      showButton.classList.add("d-none");

      hideButton.classList.add("d-block");
      hideButton.classList.remove("d-none");
    } else {
      sidebar.style.setProperty("display", "none", "important");

      showButton.classList.remove("d-none");
      showButton.classList.add("d-block");

      hideButton.classList.add("d-none");
      hideButton.classList.remove("d-block");
    }

    const hotController = this.application.getControllerForElementAndIdentifier(
      this.hotTarget,
      "editor--hot"
    );
    hotController.resize();
  }
}
