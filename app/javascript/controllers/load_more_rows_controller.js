import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="load-more-rows"
export default class extends Controller {
  connect() {
    this.createObserver();
    console.log("Connect");
  }

  createObserver() {
    const that = this;

    that.observer = new IntersectionObserver(
      entries => this.handleIntersect(entries),
      {
        // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
        threshold: [0, 1.0],
      }
    )
    that.observer.observe(this.element);
    console.log('Observer created');
  }

  handleIntersect(entries) {
    const that = this;

    entries.forEach(entry => {
      if (entry.isIntersecting) {
        console.log('Intersecting');
        /* Not using an stimulus target because this is outside the controller */
        document.getElementById("load-more-rows").click();
        that.observer.disconnect();
      }
    })
  }
}
