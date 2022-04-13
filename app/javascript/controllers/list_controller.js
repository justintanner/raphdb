import {Controller} from "@hotwired/stimulus"
import store from 'storejs';

// Connects to data-controller="list"
export default class extends Controller {
  static targets = ["colHeader"];

  connect() {
    const that = this;

    that.setColWidths();
    that.createResizableTable(that.element);
  }

  setColWidths() {
    store.keys().forEach((key) => {
      if (key.startsWith('col_width_')) {
        const id = key.split('col_width_')[1];
        const col = document.getElementById(id);

        col.style.width = store.get(key);
      }
    })
  }

  createResizableTable(table) {
    const that = this;

    that.colHeaderTargets.forEach((colHeader) => {
      const resizer = document.createElement('div');
      resizer.classList.add('resizer');

      resizer.style.height = `${table.offsetHeight}px`;

      colHeader.appendChild(resizer);

      that.createResizableColumn(colHeader, resizer);
    });
  };

  createResizableColumn(col, resizer) {
    const that = this;

    let x = 0;
    let w = 0;

    const mouseDownHandler = function (e) {
      x = e.clientX;

      const styles = window.getComputedStyle(col);
      w = parseInt(styles.width, 10);

      document.addEventListener('mousemove', mouseMoveHandler);
      document.addEventListener('mouseup', mouseUpHandler);

      resizer.classList.add('resizing');
    };

    const mouseMoveHandler = function (e) {
      const dx = e.clientX - x;
      col.style.width = `${w + dx}px`;
    };

    const mouseUpHandler = function () {
      resizer.classList.remove('resizing');
      document.removeEventListener('mousemove', mouseMoveHandler);
      document.removeEventListener('mouseup', mouseUpHandler);
      store.set(`col_width_${col.id}`, col.style.width);
    };

    resizer.addEventListener('mousedown', mouseDownHandler);
  }
}
