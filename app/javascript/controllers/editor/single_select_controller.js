import {Controller} from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  static values = {fieldId: Number, createPath: String};

  initialize() {
    const that = this;

    const onOptionAddCallback = (value, _data) => {
      const body = {
        "authenticity_token": that.getCsrfToken(),
        "single_select": { "title": value, "field_id": that.fieldIdValue }
      }

      fetch(that.createPathValue, {
        body: JSON.stringify(body),
        method: 'POST',
        dataType: 'json',
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": that.getCsrfToken()
        },
      }).then((response) => {
        if (response.ok) {
          return response.json();
        }
        return Promise.reject(response);
      }).then((json) => {
        console.log('success', json);
      }).catch((response) => {
        response.json().then((json) => {
          if (Array.isArray(json.errors)) {
            that.toast('Sorry, something went wrong', json.errors.join(', '));
          } else {
            that.toast('Lost connection', 'Please reload the page and try again.');
          }
        });
      });
    }

    new TomSelect(that.element, {
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

  toast(title, body) {
    console.log('toasting');
    const event = new CustomEvent("toast", { detail: { title: title, body: body } });
    window.dispatchEvent(event);
  }

  getCsrfToken(name) {
    const element = document.head.querySelector('meta[name="csrf-token"]')
    if (element) {
      return element.getAttribute("content")
    }
  }
}
