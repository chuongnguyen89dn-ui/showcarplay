# ShowCarPlay local patches

`bluetooth-clean-shutdown.patch` is the first targeted fix for the receiver leaving iOS Bluetooth unavailable after Showcase stops.

Intent:
- catch SIGTERM/SIGINT/SIGHUP;
- disconnect the active Bluetooth link;
- stop discoverability and BTstack controller power;
- call `btstack_set_system_bluetooth_enabled(1)` before exit;
- clear Showcase readiness files and mark Bluetooth down.

This patch must be applied and compiled before shipping a test .deb. It is kept separate first so the change is reviewable without replacing/truncating the large upstream `source/carplay_bt.m` through the connector.
