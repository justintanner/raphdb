import {Controller} from "@hotwired/stimulus"
import {patch} from "@rails/request.js"
import "cropperjs"
import toastError from "../toast_error"

// Connects to data-controller="image-editor"
export default class extends Controller {
  static targets = ["image", "cropButton", "clearCropButton"]
  static values = {
    "id": Number,
    "height": Number,
    "width": Number,
    "largeHeight": Number,
    "largeWidth": Number,
  }

  connect() {
    const that = this
    const startWithNoCrop = () => { this.cropper.clear() }
    const switchButtons = () => { that.showClearCrop() }

    that.cropper = new Cropper(that.imageTarget, {
      viewMode: 1,
      zoomable: false,
      ready: startWithNoCrop,
      cropend: switchButtons,
    })
  }

  startCrop() {
    this.cropper.crop()
    this.showClearCrop()
  }

  clearCrop() {
    this.cropper.clear()
    this.hideClearCrop()
  }

  showClearCrop() {
    this.clearCropButtonTarget.classList.remove("d-none")
    this.clearCropButtonTarget.classList.add("d-block")

    this.cropButtonTarget.classList.remove("d-block")
    this.cropButtonTarget.classList.add("d-none")
  }

  hideClearCrop() {
    this.clearCropButtonTarget.classList.remove("d-block")
    this.clearCropButtonTarget.classList.add("d-none")

    this.cropButtonTarget.classList.remove("d-none")
    this.cropButtonTarget.classList.add("d-block")
  }

  rotateRight() {
    this.cropper.rotate(90)
  }

  rotateLeft() {
    this.cropper.rotate(-90)
  }

  save() {
    const data = this.cropper.getData()

    if (this.somethingChanged(data)) {
      this.updateImage(data)
    }
  }

  scaledCropX(data) {
    return Math.ceil((data.x / this.largeWidthValue) * this.widthValue)
  }

  scaledCropY(data) {
    return Math.ceil((data.y / this.largeHeightValue) * this.heightValue)
  }

  scaledCropWidth(data) {
    return Math.ceil((data.width / this.largeWidthValue) * this.widthValue)
  }

  scaledCropHeight(data) {
    return Math.ceil((data.height / this.largeHeightValue) * this.heightValue)
  }

  async updateImage(data) {
    const payload = {
      crop_x: this.scaledCropX(data),
      crop_y: this.scaledCropY(data),
      crop_width: this.scaledCropWidth(data),
      crop_height: this.scaledCropHeight(data),
      rotate: data.rotate,
    }
    const response = await patch(`/editor/images/${this.idValue}`, { body: JSON.stringify(payload) })

    toastError(this, response)
  }

  somethingChanged(data) {
    return ((data.rotate > 0 || data.rotate < 0) || (data.width > 0 && data.height > 0))
  }
}
