package com.pushly.pushsdk.delegates

import android.content.Context
import com.pushly.android.PushSDK
import com.pushly.pushsdk.FlutterResponder
import com.pushly.pushsdk.PNLogs
import com.pushly.pushsdk.mappers.PNECommMap
import com.pushly.pushsdk.mappers.toModel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ECommDelegate(
    private val context: Context,
    internal val channel: MethodChannel,
    private val binaryMessenger: BinaryMessenger,
) : FlutterResponder(), MethodChannel.MethodCallHandler {

    companion object {
        fun create(context: Context, binaryMessenger: BinaryMessenger): ECommDelegate {
            return ECommDelegate(context, MethodChannel(binaryMessenger, "PushSDK#EComm"), binaryMessenger)
        }
    }

    init {
        initialize(context, channel, binaryMessenger)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        PNLogs.debug("Android Flutter bridge received call: ${call.method} with args: ${call.arguments}")
        when (call.method) {
            "addToCart" -> {
                val items: List<String> = call.argument("items")!!
                PushSDK.EComm.addToCart(items.map { it.toModel() })
                success(result)
            }
            "updateCart" -> {
                val items: List<PNECommMap> = call.argument("items")!!
                PushSDK.EComm.updateCart(items.map { it.toModel() })
                success(result)
            }
            "clearCart" -> {
                PushSDK.EComm.clearCart()
                success(result)
            }
            "trackPurchase" -> {
                PushSDK.EComm.trackPurchase()
                success(result)
            }
            "trackPurchaseForId" -> {
                val items = call.argument<List<PNECommMap>>("items")?.map { it.toModel() } ?: emptyList()
//
//                PushSDK.EComm.trackPurchase(
//                    items = items,
//                    purchaseId = call.argument("purchaseId"),
//                    priceValue = call.argument("priceValue"),
//                )
                success(result)
            }
            else -> {
                notImplemented(result)
                return
            }
        }

    }
}