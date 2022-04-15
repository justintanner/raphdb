var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var e={};(function(t,r){e=r()})(0,(function(){var e=window.localStorage;function isJSON(t){t=JSON.stringify(t);return!!/^\{[\s\S]*\}$/.test(t)}function stringify(t){return void 0===t||"function"===typeof t?t+"":JSON.stringify(t)}function deserialize(t){if("string"===typeof t)try{return JSON.parse(t)}catch(e){return t}}function isFunction(t){return"[object Function]"==={}.toString.call(t)}function isArray(t){return"[object Array]"===Object.prototype.toString.call(t)}function dealIncognito(t){var e="_Is_Incognit",r="yes";try{t.setItem(e,r)}catch(e){if("QuotaExceededError"===e.name){var n=function _nothing(){};t.__proto__={setItem:n,getItem:n,removeItem:n,clear:n}}}finally{t.getItem(e)===r&&t.removeItem(e)}return t}e=dealIncognito(e);function Store(){if(!((this||t)instanceof Store))return new Store}Store.prototype={set:function set(r,n){if(r&&!isJSON(r))e.setItem(r,stringify(n));else if(isJSON(r))for(var i in r)this.set(i,r[i]);return this||t},get:function get(t){if(!t){var r={};this.forEach((function(t,e){return r[t]=e}));return r}if("?"===t.charAt(0))return this.has(t.substr(1));var n=arguments;if(n.length>1){var i={};for(var o=0,s=n.length;o<s;o++){var f=deserialize(e.getItem(n[o]));this.has(n[o])&&(i[n[o]]=f)}return i}return deserialize(e.getItem(t))},clear:function clear(){e.clear();return this||t},remove:function remove(t){var r=this.get(t);e.removeItem(t);return r},has:function has(t){return{}.hasOwnProperty.call(this.get(),t)},keys:function keys(){var t=[];this.forEach((function(e){t.push(e)}));return t},forEach:function forEach(r){for(var n=0,i=e.length;n<i;n++){var o=e.key(n);r(o,this.get(o))}return this||t},search:function search(t){var e=this.keys(),r={};for(var n=0,i=e.length;n<i;n++)e[n].indexOf(t)>-1&&(r[e[n]]=this.get(e[n]));return r}};var r=null;function store(t,e){var n=arguments;var i=null;r||(r=Store());if(0===n.length)return r.get();if(1===n.length){if("string"===typeof t)return r.get(t);if(isJSON(t))return r.set(t)}if(2===n.length&&"string"===typeof t){if(!e)return r.remove(t);if(e&&"string"===typeof e)return r.set(t,e);if(e&&isFunction(e)){i=null;i=e(t,r.get(t));store.set(t,i)}}if(2===n.length&&isArray(t)&&isFunction(e))for(var o=0,s=t.length;o<s;o++){i=e(t[o],r.get(t[o]));store.set(t[o],i)}return store}for(var n in Store.prototype)store[n]=Store.prototype[n];return store}));var r=e;export{r as default};
