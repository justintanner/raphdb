import { Controller } from "@hotwired/stimulus"
import "fslightbox"

// Connects to data-controller="lightbox"
export default class extends Controller {
  static values = { position: Number }

  connect() {
    const lightbox = fsLightboxInstances["gallery"];

    lightbox.props.customToolbarButtons = [{
      viewBox: "0 0 16 16",
      d: "M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z",
      width: "16px",
      height: "16px",
      title: "Download Image",
      onClick: function (lightbox) {
        var src = lightbox.elements.sources[lightbox.stageIndexes.current].src;

        var downloadLink = document.createElement("a");
        downloadLink.href = src
        downloadLink.target = "_blank";
        downloadLink.download = src
        downloadLink.click();
        downloadLink.remove();
      }
    }];
  }

  open() {
    const that = this;

    fsLightboxInstances["gallery"].open(that.positionValue);
  }
}

