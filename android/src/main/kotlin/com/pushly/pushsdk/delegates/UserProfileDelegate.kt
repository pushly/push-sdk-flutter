package com.pushly.pushsdk.delegates

import android.content.Context
import com.pushly.android.PushSDK
import com.pushly.pushsdk.FlutterResponder
import com.pushly.pushsdk.PNLogs
import com.pushly.pushsdk.mappers.toMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UserProfileDelegate(
    private val context: Context,
    internal val channel: MethodChannel,
    private val binaryMessenger: BinaryMessenger,
) : FlutterResponder(), MethodChannel.MethodCallHandler {

    companion object {
        fun create(context: Context, binaryMessenger: BinaryMessenger): UserProfileDelegate {
            return UserProfileDelegate(context, MethodChannel(binaryMessenger, "PushSDK#UserProfile"), binaryMessenger)
        }
    }

    init {
        initialize(context, channel, binaryMessenger)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        PNLogs.debug("Android Flutter bridge received call: ${call.method} with args: ${call.arguments}")
        when (call.method) {
            "get" -> {
                val profile = PushSDK.UserProfile.toMap()
                PNLogs.debug("Sending UserProfile#get with value: $profile")
                success(result, profile)
            }
            "setExternalId" -> {
                PushSDK.UserProfile.externalId = call.argument("externalId")
                success(result)
            }
            "append" -> {
                PushSDK.UserProfile.append(key = call.argument<String>("key")!!, values = call.argument<List<Any>>("values")!!)
                success(result)
            }
            "set" -> {
                PushSDK.UserProfile.set(key = call.argument<String>("key")!!, value = call.argument<Any>("value")!!)
                success(result)
            }
            "setData" -> {
                PushSDK.UserProfile.set(call.argument<HashMap<String, Any>>("data")!!)
                success(result)
            }
            "remove" -> {
                PushSDK.UserProfile.remove(key = call.argument<String>("key")!!, values = call.argument<List<Any>>("values")!!)
                success(result)
            }
            "trackActivity" -> {
                PushSDK.UserProfile.trackActivity(
                    name = call.argument<String>("name")!!,
                    tags = call.argument<List<String>>("tags")!!)
                success(result)
            }
            "requestUserDeletion" -> {
                PushSDK.UserProfile.requestUserDeletion()
                success(result)
            }
            else -> {
                notImplemented(result)
                return
            }
        }

    }
}