package com.pushly.pushsdk.callbacks

import android.content.Context
import com.pushly.android.callbacks.PNPermissionLifecycleCallbacks
import com.pushly.android.enums.PNPermissionResponse
import com.pushly.pushsdk.FlutterResponder
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class PnPermissionLifecycleCallbacksImpl(
    context: Context,
    private val methodChannel: MethodChannel,
    binaryMessenger: BinaryMessenger,
) : PNPermissionLifecycleCallbacks, FlutterResponder() {

    init {
        initialize(context, methodChannel, binaryMessenger)
    }

    override fun onPushSDKDidFailToRegisterForRemoteNotificationsWithError(error: Throwable) {
        invokeOnMainThread(
            "PNPermissionLifecycleCallbacks.onPushSDKDidFailToRegisterForRemoteNotificationsWithError",
            mapOf("error" to error.stackTraceToString())
        )
    }

    override fun onPushSDKDidReceivePermissionResponse(response: PNPermissionResponse) {
        invokeOnMainThread(
            "PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionResponse",
            mapOf("response" to response.name)
        )
    }

    override fun onPushSDKDidReceivePermissionStatusChange(permissions: PNPermissionResponse) {
        invokeOnMainThread(
            "PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionStatusChange",
            mapOf("response" to permissions.name)
        )
    }

    override fun onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken: String) {
        invokeOnMainThread(
            "PNPermissionLifecycleCallbacks.onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken",
            mapOf("deviceToken" to deviceToken)
        )
    }
}