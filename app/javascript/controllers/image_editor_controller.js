import {Controller} from "@hotwired/stimulus"
import { patch } from "@rails/request.js";
import "cropperjs";

// Connects to data-controller="image-editor"
export default class extends Controller {
  static targets = ["image", "cropButton", "clearCropButton"];
  static values = {
    "id": Number,
    "height": Number,
    "width": Number,
    "largeHeight": Number,
    "largeWidth": Number,
  };

  connect() {
    const that = this;
    const startWithNoCrop = () => { this.cropper.clear();}

    that.cropper = new Cropper(that.imageTarget, {
      viewMode: 1,
      zoomable: false,
      ready: startWithNoCrop
    });
  }

  startCrop() {
    const that = this;

    that.cropper.crop();

    that.clearCropButtonTarget.classList.remove("d-none");
    that.clearCropButtonTarget.classList.add("d-block");

    that.cropButtonTarget.classList.remove("d-block")
    that.cropButtonTarget.classList.add("d-none");
  }

  clearCrop() {
    const that = this;

    that.cropper.clear();

    that.clearCropButtonTarget.classList.remove("d-block");
    that.clearCropButtonTarget.classList.add("d-none");

    that.cropButtonTarget.classList.remove("d-none")
    that.cropButtonTarget.classList.add("d-block");
  }

  rotateRight() {
    const that = this;

    that.cropper.rotate(90);
  }

  rotateLeft() {
    const that = this;

    that.cropper.rotate(-90);
  }

  save() {
    const that = this;
    const data = that.cropper.getData();

    console.log(data);

    if (this.somethingChanged(data)) {
      that.updateImage(data);
    }
  }

  scaledCropX(data) {
    const that = this;

    return Math.ceil((data.x / that.largeWidthValue) * that.widthValue);
  }

  scaledCropY(data) {
    const that = this;

    return Math.ceil((data.y / that.largeHeightValue) * that.heightValue);
  }

  scaledCropWidth(data) {
    const that = this;

    return Math.ceil((data.width / that.largeWidthValue) * that.widthValue);
  }

  scaledCropHeight(data) {
    const that = this;

    return Math.ceil((data.height / that.largeHeightValue) * that.heightValue);
  }

  async updateImage(data) {
    const that = this;

    const payload = {
      crop_x: that.scaledCropX(data),
      crop_y: that.scaledCropY(data),
      crop_width: that.scaledCropWidth(data),
      crop_height: that.scaledCropHeight(data),
      rotate: data.rotate,
    };
    const response = await patch(`/editor/images/${that.idValue}`, { body: JSON.stringify(payload) });

    if (!response.ok) {
      const json = await response.json;

      that.dispatch("error", {target: document, prefix: null, detail: {json: json}});
    }
  }

  somethingChanged(data) {
    return ((data.rotate > 0 || data.rotate < 0) || (data.width > 0 && data.height > 0));
  }
}
