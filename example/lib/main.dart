import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:apk_info/apk_info.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  while (await Permission.manageExternalStorage.request().isDenied) {}

  final info = await DeviceInfoPlugin().androidInfo;
  while (info.version.sdkInt < 33 && await Permission.storage.request().isDenied) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('APK Info Example')),
        body: Center(
          child: FutureBuilder<ApkInfo>(
            future: ApkInfo.about('/storage/emulated/0/Download/apk_info_test.apk'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final apkInfo = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('UUID: ${apkInfo.uuid}'),
                    Text('Application ID: ${apkInfo.applicationId}'),
                    Text('App Label: ${apkInfo.applicationLabel}'),
                    Text('Version Code: ${apkInfo.versionCode}'),
                    Text('Version Name: ${apkInfo.versionName}'),
                    Text('Platform Build Version Code: ${apkInfo.platformBuildVersionCode}'),
                    Text('Compile SDK: ${apkInfo.compileSdkVersion}'),
                    Text('Min SDK: ${apkInfo.minSdkVersion}'),
                    Text('Target SDK: ${apkInfo.targetSdkVersion}'),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
