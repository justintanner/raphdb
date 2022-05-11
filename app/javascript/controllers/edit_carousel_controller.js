import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs";
import { patch } from "@rails/request.js";

// Connects to data-controller="edit-carousel"
export default class extends Controller {
  connect() {
    const that = this;

    that.sortable = Sortable.create(that.element, {
      handle: ".handle",
      animation: 150,
      onEnd: that.updatePosition.bind(that),
    });
  }

  async updatePosition(event) {
    const that = this;
    const imageId = event.item.id.replace("image_", "");
    const position = event.newIndex + 1;

    const response = await patch(`/editor/images/${imageId}`, {
      body: JSON.stringify({ position: position }),
    });

    if (!response.ok) {
      const json = await response.json;

      that.dispatch("error", {target: document, prefix: null, detail: {json: json}});
    }
  }
}
