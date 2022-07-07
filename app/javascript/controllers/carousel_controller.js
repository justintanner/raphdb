import {Controller} from "@hotwired/stimulus"
import Splide from "@splidejs/splide"

// Connects to data-controller="carousel"
export default class extends Controller {
  static values = { maxWidth: Number, position: Number }
  static targets = [ "thumb" ]

  connect() {
    const splideInstance = new Splide('.splide', {
      autoWidth: true,
      width: this.tightWidth() + 'px',
      gap: '8px',
      pagination: false,
      keyboard: false,
      start: this.positionValue - 1,
    })

    splideInstance.mount()
  }

  tightWidth() {
    const thumbsWidth = this.thumbTargets.reduce((sum, thumb) => {
      return sum + parseInt(thumb.getAttribute('width')) + 8
    }, 88)

    return Math.min(thumbsWidth, this.maxWidthValue)
  }
}
