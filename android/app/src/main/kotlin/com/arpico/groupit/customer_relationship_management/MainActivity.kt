package com.arpico.groupit.arpicoprivilege

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity()

//import android.provider.Settings
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "com.arpico.groupit.arpicoprivilege.deviceinfo/device"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
//            when (call.method) {
//                "getDeviceId" -> {
//                    val androidId = Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
//                    result.success(androidId)
//                }
//                else -> result.notImplemented()
//            }
//        }
//    }
//}