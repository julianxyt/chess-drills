/* Square Pressure offline cache. Bump VERSION when any shell file changes. */
var VERSION = "sp-v2";
var SHELL = [
  "./", "index.html", "manifest.webmanifest",
  "icons/icon.svg", "icons/icon-192.png", "icons/icon-512.png",
  "icons/icon-maskable-512.png", "icons/apple-touch-icon.png", "icons/square-pressure.ico"
];

self.addEventListener("install", function(e){
  e.waitUntil(caches.open(VERSION).then(function(c){ return c.addAll(SHELL); }).then(function(){ return self.skipWaiting(); }));
});

self.addEventListener("activate", function(e){
  e.waitUntil(caches.keys().then(function(keys){
    return Promise.all(keys.filter(function(k){ return k !== VERSION; }).map(function(k){ return caches.delete(k); }));
  }).then(function(){ return self.clients.claim(); }));
});

/* Network first for the page so updates land; cache first for everything else,
   including the Google Fonts files once they have been fetched online. */
self.addEventListener("fetch", function(e){
  var req = e.request;
  if (req.method !== "GET") return;
  if (req.mode === "navigate"){
    e.respondWith(fetch(req).then(function(res){
      var copy = res.clone();
      caches.open(VERSION).then(function(c){ c.put("index.html", copy); });
      return res;
    }).catch(function(){ return caches.match("index.html"); }));
    return;
  }
  e.respondWith(caches.match(req).then(function(hit){
    return hit || fetch(req).then(function(res){
      if (res.ok || res.type === "opaque"){
        var copy = res.clone();
        caches.open(VERSION).then(function(c){ c.put(req, copy); });
      }
      return res;
    });
  }));
});
