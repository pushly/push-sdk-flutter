package com.pushly.pushsdk.callbacks

import android.content.Context
import com.pushly.android.callbacks.PNPushSDKLifecycleCallbacks
import com.pushly.android.enums.PNSubscriberStatus
import com.pushly.android.models.PNApplicationConfig
import com.pushly.pushsdk.FlutterResponder
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class PnPushSDKLifecycleCallbacksImpl(
    context: Context,
    private val methodChannel: MethodChannel,
    binaryMessenger: BinaryMessenger,
) : PNPushSDKLifecycleCallbacks, FlutterResponder() {

    init {
        initialize(context, methodChannel, binaryMessenger)
    }

    override fun onPushSDKDidExitWithSubscriberStatus(status: PNSubscriberStatus, deleted: Boolean) {
        invokeOnMainThread(
            "PNPushSDKLifecycleCallbacks.onPushSDKDidExitWithSubscriberStatus",
            mapOf(
                "subscriberStatus" to status.name,
                "deleted" to deleted,
            )
        )
    }

    override fun onPushSDKDidFinishLoading(configuration: PNApplicationConfig, subscriberStatus: PNSubscriberStatus) {
        invokeOnMainThread(
            methodName = "PNPushSDKLifecycleCallbacks.onPushSDKDidFinishLoading",
            map = mutableMapOf(
                "subscriberStatus" to subscriberStatus.name,
            ).plus(configuration.toSimpleObject()),
        )
    }
}