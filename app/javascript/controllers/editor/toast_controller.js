import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "title", "body" ];

  show({detail: { title, body }}) {
    this.titleTarget.innerHTML = title;
    this.bodyTarget.innerHTML = body;

    var toast = bootstrap.Toast.getOrCreateInstance(this.element);
    toast.show();
  }
}