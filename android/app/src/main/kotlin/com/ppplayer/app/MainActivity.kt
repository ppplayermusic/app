package com.ppplayer.app

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import android.content.pm.PackageManager
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.ppplayer.app/pip"
    private var isPipEnabled = false
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(WebViewPlugin())
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "setPipEnabled") {
                isPipEnabled = call.argument<Boolean>("enabled") ?: false
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // Guard: activity may be finishing (swiped away) when this
                    // is called. setPictureInPictureParams throws an
                    // IllegalStateException if the activity has no valid task.
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
                            // Silently ignore — activity may be in a transient
                            // state where PiP params cannot be updated.
                        }
                    }
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isPipEnabled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            if (packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)) {
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(Rational(16, 9))
                    .build()
                try {
                    val success = enterPictureInPictureMode(params)
                    if (!success) {
                        methodChannel?.invokeMethod("onPipModeChanged", false)
                    }
                } catch (e: Exception) {
                    // Entry failed
                }
            }
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration?) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        methodChannel?.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
    }

    override fun onStop() {
        super.onStop()
        // If the activity stops (even during PiP, e.g. screen lock), we notify Dart to pause.
        methodChannel?.invokeMethod("onActivityStopped", null)
    }

    override fun onStart() {
        super.onStart()
        methodChannel?.invokeMethod("onActivityStarted", null)
    }
}
