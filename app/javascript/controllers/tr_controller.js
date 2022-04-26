import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tr"
export default class extends Controller {
  static targets = [ "number" ];

  connect() {
    const that = this;

    that.numberCache = that.numberCache || {};

    if (that.numberTarget.innerHTML === "") {

    }
  }

  // trTargetConnected(tr) {
  //   console.log("trTargetConnected");
  //   const that = this;
  //   that.numberCache = that.numberCache || {};
  //
  //   that.numberCache[tr.id] = tr.getAttribute("data-list-number-value");
  // }
  //
  // numberSpanConnected(span) {
  //   const that = this;
  //   that.numberCache = that.numberCache || {};
  //
  //   if (span.innerHTML === "") {
  //     console.log("pp", span.parentElement.parentElement.id);
  //     span.innerHTML = that.numberCache[span.parentElement.parentElement.id];
  //   }
  // }
}
