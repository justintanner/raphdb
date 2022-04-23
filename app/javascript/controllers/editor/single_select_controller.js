import {Controller} from "@hotwired/stimulus";
import TomSelect from "tom-select";
import {fetchPost} from "fetch";

// Connects to data-controller="editor-single-select"
export default class extends Controller {
  static values = {fieldId: Number, createPath: String};

  connect() {
    const that = this;

    const onOptionAddCallback = (value, _data) => {
      const data = {
        "single_select": {"title": value, "field_id": that.fieldIdValue}
      }
      const successCallback = (_json) => {}

      const errorCallback = (json) => {
        console.log('errorCallback', json);
        that.dispatch('error', { target: document, prefix: null, detail: { message: json.errors.join(', ') } });
      }

      fetchPost(that.createPathValue, data, successCallback, errorCallback);
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
}
