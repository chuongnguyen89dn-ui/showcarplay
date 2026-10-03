# Packaging

Build the app on the iPad, test it, then package the installed bundle.

```sh
./scripts/fetch-installed-app.sh
./scripts/build-rootful-deb.sh
./scripts/build-rootless-deb.sh
./scripts/generate-apt-repo.py repo
```

The rootful package installs `/Applications/Showcase.app` and bundles the BTstack runtime files required by the receiver.

```text
/usr/bin/BTdaemon
/usr/lib/libBTstack.dylib
/Library/LaunchDaemons/ch.ringwald.BTstack.plist
```

The rootless package installs the same app and runtime files under `/var/jb`.

```text
/var/jb/Applications/Showcase.app
/var/jb/usr/bin/BTdaemon
/var/jb/usr/lib/libBTstack.dylib
/var/jb/Library/LaunchDaemons/ch.ringwald.BTstack.plist
```

If `payload-rootless/usr/bin/BTdaemon` exists, the rootless build uses that
arm64 daemon instead of thinning the historical rootful BTdaemon. Each package
keeps the Bluetooth transport that matches its filesystem layout.

The rootful package depends on `uikittools`. The rootless package depends on `uikittools` and `ldid`. Showcase can use `tcpdump` for opt-in diagnostics when the user installs it. Both packages embed their CarPlay cryptography and have no OpenSSL dependency.

Rootful packages use `iphoneos-arm`; rootless packages use `iphoneos-arm64`. Both set iOS 12.0 as the deployment target.

Do not commit `payload/`, `build/`, or `repo/` to the source branch. Publish the generated `repo/` directory to the web path that serves `https://aminerostane.com/repo`.
