import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "sidebar", "toggleLabel" ];

  toggleSidebar() {
    const sidebar = this.sidebarTarget;

    if (sidebar.style.display === "none") {
      sidebar.style.display = "flex";
      this.toggleLabelTarget.innerText = "Collapse";
    } else {
      sidebar.style.setProperty("display", "none", "important")
      this.toggleLabelTarget.innerText = "Show";
    }
  }
}
