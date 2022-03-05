import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "title", "body" ];

  error({detail: { message }}) {
    this.titleTarget.innerHTML = 'Sorry, something went wrong';
    this.bodyTarget.innerHTML = message;

    var toast = bootstrap.Toast.getOrCreateInstance(this.element);
    toast.show();
  }
}