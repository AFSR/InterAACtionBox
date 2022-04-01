app.webrequest = {
  "on": {
    "headers": {
      "received": {
        "listener": null,
        "callback": function (callback) {
          app.webrequest.on.headers.received.listener = callback;
        },
        "remove": function () {
          if (chrome.webRequest) {
            chrome.webRequest.onHeadersReceived.removeListener(app.webrequest.on.headers.received.listener);
          }
        },
        "add": function (e) {
          var filter = e ? e : {"urls": ["*://*/*"]};
          var options = navigator.userAgent.indexOf("Firefox") !== -1 ? ["blocking", "responseHeaders"] : ["blocking", "responseHeaders", "extraHeaders"];
          /*  */
          if (chrome.webRequest) {
            chrome.webRequest.onHeadersReceived.removeListener(app.webrequest.on.headers.received.listener);
            chrome.webRequest.onHeadersReceived.addListener(app.webrequest.on.headers.received.listener, filter, options);
          }
        }
      }
    },
    "before": {
      "redirect": {
        "listener": null,
        "callback": function (callback) {
          app.webrequest.on.before.redirect.listener = callback;
        },
        "remove": function () {
          if (chrome.webRequest) {
            chrome.webRequest.onBeforeRedirect.removeListener(app.webrequest.on.before.redirect.listener);
          }
        },
        "add": function (e) {
          var filter = e ? e : {"urls": ["*://*/*"]};
          /*  */
          if (chrome.webRequest) {
            chrome.webRequest.onBeforeRedirect.removeListener(app.webrequest.on.before.redirect.listener);
            chrome.webRequest.onBeforeRedirect.addListener(app.webrequest.on.before.redirect.listener, filter);
          }
        }
      },
      "send": {
        "headers": {
          "listener": null,
          "callback": function (callback) {
            app.webrequest.on.before.send.headers.listener = callback;
          },
          "remove": function () {
            if (chrome.webRequest) {
              chrome.webRequest.onBeforeSendHeaders.removeListener(app.webrequest.on.before.send.headers.listener);
            }
          },
          "add": function (e) {
            var filter = e ? e : {"urls": ["*://*/*"]};
            var options = navigator.userAgent.indexOf("Firefox") !== -1 ? ["blocking", "requestHeaders"] : ["blocking", "requestHeaders", "extraHeaders"];
            /*  */
            if (chrome.webRequest) {
              chrome.webRequest.onBeforeSendHeaders.removeListener(app.webrequest.on.before.send.headers.listener);
              chrome.webRequest.onBeforeSendHeaders.addListener(app.webrequest.on.before.send.headers.listener, filter, options);
            }
          }
        }
      }
    }
  }
};