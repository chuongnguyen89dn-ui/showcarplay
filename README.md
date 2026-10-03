# Showcase

## Updates

This repository contains the Showcase source. Install the packaged tweak from the Rostane source in Sileo.

```text
https://aminerostane.com/repo
```

- Routes navigation, call, radio, and media audio through the receiver.
- Fits CarPlay to the receiver's native aspect ratio without model presets.
- Improves frame pacing, transport-stall recovery, and touch response.
- Restores paired sessions after reconnects and app lifecycle changes.
- Adds a named Showcase vehicle app and removes the stray ETC indicator.
- Bundles CarPlay cryptography and removes the OpenSSL package dependency.
- Reports unsupported Bluetooth hardware instead of stalling during setup.
- Adds Apple ConvergedIPC/Skywalk HCI and ACL support while retaining the legacy UART backend.
- Keeps the display cutout away from CarPlay controls on modern iPhones.

Showcase turns an older jailbroken Apple device into a software wireless CarPlay receiver. The iPhone pairs through Settings, joins the receiver's hotspot, sends the encrypted CarPlay video stream, and receives touch input from the receiver.

Showcase beta 3 ships in rootful and rootless package layouts. Both use iOS 12 as the deployment minimum.

## Install

Add the package source in Sileo, Cydia, or Zebra.

```text
https://aminerostane.com/repo
```

Then install `Showcase`.

Install guide and protocol write-up

https://aminerostane.com/articles/showcase

## Requirements

| Item | Requirement |
| --- | --- |
| Receiver | Cellular iPhone or iPad with Personal Hotspot |
| Tested rootful receiver | iPad Air 1 cellular, A1475, iPad4,2, iOS 12.5.8, checkra1n |
| Tested rootless receiver | iPhone 7, iPhone9,3, iOS 15.8.4, Dopamine rootless |
| Runtime packages | Rootful uses `uikittools`; rootless uses `uikittools` and `ldid` |

Sileo, Cydia, and Zebra install runtime packages through normal APT dependency resolution. Manual dependency installation is only needed when sideloading a `.deb` with `dpkg -i`.

The package bundles `BTdaemon`, `libBTstack.dylib`, and the BTstack launch daemon needed for `/tmp/BTstack`. It conflicts with the old `ch.ringwald.btstack` package to avoid file ownership collisions.

## What Works

- Wireless CarPlay discovery over Bluetooth and AirPlay/mDNS.
- BTstack takeover while the receiver runs.
- iAP2 link setup, identification, BAA authentication, Wi-Fi handoff, and EAP session setup.
- AirPlay pair-setup, pair-verify, auth-setup, RTSP control, timing, event channel, and screen stream setup.
- H.264 screen stream decryption with ChaCha20-Poly1305.
- Single-finger touch forwarding over the encrypted event channel.
- BAA certificate preheating while the receiver still has internet access.
- Stream sizing derived from the receiver's native aspect ratio, memory, processor count, and decode budget.
- Sender-timeline H.264 presentation with an adaptive jitter budget and stale-frame recovery after transport stalls.
- Stream telemetry for arrival rate, bitrate, frame gaps, presentation delay, and UI enqueue time.
- Receiver audio for navigation, calls, radio, Apple Music, and third-party media apps.
- A named vehicle app with the Showcase icon and a clean CarPlay sidebar.
- Three-finger pause controls that dim the video and block CarPlay input while open.
- Persistent controller pairing, CarPlay screen-resource handoff, and fresh-keyframe recovery after backgrounding.
- A Bluetooth compatibility report when BTstack cannot control the receiver hardware.

Showcase embeds Monocypher and LibTomMath for CarPlay cryptography. Users no longer need an OpenSSL package or repository.

## Source Layout

```text
source/       app, Bluetooth helper, AirPlay helper, pairing code
btstack-rootless/
              patched BTstack v1.1 iOS daemon source used by the rootless package
packaging/    Debian control files, depictions, package scripts
icon/         app icons
```

## Build From Source

Showcase builds on the jailbroken receiver. The build script expects SSH access through a local forwarded port and pins the deployment target to iOS 12.0.

```sh
iproxy 2222 <ipad-sshd-port>
IPAD_PORT=2222 IPAD_PASS=alpine ./build_and_install.sh
```

For a jailbreak SSH daemon on port 22, run this command.

```sh
iproxy 2222 22
```

The script compiles the three binaries on-device, signs them with `ldid`, installs the rootful app under `/Applications`, and refreshes SpringBoard. Use the package scripts below for rootless builds.

## Build The Deb

Build and test the app on the iPad first.

```sh
cd packaging
./scripts/fetch-installed-app.sh
./scripts/build-rootful-deb.sh
./scripts/build-rootless-deb.sh
./scripts/generate-apt-repo.py repo
```

The `.deb` files land in `packaging/build/`. The APT repository lands in `packaging/repo/`.

For GitHub Releases, upload both `.deb` files from `packaging/build/` after you rebuild the packages. The rootful asset ends in `iphoneos-arm.deb`; the rootless asset ends in `iphoneos-arm64.deb`.

For Sileo, Cydia, and Zebra, publish the generated `packaging/repo/` contents to the web path that serves `https://aminerostane.com/repo`.

## Logs

```text
/var/mobile/Library/Showcase/logs/app.log
/var/mobile/Library/Showcase/logs/baa_broker.log
/var/mobile/Library/Showcase/logs/btdaemon.log
/var/mobile/Library/Showcase/logs/carplay_bt.log
/var/mobile/Library/Showcase/logs/carplay_services.log
```

Check logs before posting them in public issues. Logs can include device names, hotspot names, network details, and pairing traces.

## BTstack Rootless Source

The rootless package bundles a patched BTstack daemon. Its source lives in `btstack-rootless/`.

The patch set fixes classic BR/EDR authentication state, incoming RFCOMM cid registration, RFCOMM data routing, and classic-only daemon builds on Procursus SDKs. See `btstack-rootless/README.rootless.md` for the build command.

## License

GPL-3.0-or-later. The pairing code includes work adapted from UxPlay and csrp. Binary packages bundle BTstack runtime files from the historical `ch.ringwald.btstack` jailbreak package by Matthias Ringwald.
