package com.pushly.pushsdk.callbacks

import android.content.Context
import com.pushly.android.PNNotificationOpenedProcessor
import com.pushly.android.PushSDK
import com.pushly.android.callbacks.PNNotificationLifecycleCallbacks
import com.pushly.android.models.PNNotification
import com.pushly.android.models.PNNotificationInteraction
import com.pushly.pushsdk.FlutterResponder
import com.pushly.pushsdk.PNLogs
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class PnNotificationLifecycleCallbacksImpl(
    context: Context,
    methodChannel: MethodChannel,
    binaryMessenger: BinaryMessenger,
) : FlutterResponder(), PNNotificationLifecycleCallbacks {

    init {
        initialize(context, methodChannel, binaryMessenger)
    }

    override fun onPushSDKDidReceiveNotificationDestination(destination: String, interaction: PNNotificationInteraction): Boolean {
        invokeOnMainThread(
            "PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotificationDestination",
            mapOf(
                "destination" to destination,
                "interaction" to interaction.toSimpleObject(),
            ),
            callback = object: MethodChannel.Result {
                override fun success(result: Any?) {
                    if (!(result as Boolean)) {
                        PNNotificationOpenedProcessor.processInteractionDestination(interaction)
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    PNLogs.verbose("$errorCode $errorMessage")
                }

                override fun notImplemented() {

                }
            }
        )
        return true
    }

    override fun onPushSDKDidReceiveRemoteNotification(notification: PNNotification) {
        PNLogs.verbose("Flutter Android SDK received notification ${notification.id}" )
        invokeOnMainThread(
            "PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotification",
            notification.toSimpleObject()
        )
    }
}
