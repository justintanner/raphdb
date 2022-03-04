import { Controller } from "@hotwired/stimulus";
import "handsontable";

export default class extends Controller {
  static values = { searchPath: String };
  static targets = ["columns", "colHeaders", "spinner", "editButton"];

  // Handsontable requires it's parent container to have a height and width set, so that it can size itself.
  setContainerWidthHeight() {
    const that = this;
    const container = that.element.parentElement;
    const col = container.parentElement;
    const colStyle = window.getComputedStyle(col);

    container.style.width = colStyle.width;
    container.style.height = colStyle.height;
  }

  resize() {
    const that = this;

    that.setContainerWidthHeight();
    that.hotInstance.refreshDimensions();
  }

  fetchRecords() {
    const that = this;

    that.alreadyFetchedPaths ||= [];

    if (that.alreadyFetchedPaths.includes(that.searchPathValue)) {
      return;
    }

    that.alreadyFetchedPaths.push(that.searchPathValue);

    console.log("Fetching", this.searchPathValue);
    fetch(that.searchPathValue)
      .then((data) => data.text())
      .then((json) => {
        const response = JSON.parse(json);
        const sourceData = that.hotInstance.getSourceData();

        that.spinnerTarget.classList.add("d-none");

        that.hotInstance.updateData(sourceData.concat(response["records"]));

        if (response["pagy"]["page"] === response["pagy"]["last"]) {
          // Use the same page that we just fetched to stop fetching pages.
          that.searchPathValue = response["pagy"]["page_url"];
        } else {
          that.searchPathValue = response["pagy"]["next_url"];
        }
      });
    // TODO: Handle error case!
  }

  initialize() {
    const that = this;

    const columns = JSON.parse(that.columnsTarget.innerHTML);
    const colHeaders = JSON.parse(that.colHeadersTarget.innerHTML);

    that.setupMultipleSelect();
    that.setupEditColumn();
    that.setContainerWidthHeight();

    that.hotInstance = new Handsontable(that.element, {
      data: [],
      columns: columns,
      colHeaders: colHeaders,
      rowHeaders: true,
      manualColumnResize: true,
      licenseKey: "non-commercial-and-evaluation",
    });

    const autoRowSize = that.hotInstance.getPlugin("AutoRowSize");

    that.fetchRecords();

    that.hotInstance.addHook("afterScrollVertically", function () {
      const totalRows = that.hotInstance.countRows();
      const lastVisibleRow = autoRowSize.getLastVisibleRow();

      if (lastVisibleRow < totalRows - 30) {
        return;
      }

      that.fetchRecords();
    });
  }

  setupMultipleSelect() {
    function customRenderer(instance, td, row, column, prop, value, cellProperties) {
      Handsontable.renderers.BaseRenderer(instance, td, row, column, prop, value, cellProperties);
      Handsontable.dom.empty(td);

      if (value) {
        value.forEach(function (title) {
          const span = document.createElement("span");
          span.className = "badge rounded-pill bg-secondary";
          span.innerText = title;
          td.append(span);
        });
      }
    }

    Handsontable.cellTypes.registerCellType('multipleselect', {
      editor: Handsontable.editors.TextEditor,
      renderer: customRenderer,
      allowInvalid: true,
    });
  }

  setupEditColumn() {
    const that = this;

    function customRenderer(instance, td, row, column, prop, value, cellProperties) {
      Handsontable.renderers.BaseRenderer(instance, td, row, column, prop, value, cellProperties);
      Handsontable.dom.empty(td);

      var stuff = that.editButtonTarget.innerHTML.replace(/(\r\n|\n|\r)/gm, "").trim();

      console.log(stuff, stuff);
      td.innerHTML = stuff;
    }

    Handsontable.cellTypes.registerCellType('edit', {
      renderer: customRenderer,
      readOnly: true,
    });
  }

}