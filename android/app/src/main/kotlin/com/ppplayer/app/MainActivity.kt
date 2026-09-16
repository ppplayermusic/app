package com.ppplayer.app

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import android.content.pm.PackageManager
import android.util.Log
import androidx.lifecycle.Lifecycle
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.ppplayer.app/pip"
    private var isPipEnabled = false
    private var methodChannel: MethodChannel? = null

    private fun logNative(event: String) {
        val pip = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) isInPictureInPictureMode else false
        val focus = hasWindowFocus()
        val sizeStr = if (window != null && window.decorView != null) {
            "${window.decorView.width}x${window.decorView.height}"
        } else "unknown"
        val time = java.text.SimpleDateFormat("HH:mm:ss.SSS", java.util.Locale.US).format(java.util.Date())
        Log.d("PipDebug", "$time [NATIVE] event=$event pip=$pip focus=$focus size=$sizeStr isFinishing=$isFinishing")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(WebViewPlugin())
        flutterEngine.plugins.add(LocalFilesPlugin())
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "setPipEnabled" -> {
                    isPipEnabled = call.argument<Boolean>("enabled") ?: false
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        if (!isFinishing && !isDestroyed) {
                            try {
                                if (isPipEnabled && packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)) {
                                    val params = PictureInPictureParams.Builder()
                                        .setAspectRatio(Rational(16, 9))
                                        .setAutoEnterEnabled(true)
                                        .build()
                                    setPictureInPictureParams(params)
                                } else {
                                    val params = PictureInPictureParams.Builder()
                                        .setAutoEnterEnabled(false)
                                        .build()
                                    setPictureInPictureParams(params)
                                }
                            } catch (e: Exception) {
                                Log.w("PipDebug", "setPictureInPictureParams failed: $e")
                            }
                        }
                    }
                    result.success(null)
                }
                "enterPip" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        if (packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)) {
                            val params = PictureInPictureParams.Builder()
                                .setAspectRatio(Rational(16, 9))
                                .build()
                            try {
                                val entered = enterPictureInPictureMode(params)
                                result.success(entered)
                            } catch (e: Exception) {
                                Log.w("PipDebug", "enterPip failed: $e")
                                result.success(false)
                            }
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        logNative("onUserLeaveHint")

        if (isPipEnabled
            && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
            && packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        ) {
            // Notify Flutter BEFORE entering PiP (or before Android 12+ auto-enter fires)
            // so that _pipRequestPending is armed before onActivityStopped arrives.
            // This fires on all Android versions when the user presses Home.
            methodChannel?.invokeMethod("onPipEntryRequested", null)

            // Android 8–11: auto-enter is not supported; manually enter PiP here.
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(Rational(16, 9))
                    .build()
                try {
                    val entered = enterPictureInPictureMode(params)
                    Log.d("PipDebug", "enterPictureInPictureMode result=$entered")
                    if (!entered) {
                        methodChannel?.invokeMethod("onPipEntryFailed", null)
                    }
                } catch (e: Exception) {
                    Log.d("PipDebug", "enterPictureInPictureMode exception=$e")
                    methodChannel?.invokeMethod("onPipEntryFailed", null)
                }
            }
            // Android 12+: setAutoEnterEnabled(true) handles entry automatically;
            // onPipModeChanged will confirm or deny and clear _pipRequestPending.
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        logNative("onPictureInPictureModeChanged pip=$isInPictureInPictureMode activityState=${lifecycle.currentState}")
        methodChannel?.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
    }

    override fun onStart() {
        super.onStart()
        logNative("onStart")
        methodChannel?.invokeMethod("onActivityStarted", null)
    }

    override fun onStop() {
        super.onStop()
        logNative("onStop")
        methodChannel?.invokeMethod("onActivityStopped", null)
    }

    override fun onPause() {
        super.onPause()
        logNative("onPause")
    }

    override fun onResume() {
        super.onResume()
        logNative("onResume")
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        logNative("onWindowFocusChanged focus=$hasFocus")
    }
}
