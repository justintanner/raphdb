import {DispatchController} from "./dispatch_controller"
import TomSelect from "tom-select"
import {post} from "@rails/request.js"

// Connects to data-controller="multiple-select"
export default class extends DispatchController {
  static values = {fieldId: Number, createPath: String}

  connect() {
    const onOptionAddCallback = (value, _data) => {
      const payload = {
        "multiple_select": {"title": value, "field_id": this.fieldIdValue}
      }

      this.createNew(payload)
    }

    new TomSelect(this.element, {
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
          return '<div class="create">Create a new option named <strong>' + escape(data.input) + '</strong></div>'
        },
      },
      onOptionAdd: onOptionAddCallback,
    })
  }

  async createNew(payload) {
    const response = await post(this.createPathValue, { body: JSON.stringify(payload) })

    this.dispatchError(response)
  }
}
