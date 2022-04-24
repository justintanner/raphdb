import {Controller} from "@hotwired/stimulus";
import TomSelect from "tom-select";
import { post } from "@rails/request.js";

// Connects to data-controller="single-select"
export default class extends Controller {
  static values = {fieldId: Number, createPath: String};

  connect() {
    const that = this;

    const onOptionAddCallback = (value, _data) => {
      const payload = {
        "single_select": {"title": value, "field_id": that.fieldIdValue}
      }

      that.createNew(payload);
    }

    new TomSelect(that.element, {
      plugins: ['dropdown_input'],
      persist: false,
      create: true,
      createOnBlur: true,
      render: {
        option_create: function (data, escape) {
          return '<div class="create">Create a new option named <strong>' + escape(data.input) + '</strong></div>';
        },
      },
      onOptionAdd: onOptionAddCallback,
    });
  }

  async createNew(payload) {
    const that = this;
    const response = await post(that.createPathValue, { body: JSON.stringify(payload) });

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
