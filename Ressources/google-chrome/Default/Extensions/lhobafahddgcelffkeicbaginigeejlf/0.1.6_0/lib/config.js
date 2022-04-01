var config = {};

config.welcome = {
  set lastupdate (val) {app.storage.write("lastupdate", val)},
  get lastupdate () {return app.storage.read("lastupdate") !== undefined ? app.storage.read("lastupdate") : 0}
};

config.origin = function (url) {
  if (url) {
    var path = url.split('/');
    if (path && path.length) {
      var protocol = path[0];
      var hostname = path[2];
      return protocol + "//" + hostname;
    }
  }
  /*  */
  return '*';
};

config.hostname = function (url) {
  url = url ? url.replace("www.", '') : url;
  var s = url.indexOf("//") + 2;
  if (s > 1) {
    var o = url.indexOf('/', s);
    if (o > 0) return url.substring(s, o);
    else {
      o = url.indexOf('?', s);
      if (o > 0) return url.substring(s, o);
      else return url.substring(s);
    }
  } else return url;
};

config.addon = {
  "map": {
    "tabs": {},
    "headers": new Map()
  },
  "page": {
    "test": "https://webbrowsertools.com/test-cors/",
    "tutorial": "https://www.youtube.com/watch?v=KruSUqLdxQA"
  },
  "OPTIONS": {
    "request": navigator.userAgent.indexOf("Firefox") !== -1 ? ["blocking", "requestHeaders"] : ["blocking", "requestHeaders", "extraHeaders"],
    "response": navigator.userAgent.indexOf("Firefox") !== -1 ? ["blocking", "responseHeaders"] : ["blocking", "responseHeaders", "extraHeaders"]
  },
  /*  */
  set state (val) {app.storage.write("state", val)},
  get state () {return app.storage.read("state") !== undefined  ? app.storage.read("state") : "OFF"}
};

config.cors = {
  set origin (val) {app.storage.write("origin", val)},
  set methods (val) {app.storage.write("methods", val)},
  set headers (val) {app.storage.write("headers", val)},
  set redirect (val) {app.storage.write("redirect", val)},
  set whitelist (val) {app.storage.write("whitelist", val)},
  set credentials (val) {app.storage.write("credentials", val)},
  get origin () {return app.storage.read("origin") !== undefined ? app.storage.read("origin") : false},
  get headers () {return app.storage.read("headers") !== undefined ? app.storage.read("headers") : false},
  get redirect () {return app.storage.read("redirect") !== undefined ? app.storage.read("redirect") : true},
  get whitelist () {return app.storage.read("whitelist") !== undefined ? app.storage.read("whitelist") : []},
  get credentials () {return app.storage.read("credentials") !== undefined ? app.storage.read("credentials") : false},
  get methods () {return app.storage.read("methods") !== undefined ? app.storage.read("methods") : "GET, PUT, POST, DELETE, HEAD, OPTIONS"}
};