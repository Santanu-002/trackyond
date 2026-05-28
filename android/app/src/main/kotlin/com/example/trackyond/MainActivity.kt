package com.example.trackyond

import android.media.MediaScannerConnection
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val deviceIdChannel = "device_id_channel"
    private val mediaScannerChannel = "media_scanner_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Device ID Channel — provides Android ID to Flutter via DeviceIdService
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, deviceIdChannel)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "getAndroidId") {
                    val androidId = Settings.Secure.getString(
                        contentResolver,
                        Settings.Secure.ANDROID_ID
                    )
                    result.success(androidId)
                } else {
                    result.notImplemented()
                }
            }

        // Media Scanner Channel — triggers Android media scanner to expose saved photos to the gallery
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mediaScannerChannel)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "scanFile") {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            this,
                            arrayOf(path),
                            null
                        ) { _, _ -> }
                        result.success(true)
                    } else {
                        result.error("INVALID_PATH", "Path was null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
