import e from"moment";var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var n={};(function(t,a){var i;try{i=e}catch(e){}n=a(i)})(n,(function(e){var n="function"===typeof e,a=!!window.addEventListener,i=window.document,s=window.setTimeout,addEvent=function(e,t,n,i){a?e.addEventListener(t,n,!!i):e.attachEvent("on"+t,n)},removeEvent=function(e,t,n,i){a?e.removeEventListener(t,n,!!i):e.detachEvent("on"+t,n)},trim=function(e){return e.trim?e.trim():e.replace(/^\s+|\s+$/g,"")},hasClass=function(e,t){return-1!==(" "+e.className+" ").indexOf(" "+t+" ")},addClass=function(e,t){hasClass(e,t)||(e.className=""===e.className?t:e.className+" "+t)},removeClass=function(e,t){e.className=trim((" "+e.className+" ").replace(" "+t+" "," "))},isArray=function(e){return/Array/.test(Object.prototype.toString.call(e))},isDate=function(e){return/Date/.test(Object.prototype.toString.call(e))&&!isNaN(e.getTime())},isWeekend=function(e){var t=e.getDay();return 0===t||6===t},isLeapYear=function(e){return e%4===0&&e%100!==0||e%400===0},getDaysInMonth=function(e,t){return[31,isLeapYear(e)?29:28,31,30,31,30,31,31,30,31,30,31][t]},setToStartOfDay=function(e){isDate(e)&&e.setHours(0,0,0,0)},compareDates=function(e,t){return e.getTime()===t.getTime()},extend=function(e,t,n){var a,i;for(a in t){i=void 0!==e[a];i&&"object"===typeof t[a]&&null!==t[a]&&void 0===t[a].nodeName?isDate(t[a])?n&&(e[a]=new Date(t[a].getTime())):isArray(t[a])?n&&(e[a]=t[a].slice(0)):e[a]=extend({},t[a],n):!n&&i||(e[a]=t[a])}return e},fireEvent=function(e,t,n){var a;if(i.createEvent){a=i.createEvent("HTMLEvents");a.initEvent(t,true,false);a=extend(a,n);e.dispatchEvent(a)}else if(i.createEventObject){a=i.createEventObject();a=extend(a,n);e.fireEvent("on"+t,a)}},adjustCalendar=function(e){if(e.month<0){e.year-=Math.ceil(Math.abs(e.month)/12);e.month+=12}if(e.month>11){e.year+=Math.floor(Math.abs(e.month)/12);e.month-=12}return e},o={field:null,bound:void 0,ariaLabel:"Use the arrow keys to pick a date",position:"bottom left",reposition:true,format:"YYYY-MM-DD",toString:null,parse:null,defaultDate:null,setDefaultDate:false,firstDay:0,firstWeekOfYearMinDays:4,formatStrict:false,minDate:null,maxDate:null,yearRange:10,showWeekNumber:false,pickWholeWeek:false,minYear:0,maxYear:9999,minMonth:void 0,maxMonth:void 0,startRange:null,endRange:null,isRTL:false,yearSuffix:"",showMonthAfterYear:false,showDaysInNextAndPreviousMonths:false,enableSelectionDaysInNextAndPreviousMonths:false,numberOfMonths:1,mainCalendar:"left",container:void 0,blurFieldOnSelect:true,i18n:{previousMonth:"Previous Month",nextMonth:"Next Month",months:["January","February","March","April","May","June","July","August","September","October","November","December"],weekdays:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],weekdaysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]},theme:null,events:[],onSelect:null,onOpen:null,onClose:null,onDraw:null,keyboardInput:true},renderDayName=function(e,t,n){t+=e.firstDay;while(t>=7)t-=7;return n?e.i18n.weekdaysShort[t]:e.i18n.weekdays[t]},renderDay=function(e){var t=[];var n="false";if(e.isEmpty){if(!e.showDaysInNextAndPreviousMonths)return'<td class="is-empty"></td>';t.push("is-outside-current-month");e.enableSelectionDaysInNextAndPreviousMonths||t.push("is-selection-disabled")}e.isDisabled&&t.push("is-disabled");e.isToday&&t.push("is-today");if(e.isSelected){t.push("is-selected");n="true"}e.hasEvent&&t.push("has-event");e.isInRange&&t.push("is-inrange");e.isStartRange&&t.push("is-startrange");e.isEndRange&&t.push("is-endrange");return'<td data-day="'+e.day+'" class="'+t.join(" ")+'" aria-selected="'+n+'">'+'<button class="pika-button pika-day" type="button" '+'data-pika-year="'+e.year+'" data-pika-month="'+e.month+'" data-pika-day="'+e.day+'">'+e.day+"</button>"+"</td>"},isoWeek=function(e,t){e.setHours(0,0,0,0);var n=e.getDate(),a=e.getDay(),i=t,s=i-1,o=7,prevWeekDay=function(e){return(e+o-1)%o};e.setDate(n+s-prevWeekDay(a));var r=new Date(e.getFullYear(),0,i),l=24*60*60*1e3,h=(e.getTime()-r.getTime())/l,d=1+Math.round((h-s+prevWeekDay(r.getDay()))/o);return d},renderWeek=function(t,a,i,s){var o=new Date(i,a,t),r=n?e(o).isoWeek():isoWeek(o,s);return'<td class="pika-week">'+r+"</td>"},renderRow=function(e,t,n,a){return'<tr class="pika-row'+(n?" pick-whole-week":"")+(a?" is-selected":"")+'">'+(t?e.reverse():e).join("")+"</tr>"},renderBody=function(e){return"<tbody>"+e.join("")+"</tbody>"},renderHead=function(e){var t,n=[];e.showWeekNumber&&n.push("<th></th>");for(t=0;t<7;t++)n.push('<th scope="col"><abbr title="'+renderDayName(e,t)+'">'+renderDayName(e,t,true)+"</abbr></th>");return"<thead><tr>"+(e.isRTL?n.reverse():n).join("")+"</tr></thead>"},renderTitle=function(e,t,n,a,i,s){var o,r,l,h=e._o,d=n===h.minYear,u=n===h.maxYear,f='<div id="'+s+'" class="pika-title" role="heading" aria-live="assertive">',c,g,m=true,p=true;for(l=[],o=0;o<12;o++)l.push('<option value="'+(n===i?o-t:12+o-t)+'"'+(o===a?' selected="selected"':"")+(d&&o<h.minMonth||u&&o>h.maxMonth?' disabled="disabled"':"")+">"+h.i18n.months[o]+"</option>");c='<div class="pika-label">'+h.i18n.months[a]+'<select class="pika-select pika-select-month" tabindex="-1">'+l.join("")+"</select></div>";if(isArray(h.yearRange)){o=h.yearRange[0];r=h.yearRange[1]+1}else{o=n-h.yearRange;r=1+n+h.yearRange}for(l=[];o<r&&o<=h.maxYear;o++)o>=h.minYear&&l.push('<option value="'+o+'"'+(o===n?' selected="selected"':"")+">"+o+"</option>");g='<div class="pika-label">'+n+h.yearSuffix+'<select class="pika-select pika-select-year" tabindex="-1">'+l.join("")+"</select></div>";h.showMonthAfterYear?f+=g+c:f+=c+g;d&&(0===a||h.minMonth>=a)&&(m=false);u&&(11===a||h.maxMonth<=a)&&(p=false);0===t&&(f+='<button class="pika-prev'+(m?"":" is-disabled")+'" type="button">'+h.i18n.previousMonth+"</button>");t===e._o.numberOfMonths-1&&(f+='<button class="pika-next'+(p?"":" is-disabled")+'" type="button">'+h.i18n.nextMonth+"</button>");return f+="</div>"},renderTable=function(e,t,n){return'<table cellpadding="0" cellspacing="0" class="pika-table" role="grid" aria-labelledby="'+n+'">'+renderHead(e)+renderBody(t)+"</table>"},Pikaday=function(o){var r=this||t,l=r.config(o);r._onMouseDown=function(e){if(r._v){e=e||window.event;var t=e.target||e.srcElement;if(t){if(!hasClass(t,"is-disabled"))if(!hasClass(t,"pika-button")||hasClass(t,"is-empty")||hasClass(t.parentNode,"is-disabled"))hasClass(t,"pika-prev")?r.prevMonth():hasClass(t,"pika-next")&&r.nextMonth();else{r.setDate(new Date(t.getAttribute("data-pika-year"),t.getAttribute("data-pika-month"),t.getAttribute("data-pika-day")));l.bound&&s((function(){r.hide();l.blurFieldOnSelect&&l.field&&l.field.blur()}),100)}if(hasClass(t,"pika-select"))r._c=true;else{if(!e.preventDefault){e.returnValue=false;return false}e.preventDefault()}}}};r._onChange=function(e){e=e||window.event;var t=e.target||e.srcElement;t&&(hasClass(t,"pika-select-month")?r.gotoMonth(t.value):hasClass(t,"pika-select-year")&&r.gotoYear(t.value))};r._onKeyChange=function(e){e=e||window.event;if(r.isVisible())switch(e.keyCode){case 13:case 27:l.field&&l.field.blur();break;case 37:r.adjustDate("subtract",1);break;case 38:r.adjustDate("subtract",7);break;case 39:r.adjustDate("add",1);break;case 40:r.adjustDate("add",7);break;case 8:case 46:r.setDate(null);break}};r._parseFieldValue=function(){if(l.parse)return l.parse(l.field.value,l.format);if(n){var t=e(l.field.value,l.format,l.formatStrict);return t&&t.isValid()?t.toDate():null}return new Date(Date.parse(l.field.value))};r._onInputChange=function(e){var t;if(e.firedBy!==r){t=r._parseFieldValue();isDate(t)&&r.setDate(t);r._v||r.show()}};r._onInputFocus=function(){r.show()};r._onInputClick=function(){r.show()};r._onInputBlur=function(){var e=i.activeElement;do{if(hasClass(e,"pika-single"))return}while(e=e.parentNode);r._c||(r._b=s((function(){r.hide()}),50));r._c=false};r._onClick=function(e){e=e||window.event;var t=e.target||e.srcElement,n=t;if(t){if(!a&&hasClass(t,"pika-select")&&!t.onchange){t.setAttribute("onchange","return;");addEvent(t,"change",r._onChange)}do{if(hasClass(n,"pika-single")||n===l.trigger)return}while(n=n.parentNode);r._v&&t!==l.trigger&&n!==l.trigger&&r.hide()}};r.el=i.createElement("div");r.el.className="pika-single"+(l.isRTL?" is-rtl":"")+(l.theme?" "+l.theme:"");addEvent(r.el,"mousedown",r._onMouseDown,true);addEvent(r.el,"touchend",r._onMouseDown,true);addEvent(r.el,"change",r._onChange);l.keyboardInput&&addEvent(i,"keydown",r._onKeyChange);if(l.field){l.container?l.container.appendChild(r.el):l.bound?i.body.appendChild(r.el):l.field.parentNode.insertBefore(r.el,l.field.nextSibling);addEvent(l.field,"change",r._onInputChange);if(!l.defaultDate){l.defaultDate=r._parseFieldValue();l.setDefaultDate=true}}var h=l.defaultDate;isDate(h)?l.setDefaultDate?r.setDate(h,true):r.gotoDate(h):r.gotoDate(new Date);if(l.bound){this.hide();r.el.className+=" is-bound";addEvent(l.trigger,"click",r._onInputClick);addEvent(l.trigger,"focus",r._onInputFocus);addEvent(l.trigger,"blur",r._onInputBlur)}else this.show()};Pikaday.prototype={config:function(e){(this||t)._o||((this||t)._o=extend({},o,true));var n=extend((this||t)._o,e,true);n.isRTL=!!n.isRTL;n.field=n.field&&n.field.nodeName?n.field:null;n.theme="string"===typeof n.theme&&n.theme?n.theme:null;n.bound=!!(void 0!==n.bound?n.field&&n.bound:n.field);n.trigger=n.trigger&&n.trigger.nodeName?n.trigger:n.field;n.disableWeekends=!!n.disableWeekends;n.disableDayFn="function"===typeof n.disableDayFn?n.disableDayFn:null;var a=parseInt(n.numberOfMonths,10)||1;n.numberOfMonths=a>4?4:a;isDate(n.minDate)||(n.minDate=false);isDate(n.maxDate)||(n.maxDate=false);n.minDate&&n.maxDate&&n.maxDate<n.minDate&&(n.maxDate=n.minDate=false);n.minDate&&this.setMinDate(n.minDate);n.maxDate&&this.setMaxDate(n.maxDate);if(isArray(n.yearRange)){var i=(new Date).getFullYear()-10;n.yearRange[0]=parseInt(n.yearRange[0],10)||i;n.yearRange[1]=parseInt(n.yearRange[1],10)||i}else{n.yearRange=Math.abs(parseInt(n.yearRange,10))||o.yearRange;n.yearRange>100&&(n.yearRange=100)}return n},toString:function(a){a=a||(this||t)._o.format;return isDate((this||t)._d)?(this||t)._o.toString?(this||t)._o.toString((this||t)._d,a):n?e((this||t)._d).format(a):(this||t)._d.toDateString():""},getMoment:function(){return n?e((this||t)._d):null},setMoment:function(t,a){n&&e.isMoment(t)&&this.setDate(t.toDate(),a)},getDate:function(){return isDate((this||t)._d)?new Date((this||t)._d.getTime()):null},setDate:function(e,n){if(!e){(this||t)._d=null;if((this||t)._o.field){(this||t)._o.field.value="";fireEvent((this||t)._o.field,"change",{firedBy:this||t})}return this.draw()}"string"===typeof e&&(e=new Date(Date.parse(e)));if(isDate(e)){var a=(this||t)._o.minDate,i=(this||t)._o.maxDate;isDate(a)&&e<a?e=a:isDate(i)&&e>i&&(e=i);(this||t)._d=new Date(e.getTime());setToStartOfDay((this||t)._d);this.gotoDate((this||t)._d);if((this||t)._o.field){(this||t)._o.field.value=this.toString();fireEvent((this||t)._o.field,"change",{firedBy:this||t})}n||"function"!==typeof(this||t)._o.onSelect||(this||t)._o.onSelect.call(this||t,this.getDate())}},clear:function(){this.setDate(null)},gotoDate:function(e){var n=true;if(isDate(e)){if((this||t).calendars){var a=new Date((this||t).calendars[0].year,(this||t).calendars[0].month,1),i=new Date((this||t).calendars[(this||t).calendars.length-1].year,(this||t).calendars[(this||t).calendars.length-1].month,1),s=e.getTime();i.setMonth(i.getMonth()+1);i.setDate(i.getDate()-1);n=s<a.getTime()||i.getTime()<s}if(n){(this||t).calendars=[{month:e.getMonth(),year:e.getFullYear()}];"right"===(this||t)._o.mainCalendar&&((this||t).calendars[0].month+=1-(this||t)._o.numberOfMonths)}this.adjustCalendars()}},adjustDate:function(e,t){var n=this.getDate()||new Date;var a=24*parseInt(t)*60*60*1e3;var i;"add"===e?i=new Date(n.valueOf()+a):"subtract"===e&&(i=new Date(n.valueOf()-a));this.setDate(i)},adjustCalendars:function(){(this||t).calendars[0]=adjustCalendar((this||t).calendars[0]);for(var e=1;e<(this||t)._o.numberOfMonths;e++)(this||t).calendars[e]=adjustCalendar({month:(this||t).calendars[0].month+e,year:(this||t).calendars[0].year});this.draw()},gotoToday:function(){this.gotoDate(new Date)},gotoMonth:function(e){if(!isNaN(e)){(this||t).calendars[0].month=parseInt(e,10);this.adjustCalendars()}},nextMonth:function(){(this||t).calendars[0].month++;this.adjustCalendars()},prevMonth:function(){(this||t).calendars[0].month--;this.adjustCalendars()},gotoYear:function(e){if(!isNaN(e)){(this||t).calendars[0].year=parseInt(e,10);this.adjustCalendars()}},setMinDate:function(e){if(e instanceof Date){setToStartOfDay(e);(this||t)._o.minDate=e;(this||t)._o.minYear=e.getFullYear();(this||t)._o.minMonth=e.getMonth()}else{(this||t)._o.minDate=o.minDate;(this||t)._o.minYear=o.minYear;(this||t)._o.minMonth=o.minMonth;(this||t)._o.startRange=o.startRange}this.draw()},setMaxDate:function(e){if(e instanceof Date){setToStartOfDay(e);(this||t)._o.maxDate=e;(this||t)._o.maxYear=e.getFullYear();(this||t)._o.maxMonth=e.getMonth()}else{(this||t)._o.maxDate=o.maxDate;(this||t)._o.maxYear=o.maxYear;(this||t)._o.maxMonth=o.maxMonth;(this||t)._o.endRange=o.endRange}this.draw()},setStartRange:function(e){(this||t)._o.startRange=e},setEndRange:function(e){(this||t)._o.endRange=e},draw:function(e){if((this||t)._v||e){var n=(this||t)._o,a=n.minYear,i=n.maxYear,o=n.minMonth,r=n.maxMonth,l="",h;if((this||t)._y<=a){(this||t)._y=a;!isNaN(o)&&(this||t)._m<o&&((this||t)._m=o)}if((this||t)._y>=i){(this||t)._y=i;!isNaN(r)&&(this||t)._m>r&&((this||t)._m=r)}for(var d=0;d<n.numberOfMonths;d++){h="pika-title-"+Math.random().toString(36).replace(/[^a-z]+/g,"").substr(0,2);l+='<div class="pika-lendar">'+renderTitle(this||t,d,(this||t).calendars[d].year,(this||t).calendars[d].month,(this||t).calendars[0].year,h)+this.render((this||t).calendars[d].year,(this||t).calendars[d].month,h)+"</div>"}(this||t).el.innerHTML=l;n.bound&&"hidden"!==n.field.type&&s((function(){n.trigger.focus()}),1);"function"===typeof(this||t)._o.onDraw&&(this||t)._o.onDraw(this||t);n.bound&&n.field.setAttribute("aria-label",n.ariaLabel)}},adjustPosition:function(){var e,n,a,s,o,r,l,h,d,u,f,c;if(!(this||t)._o.container){(this||t).el.style.position="absolute";e=(this||t)._o.trigger;n=e;a=(this||t).el.offsetWidth;s=(this||t).el.offsetHeight;o=window.innerWidth||i.documentElement.clientWidth;r=window.innerHeight||i.documentElement.clientHeight;l=window.pageYOffset||i.body.scrollTop||i.documentElement.scrollTop;f=true;c=true;if("function"===typeof e.getBoundingClientRect){u=e.getBoundingClientRect();h=u.left+window.pageXOffset;d=u.bottom+window.pageYOffset}else{h=n.offsetLeft;d=n.offsetTop+n.offsetHeight;while(n=n.offsetParent){h+=n.offsetLeft;d+=n.offsetTop}}if((this||t)._o.reposition&&h+a>o||(this||t)._o.position.indexOf("right")>-1&&h-a+e.offsetWidth>0){h=h-a+e.offsetWidth;f=false}if((this||t)._o.reposition&&d+s>r+l||(this||t)._o.position.indexOf("top")>-1&&d-s-e.offsetHeight>0){d=d-s-e.offsetHeight;c=false}(this||t).el.style.left=h+"px";(this||t).el.style.top=d+"px";addClass((this||t).el,f?"left-aligned":"right-aligned");addClass((this||t).el,c?"bottom-aligned":"top-aligned");removeClass((this||t).el,f?"right-aligned":"left-aligned");removeClass((this||t).el,c?"top-aligned":"bottom-aligned")}},render:function(e,n,a){var i=(this||t)._o,s=new Date,o=getDaysInMonth(e,n),r=new Date(e,n,1).getDay(),l=[],h=[];setToStartOfDay(s);if(i.firstDay>0){r-=i.firstDay;r<0&&(r+=7)}var d=0===n?11:n-1,u=11===n?0:n+1,f=0===n?e-1:e,c=11===n?e+1:e,g=getDaysInMonth(f,d);var m=o+r,p=m;while(p>7)p-=7;m+=7-p;var y=false;for(var D=0,v=0;D<m;D++){var b=new Date(e,n,1+(D-r)),_=!!isDate((this||t)._d)&&compareDates(b,(this||t)._d),w=compareDates(b,s),k=-1!==i.events.indexOf(b.toDateString()),M=D<r||D>=o+r,x=1+(D-r),R=n,N=e,S=i.startRange&&compareDates(i.startRange,b),C=i.endRange&&compareDates(i.endRange,b),T=i.startRange&&i.endRange&&i.startRange<b&&b<i.endRange,I=i.minDate&&b<i.minDate||i.maxDate&&b>i.maxDate||i.disableWeekends&&isWeekend(b)||i.disableDayFn&&i.disableDayFn(b);if(M)if(D<r){x=g+x;R=d;N=f}else{x-=o;R=u;N=c}var Y={day:x,month:R,year:N,hasEvent:k,isSelected:_,isToday:w,isDisabled:I,isEmpty:M,isStartRange:S,isEndRange:C,isInRange:T,showDaysInNextAndPreviousMonths:i.showDaysInNextAndPreviousMonths,enableSelectionDaysInNextAndPreviousMonths:i.enableSelectionDaysInNextAndPreviousMonths};i.pickWholeWeek&&_&&(y=true);h.push(renderDay(Y));if(7===++v){i.showWeekNumber&&h.unshift(renderWeek(D-r,n,e,i.firstWeekOfYearMinDays));l.push(renderRow(h,i.isRTL,i.pickWholeWeek,y));h=[];v=0;y=false}}return renderTable(i,l,a)},isVisible:function(){return(this||t)._v},show:function(){if(!this.isVisible()){(this||t)._v=true;this.draw();removeClass((this||t).el,"is-hidden");if((this||t)._o.bound){addEvent(i,"click",(this||t)._onClick);this.adjustPosition()}"function"===typeof(this||t)._o.onOpen&&(this||t)._o.onOpen.call(this||t)}},hide:function(){var e=(this||t)._v;if(false!==e){(this||t)._o.bound&&removeEvent(i,"click",(this||t)._onClick);if(!(this||t)._o.container){(this||t).el.style.position="static";(this||t).el.style.left="auto";(this||t).el.style.top="auto"}addClass((this||t).el,"is-hidden");(this||t)._v=false;void 0!==e&&"function"===typeof(this||t)._o.onClose&&(this||t)._o.onClose.call(this||t)}},destroy:function(){var e=(this||t)._o;this.hide();removeEvent((this||t).el,"mousedown",(this||t)._onMouseDown,true);removeEvent((this||t).el,"touchend",(this||t)._onMouseDown,true);removeEvent((this||t).el,"change",(this||t)._onChange);e.keyboardInput&&removeEvent(i,"keydown",(this||t)._onKeyChange);if(e.field){removeEvent(e.field,"change",(this||t)._onInputChange);if(e.bound){removeEvent(e.trigger,"click",(this||t)._onInputClick);removeEvent(e.trigger,"focus",(this||t)._onInputFocus);removeEvent(e.trigger,"blur",(this||t)._onInputBlur)}}(this||t).el.parentNode&&(this||t).el.parentNode.removeChild((this||t).el)}};return Pikaday}));var a=n;export default a;

