import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "title", "body" ];

  error({detail: { message }}) {
    const that = this;
    that.titleTarget.innerHTML = 'Sorry, something went wrong';
    that.bodyTarget.innerHTML = message;

    const toast = bootstrap.Toast.getOrCreateInstance(that.element);
    toast.show();
  }
}