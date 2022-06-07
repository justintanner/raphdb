import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs"

// Connects to data-controller="sorts"
export default class extends Controller {
  static targets = ["ul", "delete", "position", "label", "fieldSelect", "newTemplate"]
  static values = {"numericFieldIds": Array}

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
    const selectedFieldId = event.srcElement.value

    that.ulTarget.innerHTML += that.newTemplateTarget.innerHTML

    that.setNewlyAddedField(selectedFieldId)
    that.resetPickAnotherSelect()
    that.disableUsedOptions()
    that.relabel()
    that.reposition()
    that.prettyDirections()
  }

  delete(event) {
    const that = this

    event.target.closest("li").remove()
    that.clearAllDisabledOptions()
    that.disableUsedOptions()
  }

  changeField(event) {
    const that = this

    that.clearAllDisabledOptions()
    that.disableUsedOptions()
    that.prettyDirections()
  }

  disableUsedOptions() {
    const that = this

    const idsInUse = that.fieldSelectTargets.map((select) => { return select.value });

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

  setNewlyAddedField(value) {
    const that = this
    const newlyAddedSelect = that.fieldSelectTargets[that.fieldSelectTargets.length - 2]

    newlyAddedSelect.value = value
  }

  resetPickAnotherSelect() {
    const that = this

    that.fieldSelectTargets.pop().selectedIndex = 0
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
        element.innerHTML = "Sort by"
      }
      else {
        element.innerHTML = "then by"
      }
    })
  }

  reposition() {
    const that = this

    that.positionTargets.forEach((element, index) => {
      return element.value = index + 1
    })
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
}
