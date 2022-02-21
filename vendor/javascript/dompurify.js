var e={};(function(t,r){e=r()})(e,(function(){function _toConsumableArray$1(e){if(Array.isArray(e)){for(var t=0,r=Array(e.length);t<e.length;t++)r[t]=e[t];return r}return Array.from(e)}var e=Object.hasOwnProperty;var t=Object.setPrototypeOf;var r=Object.isFrozen;var a=Object.keys;var n=Object.freeze;var o=Object.seal;var i="undefined"!==typeof Reflect&&Reflect;var l=i.apply;var s=i.construct;l||(l=function apply(e,t,r){return e.apply(t,r)});n||(n=function freeze(e){return e});o||(o=function seal(e){return e});s||(s=function construct(e,t){return new(Function.prototype.bind.apply(e,[null].concat(_toConsumableArray$1(t))))});var u=unapply(Array.prototype.forEach);var c=unapply(Array.prototype.indexOf);var d=unapply(Array.prototype.join);var f=unapply(Array.prototype.pop);var p=unapply(Array.prototype.push);var m=unapply(Array.prototype.slice);var v=unapply(String.prototype.toLowerCase);var y=unapply(String.prototype.match);var h=unapply(String.prototype.replace);var g=unapply(String.prototype.indexOf);var T=unapply(String.prototype.trim);var b=unapply(RegExp.prototype.test);var A=unconstruct(RegExp);var S=unconstruct(TypeError);function unapply(e){return function(t){for(var r=arguments.length,a=Array(r>1?r-1:0),n=1;n<r;n++)a[n-1]=arguments[n];return l(e,t,a)}}function unconstruct(e){return function(){for(var t=arguments.length,r=Array(t),a=0;a<t;a++)r[a]=arguments[a];return s(e,r)}}function addToSet(e,a){t&&t(e,null);var n=a.length;while(n--){var o=a[n];if("string"===typeof o){var i=v(o);if(i!==o){r(a)||(a[n]=i);o=i}}e[o]=true}return e}function clone(t){var r={};var a=void 0;for(a in t)l(e,t,[a])&&(r[a]=t[a]);return r}var _=n(["a","abbr","acronym","address","area","article","aside","audio","b","bdi","bdo","big","blink","blockquote","body","br","button","canvas","caption","center","cite","code","col","colgroup","content","data","datalist","dd","decorator","del","details","dfn","dir","div","dl","dt","element","em","fieldset","figcaption","figure","font","footer","form","h1","h2","h3","h4","h5","h6","head","header","hgroup","hr","html","i","img","input","ins","kbd","label","legend","li","main","map","mark","marquee","menu","menuitem","meter","nav","nobr","ol","optgroup","option","output","p","picture","pre","progress","q","rp","rt","ruby","s","samp","section","select","shadow","small","source","spacer","span","strike","strong","style","sub","summary","sup","table","tbody","td","template","textarea","tfoot","th","thead","time","tr","track","tt","u","ul","var","video","wbr"]);var x=n(["svg","a","altglyph","altglyphdef","altglyphitem","animatecolor","animatemotion","animatetransform","audio","canvas","circle","clippath","defs","desc","ellipse","filter","font","g","glyph","glyphref","hkern","image","line","lineargradient","marker","mask","metadata","mpath","path","pattern","polygon","polyline","radialgradient","rect","stop","style","switch","symbol","text","textpath","title","tref","tspan","video","view","vkern"]);var M=n(["feBlend","feColorMatrix","feComponentTransfer","feComposite","feConvolveMatrix","feDiffuseLighting","feDisplacementMap","feDistantLight","feFlood","feFuncA","feFuncB","feFuncG","feFuncR","feGaussianBlur","feMerge","feMergeNode","feMorphology","feOffset","fePointLight","feSpecularLighting","feSpotLight","feTile","feTurbulence"]);var L=n(["math","menclose","merror","mfenced","mfrac","mglyph","mi","mlabeledtr","mmultiscripts","mn","mo","mover","mpadded","mphantom","mroot","mrow","ms","mspace","msqrt","mstyle","msub","msup","msubsup","mtable","mtd","mtext","mtr","munder","munderover"]);var E=n(["#text"]);var k=n(["accept","action","align","alt","autocomplete","background","bgcolor","border","cellpadding","cellspacing","checked","cite","class","clear","color","cols","colspan","controls","coords","crossorigin","datetime","default","dir","disabled","download","enctype","face","for","headers","height","hidden","high","href","hreflang","id","integrity","ismap","label","lang","list","loop","low","max","maxlength","media","method","min","minlength","multiple","name","noshade","novalidate","nowrap","open","optimum","pattern","placeholder","poster","preload","pubdate","radiogroup","readonly","rel","required","rev","reversed","role","rows","rowspan","spellcheck","scope","selected","shape","size","sizes","span","srclang","start","src","srcset","step","style","summary","tabindex","title","type","usemap","valign","value","width","xmlns"]);var w=n(["accent-height","accumulate","additive","alignment-baseline","ascent","attributename","attributetype","azimuth","basefrequency","baseline-shift","begin","bias","by","class","clip","clip-path","clip-rule","color","color-interpolation","color-interpolation-filters","color-profile","color-rendering","cx","cy","d","dx","dy","diffuseconstant","direction","display","divisor","dur","edgemode","elevation","end","fill","fill-opacity","fill-rule","filter","filterunits","flood-color","flood-opacity","font-family","font-size","font-size-adjust","font-stretch","font-style","font-variant","font-weight","fx","fy","g1","g2","glyph-name","glyphref","gradientunits","gradienttransform","height","href","id","image-rendering","in","in2","k","k1","k2","k3","k4","kerning","keypoints","keysplines","keytimes","lang","lengthadjust","letter-spacing","kernelmatrix","kernelunitlength","lighting-color","local","marker-end","marker-mid","marker-start","markerheight","markerunits","markerwidth","maskcontentunits","maskunits","max","mask","media","method","mode","min","name","numoctaves","offset","operator","opacity","order","orient","orientation","origin","overflow","paint-order","path","pathlength","patterncontentunits","patterntransform","patternunits","points","preservealpha","preserveaspectratio","primitiveunits","r","rx","ry","radius","refx","refy","repeatcount","repeatdur","restart","result","rotate","scale","seed","shape-rendering","specularconstant","specularexponent","spreadmethod","stddeviation","stitchtiles","stop-color","stop-opacity","stroke-dasharray","stroke-dashoffset","stroke-linecap","stroke-linejoin","stroke-miterlimit","stroke-opacity","stroke","stroke-width","style","surfacescale","tabindex","targetx","targety","transform","text-anchor","text-decoration","text-rendering","textlength","type","u1","u2","unicode","values","viewbox","visibility","version","vert-adv-y","vert-origin-x","vert-origin-y","width","word-spacing","wrap","writing-mode","xchannelselector","ychannelselector","x","x1","x2","xmlns","y","y1","y2","z","zoomandpan"]);var D=n(["accent","accentunder","align","bevelled","close","columnsalign","columnlines","columnspan","denomalign","depth","dir","display","displaystyle","encoding","fence","frame","height","href","id","largeop","length","linethickness","lspace","lquote","mathbackground","mathcolor","mathsize","mathvariant","maxsize","minsize","movablelimits","notation","numalign","open","rowalign","rowlines","rowspacing","rowspan","rspace","rquote","scriptlevel","scriptminsize","scriptsizemultiplier","selection","separator","separators","stretchy","subscriptshift","supscriptshift","symmetric","voffset","width","xmlns"]);var O=n(["xlink:href","xml:id","xlink:title","xml:space","xmlns:xlink"]);var N=o(/\{\{[\s\S]*|[\s\S]*\}\}/gm);var R=o(/<%[\s\S]*|[\s\S]*%>/gm);var C=o(/^data-[\-\w.\u00B7-\uFFFF]/);var H=o(/^aria-[\-\w]+$/);var z=o(/^(?:(?:(?:f|ht)tps?|mailto|tel|callto|cid|xmpp):|[^a-z]|[a-z+.\-]+(?:[^a-z+.\-:]|$))/i);var F=o(/^(?:\w+script|data):/i);var I=o(/[\u0000-\u0020\u00A0\u1680\u180E\u2000-\u2029\u205f\u3000]/g);var P="function"===typeof Symbol&&"symbol"===typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"===typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e};function _toConsumableArray(e){if(Array.isArray(e)){for(var t=0,r=Array(e.length);t<e.length;t++)r[t]=e[t];return r}return Array.from(e)}var U=function getGlobal(){return"undefined"===typeof window?null:window};
/**
   * Creates a no-op policy for internal use only.
   * Don't export this function outside this module!
   * @param {?TrustedTypePolicyFactory} trustedTypes The policy factory.
   * @param {Document} document The document object (to determine policy name suffix)
   * @return {?TrustedTypePolicy} The policy created (or null, if Trusted Types
   * are not supported).
   */var j=function _createTrustedTypesPolicy(e,t){if("object"!==("undefined"===typeof e?"undefined":P(e))||"function"!==typeof e.createPolicy)return null;var r=null;var a="data-tt-policy-suffix";t.currentScript&&t.currentScript.hasAttribute(a)&&(r=t.currentScript.getAttribute(a));var n="dompurify"+(r?"#"+r:"");try{return e.createPolicy(n,{createHTML:function createHTML(e){return e}})}catch(e){console.warn("TrustedTypes policy "+n+" could not be created.");return null}};function createDOMPurify(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:U();var t=function DOMPurify(e){return createDOMPurify(e)};t.version="2.0.8";t.removed=[];if(!e||!e.document||9!==e.document.nodeType){t.isSupported=false;return t}var r=e.document;var o=false;var i=false;var l=e.document;var s=e.DocumentFragment,W=e.HTMLTemplateElement,B=e.Node,G=e.NodeFilter,q=e.NamedNodeMap,V=void 0===q?e.NamedNodeMap||e.MozNamedAttrMap:q,K=e.Text,Y=e.Comment,$=e.DOMParser,X=e.trustedTypes;if("function"===typeof W){var J=l.createElement("template");J.content&&J.content.ownerDocument&&(l=J.content.ownerDocument)}var Q=j(X,r);var Z=Q?Q.createHTML(""):"";var ee=l,te=ee.implementation,re=ee.createNodeIterator,ae=ee.getElementsByTagName,ne=ee.createDocumentFragment;var oe=r.importNode;var ie={};t.isSupported=te&&"undefined"!==typeof te.createHTMLDocument&&9!==l.documentMode;var le=N,se=R,ue=C,ce=H,de=F,fe=I;var pe=z;var me=null;var ve=addToSet({},[].concat(_toConsumableArray(_),_toConsumableArray(x),_toConsumableArray(M),_toConsumableArray(L),_toConsumableArray(E)));var ye=null;var he=addToSet({},[].concat(_toConsumableArray(k),_toConsumableArray(w),_toConsumableArray(D),_toConsumableArray(O)));var ge=null;var Te=null;var be=true;var Ae=true;var Se=false;var _e=false;var xe=false;var Me=false;var Le=false;var Ee=false;var ke=false;var we=false;var De=false;var Oe=false;var Ne=true;var Re=true;var Ce=false;var He={};var ze=addToSet({},["annotation-xml","audio","colgroup","desc","foreignobject","head","iframe","math","mi","mn","mo","ms","mtext","noembed","noframes","plaintext","script","style","svg","template","thead","title","video","xmp"]);var Fe=addToSet({},["audio","video","img","source","image"]);var Ie=null;var Pe=addToSet({},["alt","class","for","id","label","name","pattern","placeholder","summary","title","value","style","xmlns"]);var Ue=null;var je=l.createElement("form");
/**
     * _parseConfig
     *
     * @param  {Object} cfg optional config literal
     */var We=function _parseConfig(e){if(!Ue||Ue!==e){e&&"object"===("undefined"===typeof e?"undefined":P(e))||(e={});me="ALLOWED_TAGS"in e?addToSet({},e.ALLOWED_TAGS):ve;ye="ALLOWED_ATTR"in e?addToSet({},e.ALLOWED_ATTR):he;Ie="ADD_URI_SAFE_ATTR"in e?addToSet(clone(Pe),e.ADD_URI_SAFE_ATTR):Pe;ge="FORBID_TAGS"in e?addToSet({},e.FORBID_TAGS):{};Te="FORBID_ATTR"in e?addToSet({},e.FORBID_ATTR):{};He="USE_PROFILES"in e&&e.USE_PROFILES;be=false!==e.ALLOW_ARIA_ATTR;Ae=false!==e.ALLOW_DATA_ATTR;Se=e.ALLOW_UNKNOWN_PROTOCOLS||false;_e=e.SAFE_FOR_JQUERY||false;xe=e.SAFE_FOR_TEMPLATES||false;Me=e.WHOLE_DOCUMENT||false;ke=e.RETURN_DOM||false;we=e.RETURN_DOM_FRAGMENT||false;De=e.RETURN_DOM_IMPORT||false;Oe=e.RETURN_TRUSTED_TYPE||false;Ee=e.FORCE_BODY||false;Ne=false!==e.SANITIZE_DOM;Re=false!==e.KEEP_CONTENT;Ce=e.IN_PLACE||false;pe=e.ALLOWED_URI_REGEXP||pe;xe&&(Ae=false);we&&(ke=true);if(He){me=addToSet({},[].concat(_toConsumableArray(E)));ye=[];if(true===He.html){addToSet(me,_);addToSet(ye,k)}if(true===He.svg){addToSet(me,x);addToSet(ye,w);addToSet(ye,O)}if(true===He.svgFilters){addToSet(me,M);addToSet(ye,w);addToSet(ye,O)}if(true===He.mathMl){addToSet(me,L);addToSet(ye,D);addToSet(ye,O)}}if(e.ADD_TAGS){me===ve&&(me=clone(me));addToSet(me,e.ADD_TAGS)}if(e.ADD_ATTR){ye===he&&(ye=clone(ye));addToSet(ye,e.ADD_ATTR)}e.ADD_URI_SAFE_ATTR&&addToSet(Ie,e.ADD_URI_SAFE_ATTR);Re&&(me["#text"]=true);Me&&addToSet(me,["html","head","body"]);if(me.table){addToSet(me,["tbody"]);delete ge.tbody}n&&n(e);Ue=e}};
/**
     * _forceRemove
     *
     * @param  {Node} node a DOM node
     */var Be=function _forceRemove(e){p(t.removed,{element:e});try{e.parentNode.removeChild(e)}catch(t){e.outerHTML=Z}};
/**
     * _removeAttribute
     *
     * @param  {String} name an Attribute name
     * @param  {Node} node a DOM node
     */var Ge=function _removeAttribute(e,r){try{p(t.removed,{attribute:r.getAttributeNode(e),from:r})}catch(e){p(t.removed,{attribute:null,from:r})}r.removeAttribute(e)};
/**
     * _initDocument
     *
     * @param  {String} dirty a string of dirty markup
     * @return {Document} a DOM, filled with the dirty markup
     */var qe=function _initDocument(e){var t=void 0;var r=void 0;if(Ee)e="<remove></remove>"+e;else{var a=y(e,/^[\s]+/);r=a&&a[0]}var n=Q?Q.createHTML(e):e;if(o)try{t=(new $).parseFromString(n,"text/html")}catch(e){}i&&addToSet(ge,["title"]);if(!t||!t.documentElement){t=te.createHTMLDocument("");var s=t,u=s.body;u.parentNode.removeChild(u.parentNode.firstElementChild);u.outerHTML=n}e&&r&&t.body.insertBefore(l.createTextNode(r),t.body.childNodes[0]||null);return ae.call(t,Me?"html":"body")[0]};if(t.isSupported){(function(){try{var e=qe('<svg><p><textarea><img src="</textarea><img src=x abc=1//">');e.querySelector("svg img")&&(o=true)}catch(e){}})();(function(){try{var e=qe("<x/><title>&lt;/title&gt;&lt;img&gt;");b(/<\/title/,e.querySelector("title").innerHTML)&&(i=true)}catch(e){}})()}
/**
     * _createIterator
     *
     * @param  {Document} root document/fragment to create iterator for
     * @return {Iterator} iterator instance
     */var Ve=function _createIterator(e){return re.call(e.ownerDocument||e,e,G.SHOW_ELEMENT|G.SHOW_COMMENT|G.SHOW_TEXT,(function(){return G.FILTER_ACCEPT}),false)};
/**
     * _isClobbered
     *
     * @param  {Node} elm element to check for clobbering attacks
     * @return {Boolean} true if clobbered, false if safe
     */var Ke=function _isClobbered(e){return!(e instanceof K||e instanceof Y)&&!("string"===typeof e.nodeName&&"string"===typeof e.textContent&&"function"===typeof e.removeChild&&e.attributes instanceof V&&"function"===typeof e.removeAttribute&&"function"===typeof e.setAttribute&&"string"===typeof e.namespaceURI)};
/**
     * _isNode
     *
     * @param  {Node} obj object to check whether it's a DOM node
     * @return {Boolean} true is object is a DOM node
     */var Ye=function _isNode(e){return"object"===("undefined"===typeof B?"undefined":P(B))?e instanceof B:e&&"object"===("undefined"===typeof e?"undefined":P(e))&&"number"===typeof e.nodeType&&"string"===typeof e.nodeName};
/**
     * _executeHook
     * Execute user configurable hooks
     *
     * @param  {String} entryPoint  Name of the hook's entry point
     * @param  {Node} currentNode node to work on with the hook
     * @param  {Object} data additional hook parameters
     */var $e=function _executeHook(e,r,a){ie[e]&&u(ie[e],(function(e){e.call(t,r,a,Ue)}))};
/**
     * _sanitizeElements
     *
     * @protect nodeName
     * @protect textContent
     * @protect removeChild
     *
     * @param   {Node} currentNode to check for permission to exist
     * @return  {Boolean} true if node was killed, false if left alive
     */var Xe=function _sanitizeElements(e){var r=void 0;$e("beforeSanitizeElements",e,null);if(Ke(e)){Be(e);return true}var a=v(e.nodeName);$e("uponSanitizeElement",e,{tagName:a,allowedTags:me});if(("svg"===a||"math"===a)&&0!==e.querySelectorAll("p, br").length){Be(e);return true}if(!me[a]||ge[a]){if(Re&&!ze[a]&&"function"===typeof e.insertAdjacentHTML)try{var n=e.innerHTML;e.insertAdjacentHTML("AfterEnd",Q?Q.createHTML(n):n)}catch(e){}Be(e);return true}if("noscript"===a&&b(/<\/noscript/i,e.innerHTML)){Be(e);return true}if("noembed"===a&&b(/<\/noembed/i,e.innerHTML)){Be(e);return true}if(_e&&!e.firstElementChild&&(!e.content||!e.content.firstElementChild)&&b(/</g,e.textContent)){p(t.removed,{element:e.cloneNode()});e.innerHTML?e.innerHTML=h(e.innerHTML,/</g,"&lt;"):e.innerHTML=h(e.textContent,/</g,"&lt;")}if(xe&&3===e.nodeType){r=e.textContent;r=h(r,le," ");r=h(r,se," ");if(e.textContent!==r){p(t.removed,{element:e.cloneNode()});e.textContent=r}}$e("afterSanitizeElements",e,null);return false};
/**
     * _isValidAttribute
     *
     * @param  {string} lcTag Lowercase tag name of containing element.
     * @param  {string} lcName Lowercase attribute name.
     * @param  {string} value Attribute value.
     * @return {Boolean} Returns true if `value` is valid, otherwise false.
     */var Je=function _isValidAttribute(e,t,r){if(Ne&&("id"===t||"name"===t)&&(r in l||r in je))return false;if(Ae&&b(ue,t));else if(be&&b(ce,t));else{if(!ye[t]||Te[t])return false;if(Ie[t]);else if(b(pe,h(r,fe,"")));else if("src"!==t&&"xlink:href"!==t&&"href"!==t||"script"===e||0!==g(r,"data:")||!Fe[e]){if(Se&&!b(de,h(r,fe,"")));else if(r)return false}else;}return true};
/**
     * _sanitizeAttributes
     *
     * @protect attributes
     * @protect nodeName
     * @protect removeAttribute
     * @protect setAttribute
     *
     * @param  {Node} currentNode to sanitize
     */var Qe=function _sanitizeAttributes(e){var r=void 0;var n=void 0;var o=void 0;var i=void 0;var l=void 0;$e("beforeSanitizeAttributes",e,null);var s=e.attributes;if(s){var u={attrName:"",attrValue:"",keepAttr:true,allowedAttributes:ye};l=s.length;while(l--){r=s[l];var p=r,y=p.name,g=p.namespaceURI;n=T(r.value);o=v(y);u.attrName=o;u.attrValue=n;u.keepAttr=true;u.forceKeepAttr=void 0;$e("uponSanitizeAttribute",e,u);n=u.attrValue;if(!u.forceKeepAttr){if("name"===o&&"IMG"===e.nodeName&&s.id){i=s.id;s=m(s,[]);Ge("id",e);Ge(y,e);c(s,i)>l&&e.setAttribute("id",i.value)}else{if("INPUT"===e.nodeName&&"type"===o&&"file"===n&&u.keepAttr&&(ye[o]||!Te[o]))continue;"id"===y&&e.setAttribute(y,"");Ge(y,e)}if(u.keepAttr)if(_e&&b(/\/>/i,n))Ge(y,e);else if(b(/svg|math/i,e.namespaceURI)&&b(A("</("+d(a(ze),"|")+")","i"),n))Ge(y,e);else{if(xe){n=h(n,le," ");n=h(n,se," ")}var S=e.nodeName.toLowerCase();if(Je(S,o,n))try{g?e.setAttributeNS(g,y,n):e.setAttribute(y,n);f(t.removed)}catch(e){}}}}$e("afterSanitizeAttributes",e,null)}};
/**
     * _sanitizeShadowDOM
     *
     * @param  {DocumentFragment} fragment to iterate over recursively
     */var Ze=function _sanitizeShadowDOM(e){var t=void 0;var r=Ve(e);$e("beforeSanitizeShadowDOM",e,null);while(t=r.nextNode()){$e("uponSanitizeShadowNode",t,null);if(!Xe(t)){t.content instanceof s&&_sanitizeShadowDOM(t.content);Qe(t)}}$e("afterSanitizeShadowDOM",e,null)};
/**
     * Sanitize
     * Public method providing core sanitation functionality
     *
     * @param {String|Node} dirty string or DOM node
     * @param {Object} configuration object
     */t.sanitize=function(a,n){var o=void 0;var i=void 0;var l=void 0;var u=void 0;var c=void 0;a||(a="\x3c!--\x3e");if("string"!==typeof a&&!Ye(a)){if("function"!==typeof a.toString)throw S("toString is not a function");a=a.toString();if("string"!==typeof a)throw S("dirty is not a string, aborting")}if(!t.isSupported){if("object"===P(e.toStaticHTML)||"function"===typeof e.toStaticHTML){if("string"===typeof a)return e.toStaticHTML(a);if(Ye(a))return e.toStaticHTML(a.outerHTML)}return a}Le||We(n);t.removed=[];"string"===typeof a&&(Ce=false);if(Ce);else if(a instanceof B){o=qe("\x3c!--\x3e");i=o.ownerDocument.importNode(a,true);1===i.nodeType&&"BODY"===i.nodeName||"HTML"===i.nodeName?o=i:o.appendChild(i)}else{if(!ke&&!xe&&!Me&&Oe&&-1===a.indexOf("<"))return Q?Q.createHTML(a):a;o=qe(a);if(!o)return ke?null:Z}o&&Ee&&Be(o.firstChild);var d=Ve(Ce?a:o);while(l=d.nextNode())if((3!==l.nodeType||l!==u)&&!Xe(l)){l.content instanceof s&&Ze(l.content);Qe(l);u=l}u=null;if(Ce)return a;if(ke){if(we){c=ne.call(o.ownerDocument);while(o.firstChild)c.appendChild(o.firstChild)}else c=o;De&&(c=oe.call(r,c,true));return c}var f=Me?o.outerHTML:o.innerHTML;if(xe){f=h(f,le," ");f=h(f,se," ")}return Q&&Oe?Q.createHTML(f):f};
/**
     * Public method to set the configuration once
     * setConfig
     *
     * @param {Object} cfg configuration object
     */t.setConfig=function(e){We(e);Le=true};t.clearConfig=function(){Ue=null;Le=false};
/**
     * Public method to check if an attribute value is valid.
     * Uses last set config, if any. Otherwise, uses config defaults.
     * isValidAttribute
     *
     * @param  {string} tag Tag name of containing element.
     * @param  {string} attr Attribute name.
     * @param  {string} value Attribute value.
     * @return {Boolean} Returns true if `value` is valid. Otherwise, returns false.
     */t.isValidAttribute=function(e,t,r){Ue||We({});var a=v(e);var n=v(t);return Je(a,n,r)};
/**
     * AddHook
     * Public method to add DOMPurify hooks
     *
     * @param {String} entryPoint entry point for the hook to add
     * @param {Function} hookFunction function to execute
     */t.addHook=function(e,t){if("function"===typeof t){ie[e]=ie[e]||[];p(ie[e],t)}};
/**
     * RemoveHook
     * Public method to remove a DOMPurify hook at a given entryPoint
     * (pops it from the stack of hooks if more are present)
     *
     * @param {String} entryPoint entry point for the hook to remove
     */t.removeHook=function(e){ie[e]&&f(ie[e])};
/**
     * RemoveHooks
     * Public method to remove all DOMPurify hooks at a given entryPoint
     *
     * @param  {String} entryPoint entry point for the hooks to remove
     */t.removeHooks=function(e){ie[e]&&(ie[e]=[])};t.removeAllHooks=function(){ie={}};return t}var W=createDOMPurify();return W}));var t=e;export default t;

