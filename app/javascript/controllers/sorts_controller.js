import { SortsFiltersController } from "./sorts_filters_controller";
import { Sortable } from "sortablejs"

// Connects to data-controller="sorts"
export default class extends SortsFiltersController {
  static targets = ["ul", "delete", "position", "label", "fieldSelect", "newTemplate", "emptyMessage"]
  static values = {"numericFieldIds": Array, "firstLabel": String}

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
}
