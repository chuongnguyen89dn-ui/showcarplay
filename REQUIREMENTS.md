# Requirements

End users who install the `.deb` need a compatible jailbroken cellular iPhone or iPad, Personal Hotspot, and the runtime packages declared by APT. They do not need a compiler, SDK, headers, signing tools, or OpenSSL.

## Runtime

| Item | Requirement |
| --- | --- |
| Device | Cellular iPhone or iPad with Personal Hotspot |
| Tested rootful device | iPad Air 1 cellular, iPad4,2, iOS 12.5.8 |
| Tested rootless device | iPhone 7, iPhone9,3, iOS 15.8.4 |
| Jailbreak | Rootful or rootless, iOS 12 or newer |
| Package manager | Sileo, Cydia, Zebra, or APT-compatible frontend |

The rootful package declares the following dependencies.

```text
firmware (>= 12.0)
uikittools
```

The rootless package declares the following dependencies.

```text
firmware (>= 12.0)
uikittools
ldid
```

Both packages bundle the BTstack runtime files they need. The rootful paths follow.

```text
/usr/bin/BTdaemon
/usr/lib/libBTstack.dylib
/Library/LaunchDaemons/ch.ringwald.BTstack.plist
```

## Build

Source builds need these tools on the iPad.

| Tool or path | Purpose |
| --- | --- |
| `/usr/bin/clang` | Objective-C and C build |
| `/usr/bin/ldid` | Entitlement signing |
| `/tmp/iPhoneOS10.3.sdk` | clang sysroot |

Showcase vendors Monocypher and LibTomMath under `source/vendor`, so builds need no OpenSSL headers or libraries.

The Mac-side helper scripts use USB SSH forwarding. `IPAD_PORT` holds the local forwarded port on the Mac.

```text
IPAD_HOST=localhost
IPAD_PORT=2222
IPAD_USER=root
IPAD_PASS=alpine
```

Forward to the SSH port your iPad uses.

```sh
iproxy 2222 <ipad-sshd-port>
```
