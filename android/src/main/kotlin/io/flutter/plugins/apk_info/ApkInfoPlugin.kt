package io.flutter.plugins.apk_info

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ApkInfoPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "io.flutter.plugins.apk_info")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) { "getApkInfo" -> {
                val path = call.arguments<String>()
                val apkInfo = getApkInfo(path)
                result.success(apkInfo)
            }
            else -> result.notImplemented()
        }
    }

    private fun getApkInfo(path: String?): Map<String, Any?> {
        return try {
            val pm = context.packageManager
            val packageInfo: PackageInfo? = pm.getPackageArchiveInfo(path!!, PackageManager.GET_META_DATA)
            if (packageInfo != null) {
              val info = packageInfo.applicationInfo!!

              mapOf(
                  "uuid" to path!!.hashCode().toString(),
                  "applicationId" to packageInfo.packageName,
                  "applicationLabel" to pm.getApplicationLabel(info).toString(),
                  "versionCode" to packageInfo.versionCode.toString(),
                  "versionName" to packageInfo.versionName,
                  "platformBuildVersionCode" to info.targetSdkVersion.toString(),
                  "compileSdkVersion" to info.targetSdkVersion.toString(),
                  "minSdkVersion" to info.minSdkVersion.toString(),
                  "targetSdkVersion" to info.targetSdkVersion.toString()
              )
            } else {
              mapOf("error" to "Failed to read APK info")
            }
        } catch (e: Exception) {
          mapOf("error" to e.toString())
        }
    }
}