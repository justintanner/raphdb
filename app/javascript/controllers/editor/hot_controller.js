import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {searchPath: String}
  static targets = ["columns", "colHeaders"]

  resize() {
    const that = this;
    
    const parentStyle = window.getComputedStyle(that.element.parentNode)

    that.element.style.width = parentStyle.width
    that.element.style.height = parentStyle.height

    if (typeof (that.element.handsontable) === 'function') {
      that.element.handsontable('getInstance').refreshDimensions()
    }
  }

  fetchRecords(hotInstance) {
    const that = this;

    that.alreadyFetchedPaths ||= [];

    if (that.alreadyFetchedPaths.includes(that.searchPathValue)) {
      return;
    }

    that.alreadyFetchedPaths.push(that.searchPathValue);

    console.log('Fetching', this.searchPathValue);
    fetch(that.searchPathValue)
      .then((data) => data.text())
      .then((json) => {
        const response = JSON.parse(json)
        const sourceData = hotInstance.getSourceData();
        hotInstance.updateData(sourceData.concat(response['records']))

        if (response['pagy']['page'] === response['pagy']['last']) {
          that.searchPathValue = response['pagy']['page_url']
        } else {
          that.searchPathValue = response['pagy']['next_url']
        }
      })
     // TODO: Handle error case!
  }

  initialize() {
    const that = this;

    const columns = JSON.parse(that.columnsTarget.innerHTML)
    const colHeaders = JSON.parse(that.colHeadersTarget.innerHTML)

    const hotInstance = new Handsontable(that.element, {
      data: [],
      columns: columns,
      colHeaders: colHeaders,
      rowHeaders: true,
      licenseKey: 'non-commercial-and-evaluation'
    })

    const autoRowSize = hotInstance.getPlugin('AutoRowSize')

    that.fetchRecords(hotInstance)

    hotInstance.addHook('afterScrollVertically', function () {
      const totalRows = hotInstance.countRows()
      const lastVisibleRow = autoRowSize.getLastVisibleRow()

      if (lastVisibleRow < totalRows - 30) {
        return;
      }

      that.fetchRecords(hotInstance);
    })
  }
}
