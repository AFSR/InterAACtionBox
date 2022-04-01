var core = {
  "start": function () {
    core.load();
  },
  "install": function () {
    core.load();
  },
  "load": function () {
    app.button.icon(config.addon.state);
    app.button.title("Access-Control-Allow-Origin: " + config.addon.state);
    /*  */
    app.webrequest.on.before.redirect.callback(core.listener.before.redirect);
    app.webrequest.on.headers.received.callback(core.listener.headers.received);
    app.webrequest.on.before.send.headers.callback(core.listener.before.send.headers);
    /*  */
    core.listener.update();
  },
  "update": {
    "state": function () {
      config.addon.state = config.addon.state === "ON" ? "OFF" : "ON";
      /*  */
      core.update.popup();
      core.listener.update();
      app.button.icon(config.addon.state);
      app.button.title("Access-Control-Allow-Origin: " + config.addon.state);
    },
    "popup": function () {
      app.tab.query.active(function (tab) {
        app.popup.send("storage", {
          "tab": tab,
          "state": config.addon.state,
          "whitelist": config.cors.whitelist
        });
      });
    },
    "options": function () {
      app.options.send("storage", {
        "origin": config.cors.origin,
        "methods": config.cors.methods,
        "headers": config.cors.headers,
        "redirect": config.cors.redirect,
        "whitelist": config.cors.whitelist,
        "credentials": config.cors.credentials
      });
    }
  },
  "listener": {
    "update": function () {
      app.webrequest.on.before.redirect.remove();
      app.webrequest.on.headers.received.remove();
      app.webrequest.on.before.send.headers.remove();
      /*  */
      if (config.addon.state === "ON") {
        app.webrequest.on.before.redirect.add({"urls": ["http://*/*", "https://*/*"]});
        app.webrequest.on.headers.received.add({"urls": ["http://*/*", "https://*/*"]});
        app.webrequest.on.before.send.headers.add({"urls": ["http://*/*", "https://*/*"]});
      }
    },
    "before": {
      "redirect": function (info) {
        var tmp = config.addon.map.tabs[info.tabId] ? config.addon.map.tabs[info.tabId] : {};
        tmp[info.requestId] = info.requestId;
        config.addon.map.tabs[info.tabId] = tmp;
      },
      "send": {
        "headers": function (info) {
          var requestHeaders = info.requestHeaders.find(e => e.name.toLowerCase() === "access-control-request-headers");
          if (requestHeaders) config.addon.map.headers.set(info.requestId, requestHeaders.value);
        }
      }
    },
    "headers": {
      "received": function (info) {
        var credentials = config.cors.credentials;
        var extra = config.addon.map.tabs[info.tabId]; 
        var top = info.initiator || info.documentUrl || info.originUrl || info.url;
        var redirect = extra && extra[info.requestId] === info.requestId ? config.cors.redirect : false;
        /*  */
        var hostname = top ? config.hostname(top) : '';
        if (config.cors.whitelist.indexOf(hostname) !== -1) return;
        /*  */
        var responseHeaders = info.responseHeaders.filter(e => e.name.toLowerCase() !== "access-control-allow-origin" && e.name.toLowerCase() !== "access-control-allow-methods");
      	responseHeaders.push({"name": "Access-Control-Allow-Origin", "value": config.cors.origin ? '*' : (redirect ? '*' : config.origin(top))});
        if (credentials) responseHeaders.push({"name": "Access-Control-Allow-Credentials", "value": JSON.stringify(credentials)});
        responseHeaders.push({"name": "Access-Control-Allow-Methods", "value": config.cors.methods});
        /*  */
        if (config.cors.headers) {
          if (config.addon.map.headers.has(info.requestId)) {
            responseHeaders.push({"name": "Access-Control-Allow-Headers", "value": config.addon.map.headers.get(info.requestId)});
            config.addon.map.headers.delete(info.requestId);
          }
        }
        /*  */
      	return {"responseHeaders": responseHeaders};
      }
    }
  }
};

app.popup.receive("whitelist", function () {
  app.tab.query.active(function (tab) {
    if (tab && tab.url) {
      if (tab.url.indexOf("http") === 0) {
        var tmp = new URL(tab.url);
        var whitelist = config.cors.whitelist;
        var hostname = tmp.hostname.replace("www.", '');
        /*  */
        var index = whitelist.indexOf(hostname);
        if (index !== -1) whitelist.splice(index, 1);
        else {
          whitelist.push(hostname);
          whitelist = whitelist.filter(function (a, b) {return whitelist.indexOf(a) === b});
        }
        /*  */
        config.cors.whitelist = whitelist;
      }
    }
    /*  */
    core.update.popup();
  });
});

app.popup.receive("load", core.update.popup);
app.popup.receive("options", app.tab.options);
app.popup.receive("toggle", core.update.state);
app.popup.receive("reload", function () {app.tab.reload(null, true)});
app.popup.receive("support", function () {app.tab.open(app.homepage())});
app.popup.receive("test", function () {app.tab.open(config.addon.page.test)});
app.popup.receive("tutorial", function () {app.tab.open(config.addon.page.tutorial)});
app.popup.receive("donation", function () {app.tab.open(app.homepage() + "?reason=support")});

app.options.receive("load", core.update.options);
app.options.receive("origin", function (e) {config.cors.origin = e});
app.options.receive("methods", function (e) {config.cors.methods = e});
app.options.receive("headers", function (e) {config.cors.headers = e});
app.options.receive("redirect", function (e) {config.cors.redirect = e});
app.options.receive("whitelist", function (e) {config.cors.whitelist = e});
app.options.receive("credentials", function (e) {config.cors.credentials = e});

app.on.startup(core.start);
app.on.installed(core.install);
app.hotkey.on.pressed("_mode", core.update.state);
app.tab.on.removed(function (tabId) {delete config.addon.map.tabs[tabId]});