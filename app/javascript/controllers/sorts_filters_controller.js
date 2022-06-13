import { Controller } from "@hotwired/stimulus"

// Not for direct usage, inherited in sorts and filters controllers.
export class SortsFiltersController extends Controller {
  connect() {
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

  nextPosition() {
    const that = this

    const positions = that.positionTargets.map((element) => { return parseInt(element.value) })

    return Math.max(...positions) + 1;
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
