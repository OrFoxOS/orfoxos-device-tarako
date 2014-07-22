
pref("layers.composer2d.enabled", false);

// Geolocation configuration to use the Mozilla Location Service.
pref("geo.provider.use_mls", true);
pref("geo.wifi.uri", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
pref("geo.cell.scan", true);

pref("hal.processPriorityManager.gonk.BACKGROUND.KillUnderKB", 18432);
pref("hal.processPriorityManager.gonk.PREALLOC.OomScoreAdjust", 267);

pref("image.mem.max_decoded_image_kb", 14400);
