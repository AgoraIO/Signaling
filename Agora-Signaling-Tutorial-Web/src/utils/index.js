/*
 * Logger
 */
const Logger = {
  log(m) {
    console.log(m);
  }
};

/*
 * Browser Utils
 */
const Browser = {
  getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
      results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
  }
};

const REPLACE_TABLE = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;'
};

const Utils = {
  _replaceTag(tag) {
    return REPLACE_TABLE[tag] || tag;
  },

  safe_tags_replace(str) {
    return str.replace(/[&<>]/g, Utils._replaceTag);
  }
};

export { Logger, Browser, Utils };
