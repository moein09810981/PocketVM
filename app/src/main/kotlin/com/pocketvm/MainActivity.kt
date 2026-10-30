package com.pocketvm
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
class MainActivity : FlutterActivity() {
 override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
  super.configureFlutterEngine(flutterEngine)
  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.pocketvm/native").setMethodCallHandler { call, result ->
   when (call.method) {
    "deviceInfo" -> result.success(mapOf("manufacturer" to Build.MANUFACTURER, "model" to Build.MODEL, "androidVersion" to Build.VERSION.RELEASE, "sdk" to Build.VERSION.SDK_INT))
    else -> result.notImplemented()
   }
  }
 }
}