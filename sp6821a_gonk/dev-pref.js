
pref("layers.composer2d.enabled", false);

pref("dom.ipc.processPriorityManager.backgroundLRUPoolLevels", 2);

// Enable Out Of Background Process killer.
// Number of background process would have a hard limit according to the
// calculation result from backgroundLRUPoolLevels argument.
pref("hal.processPriorityManager.gonk.enableOOBPKiller", true);
 

pref("hal.processPriorityManager.gonk.MASTER.KillUnderMB", 1);

pref("hal.processPriorityManager.gonk.FOREGROUND_HIGH.KillUnderMB", 2);

pref("hal.processPriorityManager.gonk.FOREGROUND.KillUnderMB", 4);

pref("hal.processPriorityManager.gonk.BACKGROUND_PERCEIVABLE.KillUnderMB", 6);

pref("hal.processPriorityManager.gonk.BACKGROUND.KillUnderMB", 15);

pref("hal.processPriorityManager.gonk.notifyLowMemUnderMB", 10);