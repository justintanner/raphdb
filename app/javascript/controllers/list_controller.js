import {Controller} from "@hotwired/stimulus"
import store from "storejs"

// Connects to data-controller="list"
export default class extends Controller {
  static targets = ["colHeader", "tr", "number", "footer", "listSpinner"]

  connect() {
    this.setColWidths()
    this.createResizableTable(this.element)
  }

  trTargetConnected(tr) {
    const domId = tr.id
    const controller = tr.getAttribute("data-controller")
    this.loadMoreCache = this.loadMoreCache || {}

    if (controller !== "load-more" && this.loadMoreCache[domId] === "load-more") {
      //console.log(`cache hit:"${this.loadMoreCache[domId]}"`)
      tr.setAttribute("data-controller", this.loadMoreCache[domId])
    } else {
      //console.log(`saving cache:"${controller}"`)
      this.loadMoreCache[domId] = controller
    }
  }

  numberTargetConnected(numberSpan) {
    const domId = numberSpan.getAttribute("data-list-id-value")
    this.numberCache = this.numberCache || {}

    if (numberSpan.innerHTML) {
      //console.log(`saving cache:"${numberSpan.innerHTML}"`)
      this.numberCache[domId] = numberSpan.innerHTML
    } else {
      //console.log("cache hit:", this.numberCache[domId])
      numberSpan.innerHTML = this.numberCache[domId]
    }
  }

  spinner() {
    this.listSpinnerTarget.classList.remove("d-none")
    this.listSpinnerTarget.classList.add("d-block")
  }

  setColWidths() {
    store.keys().forEach((key) => {
      if (key.startsWith("col_width_")) {
        const id = key.split("col_width_")[1]
        const col = document.getElementById(id)
        if (col) {
          col.style.width = store.get(key)
        }
      }
    })
  }

  createResizableTable(table) {
    this.colHeaderTargets.forEach((colHeader) => {
      const resizer = document.createElement("div")
      resizer.classList.add("resizer")

      colHeader.appendChild(resizer)

      this.createResizableColumn(colHeader, resizer)
    })
  }

  createResizableColumn(col, resizer) {
    let x = 0
    let w = 0

    const mouseDownHandler = function (e) {
      x = e.clientX

      const styles = window.getComputedStyle(col)
      w = parseInt(styles.width, 10)

      document.addEventListener("mousemove", mouseMoveHandler)
      document.addEventListener("mouseup", mouseUpHandler)

      resizer.classList.add("resizing")
    }

    const mouseMoveHandler = function (e) {
      const dx = e.clientX - x
      col.style.width = `${w + dx}px`
    }

    const mouseUpHandler = function () {
      resizer.classList.remove("resizing")
      document.removeEventListener("mousemove", mouseMoveHandler)
      document.removeEventListener("mouseup", mouseUpHandler)
      store.set(`col_width_${col.id}`, col.style.width)
    }

    resizer.addEventListener("mousedown", mouseDownHandler)
  }
}
