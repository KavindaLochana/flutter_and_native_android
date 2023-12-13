package com.example.test_native_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channel = "main_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler{
            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "dataFlow") {
                val message = sendMessage()

                if (message.isNotEmpty()) {
                    result.success(message)
                } else {
                    result.error("UNAVAILABLE", "Message from Kotlin side is empty", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }



    private fun sendMessage(): String {
        return "Hello I am Kotlin"
    }

}
