import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "title" ];

  onInput() {
    console.log('value', this.titleTarget.value);
  }
}
