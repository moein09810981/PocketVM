# PocketVM

Android virtual-machine manager prototype.

- **Flutter/Dart:** interface and local VM configuration.
- **Kotlin:** Android host and native device-information channel.
- **Planned:** QEMU integration in C/C++.

**Important:** current APK is a UI prototype. It does not yet boot guest operating systems or download ISO images.

## Build
```sh
flutter pub get
flutter analyze
flutter build apk --debug
```
APK: `build/app/outputs/flutter-apk/app-debug.apk`.
