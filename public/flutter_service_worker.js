'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b2d6d3b444002aefdc6a707d32ce93c1",
"assets/AssetManifest.bin.json": "5edce59f991626eb3c5b52298ed7dc17",
"assets/AssetManifest.json": "beb427537c6d4904e45fbe4fe87badd6",
"assets/assets/fonts/Pretendard-Bold.ttf": "dc5a0e145559879abb18d5969da0df6b",
"assets/assets/fonts/Pretendard-ExtraBold.ttf": "a75966342357de44f5a09d07b0ae535a",
"assets/assets/fonts/Pretendard-ExtraLight.ttf": "6ff96cb10994cadd3bf7bdc30cd31aa1",
"assets/assets/fonts/Pretendard-Light.ttf": "3a2c8b53f02202d322fa86eb9672ba30",
"assets/assets/fonts/Pretendard-Medium.ttf": "be5dedc52c0403d321e8202ae6aac2b3",
"assets/assets/fonts/Pretendard-Regular.ttf": "65e9a69de2d10a9e43102d5c5eae368b",
"assets/assets/fonts/Pretendard-SemiBold.ttf": "bc96c6e0e53f8f953912e93a1e50b8f7",
"assets/assets/fonts/Pretendard-Thin.ttf": "86fdcc882292e5db7d6bef1c68aceba6",
"assets/assets/fonts/PretendardVariable.ttf": "76eaa25ade00aa5f6efcb7e926001d7f",
"assets/assets/icons/activity%2520-%2520outline.svg": "5a360fa2acc4aa4b086dfafed2220c1a",
"assets/assets/icons/arrow-down-sign-to-navigate.svg": "3cdd2a9cb7d4fb2071b46a2d28542b51",
"assets/assets/icons/cancel%2520-%2520alt2.svg": "b255df90332c4b2db3967c776d2256b9",
"assets/assets/icons/check-button-filled.svg": "97e9004145d06e59da79044f2397a480",
"assets/assets/icons/check-button-outline.svg": "e518c0f89fc47a114a70ac2c1e922163",
"assets/assets/icons/Ellipse%2520201.svg": "f15cacffa2af89edde2c2555e8a43d2c",
"assets/assets/icons/heart%2520-%2520outline.svg": "0ae4d8a2d120770af859fe9dc02e3d44",
"assets/assets/icons/hide.svg": "7dae8e6d804c97a301397d368acaac4e",
"assets/assets/icons/home%2520-%2520solid.svg": "166024d1b33a2de0457b119cefc84024",
"assets/assets/icons/Icon%2520feather-loader%2520(1).svg": "5aea6dd0342e86fd024090e212e6e3d8",
"assets/assets/icons/Icon%2520feather-loader%2520(2).svg": "5aea6dd0342e86fd024090e212e6e3d8",
"assets/assets/icons/Icon%2520feather-loader.svg": "5aea6dd0342e86fd024090e212e6e3d8",
"assets/assets/icons/image.svg": "8a6cda809292454f5683e67ce637d3bb",
"assets/assets/icons/Rectangle%2520996.svg": "a1b97b0b52e7835cecc65502afefa37d",
"assets/assets/icons/sad.svg": "d07cb771e8c1cf5fa6457e17c3c8a525",
"assets/assets/icons/seen.svg": "1be414eec69220a1bbf65f7548d9bdb1",
"assets/assets/icons/settings%2520-%2520alt2%2520(1).svg": "9427ef069cf8353c7cb8fe7a90eea476",
"assets/assets/icons/settings%2520-%2520alt2.svg": "1e9321b13346d38ffd670e516b6b6eae",
"assets/assets/icons/user%2520-%2520outline.svg": "b2ee1d4d3000e059c41bbd6d8b75dfbb",
"assets/assets/images/brand.png": "70b311e09b7846a7af14ad18a81609d3",
"assets/assets/images/icon.png": "c1e8ae45e5aac4128e435e6c61ffbaa5",
"assets/assets/images/logo.png": "d642993d8e5b0a1e8e0e93990b715d66",
"assets/assets/jobs.json": "a0b6f62a9ac331f712552d63953be500",
"assets/FontManifest.json": "827e484abdbaf558602f39dfba55fcd2",
"assets/fonts/MaterialIcons-Regular.otf": "d5aaaefe95340b5d8674a96e30c778b2",
"assets/NOTICES": "ffaf119e00fa30930b31cb5070e528cb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "fa9ff48aae1cac069055abf007b71594",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3ac6e290754e3ef0efd2748e6a427504",
"/": "3ac6e290754e3ef0efd2748e6a427504",
"main.dart.js": "13c934efefa96ed495ca78880c9359ff",
"manifest.json": "b804278fe0d488c5239255ca3f8a5688",
"splash/img/dark-1x.png": "c31843238882b6ca762fe52117c104ad",
"splash/img/dark-2x.png": "4704e3997f38883c45bf2a0f137bcb57",
"splash/img/dark-3x.png": "8fd5a534ca1e812ebb4a4741598d9bee",
"splash/img/dark-4x.png": "f38791c120961e3fcd8920ad09a17e81",
"splash/img/light-1x.png": "c31843238882b6ca762fe52117c104ad",
"splash/img/light-2x.png": "4704e3997f38883c45bf2a0f137bcb57",
"splash/img/light-3x.png": "8fd5a534ca1e812ebb4a4741598d9bee",
"splash/img/light-4x.png": "f38791c120961e3fcd8920ad09a17e81",
"version.json": "bdc00508bf25aaa7f51424c9088d1398"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
