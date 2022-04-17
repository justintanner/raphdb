import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list-load-more"
export default class extends Controller {
  connect() {
    if (document.getElementById("list-load-more-button")) {
      this.createObserver();
    }
  }

  createObserver() {
    const that = this;

    that.observer = new IntersectionObserver(
      entries => that.handleIntersect(entries),
      {
        // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
        threshold: [0, 1.0],
      }
    )
    that.observer.observe(that.element);
  }

  handleIntersect(entries) {
    const that = this;

    entries.forEach(entry => {
      if (entry.isIntersecting) {
        /* Not using an stimulus target because this is outside the controller */
        document.getElementById("list-load-more-button").click();

        /* Turning off this observer so it doesn't keep loading */
        that.observer.disconnect();
      }
    })
  }
}
