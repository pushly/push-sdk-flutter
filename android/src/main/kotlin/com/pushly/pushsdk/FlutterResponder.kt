package com.pushly.pushsdk

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

abstract class FlutterResponder {

    private var context: Context? = null
    private var channel: MethodChannel? = null
    private var messenger: BinaryMessenger? = null

    fun initialize(context: Context, channel: MethodChannel, messenger: BinaryMessenger) {
        this.context = context
        this.channel = channel
        this.messenger = messenger
    }

    protected fun success(reply: MethodChannel.Result, response: Any? = null) = runOnUiThread { reply.success(response) }

    protected fun error(reply: MethodChannel.Result, tag: String, message: String, response: Any? = null) = runOnUiThread {
        reply.error(tag, message, response)
    }

    protected fun notImplemented(reply: MethodChannel.Result) = runOnUiThread { reply.notImplemented() }

    protected fun runOnUiThread(runnable: Runnable) {
        Handler(Looper.getMainLooper()).apply {
            try {
                post(runnable)
            } catch (e: Exception) {
                PNLogs.error(e.stackTraceToString())
            }
        }
    }

    fun invokeOnMainThread(methodName: String, map: Map<*, *>, callback: MethodChannel.Result? = null) {
        runOnUiThread {
            PNLogs.verbose("Sending data to dart $methodName :: channel ${channel}")
            channel?.invokeMethod(methodName, map, callback)
        }
    }
}