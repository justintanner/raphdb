import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="images-load-more"
export default class extends Controller {
  connect() {
    this.createObserver();
  }

  createObserver() {
    const observer = new IntersectionObserver(
      entries => this.handleIntersect(entries),
      {
        // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
        threshold: [0, 1.0],
      }
    )
    observer.observe(this.element);
  }

  handleIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.element.click();
      }
    })
  }
}
