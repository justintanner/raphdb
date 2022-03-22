import {Controller} from "@hotwired/stimulus";
import Splide from "@splidejs/splide";

// Connects to data-controller="splide"
export default class extends Controller {
  static values = { maxWidth: Number, position: Number };
  static targets = [ "thumb" ];

  connect() {
    const that = this;

    const splideInstance = new Splide('.splide', {
      autoWidth: true,
      width: that.tightWidth() + 'px',
      gap: '8px',
      pagination: false,
      keyboard: false,
      start: that.positionValue - 1,
    });

    splideInstance.mount();
  }

  tightWidth() {
    const that = this;

    const thumbsWidth = that.thumbTargets.reduce((sum, thumb) => {
      return sum + parseInt(thumb.getAttribute('width')) + 8;
    }, 88);

    return Math.min(thumbsWidth, that.maxWidthValue);
  }
}
