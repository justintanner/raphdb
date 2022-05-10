import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs";

// Connects to data-controller="image-list"
export default class extends Controller {
  connect() {
    const that = this;

    that.sortable = Sortable.create(that.element, {
      handle: ".handle",
      animation: 150,
      onEnd: that.end.bind(that),
    });
  }

  end(event) {
    console.log("end", event);
  }
}
