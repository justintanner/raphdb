import {Controller} from "@hotwired/stimulus";
import TomSelect from "tom-select";
import {fetchPost} from "fetch";

export default class extends Controller {
  static values = {fieldId: Number, createPath: String};

  initialize() {
    const that = this;

    const onOptionAddCallback = (value, _data) => {
      const data = {
        "multiple_select": {"title": value, "field_id": that.fieldIdValue}
      }

      const successCallback = (json) => {
        console.log('successCallback', json);
      }

      const errorCallback = (json) => {
        that.dispatch('error', { target: document, prefix: null, detail: { message: json.errors.join(', ') } });
      }

      fetchPost(that.createPathValue, data, successCallback, errorCallback);
    }

    new TomSelect(that.element, {
      plugins: {
        remove_button: {
          title: 'Remove this item',
        }
      },
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

  error() {

  }

  toast(title, body) {
    console.log('toasting');
    const event = new CustomEvent("toast", { detail: { title: title, body: body } });
    window.dispatchEvent(event);
  }
}
