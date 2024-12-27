# apk_info

Flutter package to get information about the apk file in the device's internal memory.

## Getting Started

1. Make sure that your application allows you to read information about the file located in the device's internal storage.

2. Get the information about the apk file:
```dart
final apkInfo = await ApkInfo.about('$pathToApkFile');
```

