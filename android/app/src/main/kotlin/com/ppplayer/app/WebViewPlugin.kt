package com.ppplayer.app

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

class WebViewPlugin : FlutterPlugin, MethodCallHandler {

    companion object {
        private const val CHANNEL = "com.ppplayer.app/headless_webview"
        private var methodChannel: MethodChannel? = null
        private val mainHandler = Handler(Looper.getMainLooper())
        
        fun sendReadyEvent() {
            mainHandler.post {
                methodChannel?.invokeMethod("onReady", null)
            }
        }
        
        fun sendStateChange(state: Int) {
            mainHandler.post {
                methodChannel?.invokeMethod("onStateChange", state)
            }
        }
        
        fun sendError(error: Int) {
            mainHandler.post {
                methodChannel?.invokeMethod("onError", error)
            }
        }
        
        fun sendPosition(currentTime: Double, duration: Double) {
            mainHandler.post {
                methodChannel?.invokeMethod("onPosition", mapOf(
                    "currentTime" to currentTime,
                    "duration" to duration
                ))
            }
        }
    }

    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startService" -> {
                val intent = Intent(context, CustomWebViewService::class.java)
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    context?.startForegroundService(intent)
                } else {
                    context?.startService(intent)
                }
                result.success(null)
            }
            "stopService" -> {
                val intent = Intent(context, CustomWebViewService::class.java).apply {
                    action = CustomWebViewService.ACTION_STOP_SERVICE
                }
                context?.startService(intent)
                result.success(null)
            }
            "prepareVideo" -> {
                val args = call.arguments as Map<*, *>
                val videoId = args["videoId"] as String
                val startSeconds = args["startSeconds"] as Double
                val commandId = (args["commandId"] as? Int) ?: 0
                CustomWebViewService.instance?.prepareVideo(videoId, startSeconds, commandId)
                result.success(null)
            }
            "loadVideo" -> {
                val videoId = call.argument<String>("videoId") ?: return result.error("INVALID", "Missing videoId", null)
                val startSeconds = call.argument<Double>("startSeconds") ?: 0.0
                val commandId = call.argument<Int>("commandId") ?: 0
                CustomWebViewService.instance?.loadVideo(videoId, startSeconds, commandId)
                result.success(null)
            }
            "playVideo" -> {
                CustomWebViewService.instance?.playVideo()
                result.success(null)
            }
            "pauseVideo" -> {
                CustomWebViewService.instance?.pauseVideo()
                result.success(null)
            }
            "seekTo" -> {
                val seconds = call.argument<Double>("seconds") ?: 0.0
                CustomWebViewService.instance?.seekTo(seconds)
                result.success(null)
            }
            "setVolume" -> {
                val volume = call.argument<Int>("volume") ?: 100
                CustomWebViewService.instance?.setVolume(volume)
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        context = null
    }
}
