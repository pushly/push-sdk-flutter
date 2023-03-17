package com.pushly.pushsdk.delegates

import android.content.Context
import com.pushly.android.PushSDK
import com.pushly.android.PushSDK.Companion.logLevel
import com.pushly.android.enums.PNLogLevel
import com.pushly.pushsdk.FlutterResponder
import com.pushly.pushsdk.PNLogs
import com.pushly.pushsdk.PushsdkPlugin.Companion.pushSdkConfigured
import com.pushly.pushsdk.callbacks.*
import io.flutter.Log.setLogLevel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method

class PushSDKDelegate(
    private val context: Context,
    public val channel: MethodChannel,
    private val binaryMessenger: BinaryMessenger,
): FlutterResponder(), MethodChannel.MethodCallHandler {

    companion object {
        fun create(context: Context, binaryMessenger: BinaryMessenger): PushSDKDelegate {
            return PushSDKDelegate(context, MethodChannel(binaryMessenger, "PushSDK"), binaryMessenger)
        }
    }

    init {
        initialize(context, channel, binaryMessenger)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        PNLogs.debug("Received method call: ${call.method} with args: ${call.arguments}")
        when (call.method) {
            "setLogLevel" -> {
                val logLevel = PNLogLevel.valueOf(call.argument<String>("level")!!.uppercase())
                PNLogs.logLevel = logLevel
                PushSDK.logLevel = logLevel
                success(result)
            }
            "registerPushSDKLifecycleCallbacks" -> {
                PushSDK.registerPushSDKLifecycleCallbacks(PnPushSDKLifecycleCallbacksImpl(context, channel, binaryMessenger))
                success(result)
            }
            "registerNotificationLifecycleCallbacks" -> {
                PushSDK.registerNotificationLifecycleCallbacks(PnNotificationLifecycleCallbacksImpl(context, channel, binaryMessenger))
                success(result)
            }
            "registerPermissionLifecycleCallbacks" -> {
                PushSDK.registerPermissionLifecycleCallbacks(PnPermissionLifecycleCallbacksImpl(context, channel, binaryMessenger))
                success(result)
            }
            "setConfiguration" -> {
                PNLogs.verbose("SDK initialization $pushSdkConfigured")
                if (!pushSdkConfigured) {
                    PNLogs.verbose("Configuring Flutter PushSDK")
                    PushSDK.setConfiguration(call.argument<String>("appKey")!!, context)
                    pushSdkConfigured = true
                } else {
                    PNLogs.warn("Flutter PushSDK already initialized. Please ensure setConfiguration is only called once.")
                }
                success(result)
            }
            "showNativeNotificationPermissionPrompt" -> {
                PushSDK.showNativeNotificationPermissionPrompt(
                    completion = {granted, permission, error ->
                        invokeOnMainThread(
                            "showNativeNotificationPermissionPromptCallback",
                            mapOf(
                                "granted" to granted,
                                "status" to permission?.name,
                                "error" to error?.stackTraceToString()
                            )
                        )
                    },
                    skipConditionsEvaluation = call.argument<Boolean?>("skipConditionsEvaluation") ?: false,
                    skipFrequencyCapEvaluation = call.argument<Boolean?>("skipFrequencyCapEvaluation") ?: false,
                )
                success(result)
            }
            else -> notImplemented(result)
        }
    }
}
