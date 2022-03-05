import {Controller} from "@hotwired/stimulus";
import moment from "moment";
import Pikaday from "pikaday";

export default class extends Controller {
  static values = {format: String};

  initialize() {
    const that = this;

    moment.suppressDeprecationWarnings = true;

    new Pikaday({
      field: that.element,
      format: that.formatValue,
      yearRange: [1850, new Date().getFullYear()]
    });
  }
}
