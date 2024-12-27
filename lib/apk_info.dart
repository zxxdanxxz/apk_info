import 'dart:io';
import 'package:flutter/services.dart';

class ApkInfo {
  ApkInfo({
    required this.file,
    required this.uuid,
    this.applicationId,
    this.applicationLabel,
    this.versionCode,
    this.versionName,
    this.platformBuildVersionCode,
    this.compileSdkVersion,
    this.minSdkVersion,
    this.targetSdkVersion,
  });

  final File file;

  final String uuid;
  final String? applicationId;
  final String? applicationLabel;
  final String? versionCode;
  final String? versionName;
  final String? platformBuildVersionCode;
  final String? compileSdkVersion;
  final String? minSdkVersion;
  final String? targetSdkVersion;

  static const MethodChannel _channel = MethodChannel('io.flutter.plugins.apk_info');

  /// `path` - path to apk
  static Future<ApkInfo> about(String path) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getApkInfo', path);
      if (result.containsKey("error")) {
        throw Exception(result["error"]);
      }
      return ApkInfo(
        file: File(path),
        uuid: result["uuid"] as String,
        applicationId: result["applicationId"] as String?,
        applicationLabel: result["applicationLabel"] as String?,
        versionCode: result["versionCode"] as String?,
        versionName: result["versionName"] as String?,
        platformBuildVersionCode: result["platformBuildVersionCode"] as String?,
        compileSdkVersion: result["compileSdkVersion"] as String?,
        minSdkVersion: result["minSdkVersion"] as String?,
        targetSdkVersion: result["targetSdkVersion"] as String?,
      );
    } on PlatformException catch (e) {
      throw Exception("Failed to get APK info: ${e.message}");
    }
  }
}
