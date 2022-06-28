import {Controller} from "@hotwired/stimulus"

// Inherit this controller if you want to raise toast popup errors.
export class DispatchController extends Controller {
  async dispatchError(response) {
    if (!response.ok) {
      let message;

      if (response.contentType === "application/json") {
        const json = await response.json
        message = json.errors.join(", ");
      } else {
        message = await response.text
      }

      this.dispatch("error", {target: document, prefix: null, detail: {message: message}})
    }
  }
}
