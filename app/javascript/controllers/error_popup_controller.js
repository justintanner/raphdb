import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="error-popup"
export default class extends Controller {
  static targets = [ "title", "body" ];

  show({detail: { json }}) {
    const that = this;
    const title = "Sorry, something went wrong";
    let message = "Please reload the page";

    if (Array.isArray(json.errors)) {
      message = json.errors.join(", ");
    }

    that.titleTarget.innerHTML = title;
    that.bodyTarget.innerHTML = message;

    const toast = bootstrap.Toast.getOrCreateInstance(that.element);
    toast.show();
  }
}
