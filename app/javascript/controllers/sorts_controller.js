import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs"

// Connects to data-controller="sorts"
export default class extends Controller {
  static targets = ["ul", "delete", "position", "label", "fieldSelect", "newTemplate", "emptyMessage"]
  static values = {numericFieldIds: Array, firstLabel: String, nthLabel: String}

  connect() {
    const that = this

    that.disableUsedOptions()
    that.prettyDirections()

    that.sortable = Sortable.create(that.ulTarget, {
      handle: ".handle",
      animation: 150,
      onEnd: that.relabelAndReposition.bind(that),
    })
  }

  addNew(event) {
    const that = this
    const position = that.nextPosition().toString()

    that.injectNewRow(position)
    that.initNewFieldSelect(event.target.value, position)
    that.showHideEmptyMessage()
    that.resetPickAnotherSelect()
    that.disableUsedOptions()
    that.relabel()
    that.reposition()
    that.prettyDirections()
  }

  delete(event) {
    const that = this

    event.preventDefault()
    event.target.closest("li").remove()

    that.showHideEmptyMessage()
    that.clearAllDisabledOptions()
    that.disableUsedOptions()
  }

  changeField(_event) {
    const that = this

    that.clearAllDisabledOptions()
    that.disableUsedOptions()
    that.prettyDirections()
  }

  prettyDirections() {
    const that = this

    that.fieldSelectTargets.forEach((select) => {
      const position = select.name.replace(/\D+/g, '')
      const ascLabel = document.querySelector(`#label_${position}_asc`)
      const descLabel = document.querySelector(`#label_${position}_desc`)

      if (!ascLabel || !descLabel) {
        return;
      }

      if (that.numericFieldIdsValue.includes(parseInt(select.value))) {
        ascLabel.innerHTML = '1 <i class="bi bi-arrow-right"></i> 9'
        descLabel.innerHTML = '9 <i class="bi bi-arrow-right"></i> 1'
      } else {
        ascLabel.innerHTML = 'A <i class="bi bi-arrow-right"></i> Z'
        descLabel.innerHTML = 'Z <i class="bi bi-arrow-right"></i> A'
      }
    })
  }

  disableUsedOptions() {
    const that = this

    const idsInUse = that.fieldSelectTargets.map((select) => { return select.value })

    that.fieldSelectTargets.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        if (option.selected === false && idsInUse.includes(option.value)) {
          option.disabled = true
        }
      })
    })
  }

  clearAllDisabledOptions() {
    const that = this

    that.fieldSelectTargets.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        option.disabled = false
      })
    })
  }

  resetPickAnotherSelect() {
    const that = this
    const pickAnotherSelect = that.fieldSelectTargets.find((select) => { return select.id === "pick_another_field" })

    pickAnotherSelect.selectedIndex = 0
  }

  relabelAndReposition() {
    const that = this

    that.relabel()
    that.reposition()
  }

  relabel() {
    const that = this

    that.labelTargets.forEach((element, index) => {
      if (index === 0) {
        element.innerHTML = that.firstLabelValue
      }
      else {
        element.innerHTML = that.nthLabelValue
      }
    })
  }

  reposition() {
    const that = this

    that.positionTargets.forEach((element, index) => {
      return element.value = index + 1
    })
  }

  nextPosition() {
    const that = this

    const positions = that.positionTargets.map((element) => { return parseInt(element.value) })

    if (positions.length === 0) {
      return 1
    }

    return Math.max(...positions) + 1
  }

  injectNewRow(position) {
    const that = this

    const template = that.newTemplateTarget.innerHTML.replaceAll("{{position}}", position)
    that.ulTarget.insertAdjacentHTML("beforeend", template)
  }

  initNewFieldSelect(selectedFieldId, position) {
    const that = this

    const newlyAddedFieldSelect = that.fieldSelectTargets.find((select) => {
      return select.id.endsWith(`${position}_field_id`)
    })

    newlyAddedFieldSelect.value = selectedFieldId
  }

  showHideEmptyMessage() {
    const that = this

    if (that.ulTarget.children.length === 0) {
      that.emptyMessageTarget.classList.remove("d-none");
    }
    else {
      that.emptyMessageTarget.classList.add("d-none");
    }
  }
}
