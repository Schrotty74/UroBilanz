const CACHE_NAME = "urobilanz-web-shell-v2";
const APP_SHELL = [
  "./",
  "./index.html",
  "./offline.html",
  "./manifest.webmanifest",
  "./styles.css",
  "./mobile.css",
  "./app.js",
  "./assets/urobilanz-app-icon.png",
  "./assets/urobilanz-pwa-192.png",
  "./assets/urobilanz-pwa-512.png",
  "./assets/discord-mark-white.svg",
  "./assets/github-invertocat-white.svg",
  "./assets/i18n/de.js",
  "./assets/i18n/en.js",
  "./assets/js/charts.js",
  "./assets/js/core.js",
  "./assets/js/medical-report.js",
  "./assets/js/themes.js",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(APP_SHELL))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((names) => Promise.all(names
        .filter((name) => name.startsWith("urobilanz-web-shell-") && name !== CACHE_NAME)
        .map((name) => caches.delete(name))))
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  event.respondWith(
    fetch(request)
      .then((response) => {
        if (!response.ok) return response;
        const cachedResponse = response.clone();
        event.waitUntil(
          caches.open(CACHE_NAME).then((cache) => cache.put(request, cachedResponse)),
        );
        return response;
      })
      .catch(async () => {
        const cached = await caches.match(request, { ignoreSearch: true });
        if (cached) return cached;
        if (request.mode === "navigate") return caches.match("./offline.html");
        return Response.error();
      }),
  );
});
