# Glacier

Android virtual-machine manager prototype (formerly PocketVM / Verchino).

- **Flutter/Dart:** interface and local VM configuration (mountain-blue theme).
- **Kotlin:** Android host and native device-information channel.
- **Planned:** QEMU integration in C/C++ (ARM64 phones).

**Important:** the current APK is a UI prototype. It does not yet boot guest
operating systems or download ISO images. The boot/console screens and the
download queue are visual placeholders until phases 4-5.

## Layout
```
lib/
  main.dart        entry + splash
  shell.dart       bottom navigation
  theme.dart       colors (G), theme, app name
  models.dart      distro catalog, machines, downloads, AppState
  widgets.dart     shared widgets and painters
  actions.dart     launch / delete / menu helpers
  screens/         home, machines, create, details, os_picker,
                   downloads, settings, boot, console
```

## Build
```sh
flutter pub get
flutter analyze
flutter build apk --debug
```
APK: `build/app/outputs/flutter-apk/app-debug.apk`.
