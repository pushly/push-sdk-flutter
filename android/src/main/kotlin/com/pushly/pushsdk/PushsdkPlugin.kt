package com.pushly.pushsdk

import androidx.annotation.NonNull
import com.pushly.android.PNLogger
import com.pushly.android.PushSDK
import com.pushly.android.models.PNEventSourceApplication
import com.pushly.pushsdk.delegates.ECommDelegate

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import com.pushly.pushsdk.delegates.PushSDKDelegate
import com.pushly.pushsdk.delegates.UserProfileDelegate

internal val PNLogs = PNLogger(name = "PushSDK KTBridge")
class PushsdkPlugin : FlutterPlugin {

    companion object {
        var pushSdkConfigured: Boolean = false
    }

    private var channels: MutableList<MethodChannel> = mutableListOf()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        PushSDK.setEventSourceApplication(PNEventSourceApplication(
            name = "pushly-sdk-flutter",
            version = BuildConfig.SDK_VERSION_CODE
        ))
        channels.addAll(
            listOf(
                PushSDKDelegate.create(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger).channel,
                UserProfileDelegate.create(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger).channel,
                ECommDelegate.create(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger).channel,
            )
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channels.forEach { it.setMethodCallHandler(null) }
    }
}
