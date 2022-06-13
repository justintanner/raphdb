import { SortsFiltersController } from "./sorts_filters_controller";
import { Sortable } from "sortablejs"

// Connects to data-controller="filters"
export default class extends SortsFiltersController {
  static targets = ["ul", "delete", "position", "label", "fieldSelect", "newTemplate", "emptyMessage"]
  static values = {"firstLabel": String}

  connect() {
    const that = this

    that.disableUsedOptions()

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
    that.showHideEmptyMessage()
    that.relabel()
    that.reposition()
  }

  delete(event) {
    const that = this

    event.preventDefault()
    event.target.closest("li").remove()

    that.showHideEmptyMessage()
    that.clearAllDisabledOptions()
    that.disableUsedOptions()
  }
}
