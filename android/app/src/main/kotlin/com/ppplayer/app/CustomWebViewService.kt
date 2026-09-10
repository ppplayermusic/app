package com.ppplayer.app

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.core.app.NotificationCompat
import android.util.Log
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.app.Presentation
import android.os.Bundle
import android.view.WindowManager
import android.graphics.PixelFormat

class CustomWebViewService : Service() {

    companion object {
        private const val TAG = "CustomWebViewService"
        private const val CHANNEL_ID = "WebViewServiceChannel"
        const val ACTION_START_SERVICE = "START_WEBVIEW_SERVICE"
        const val ACTION_STOP_SERVICE = "STOP_WEBVIEW_SERVICE"

        var instance: CustomWebViewService? = null
    }

    private var webView: WebView? = null
    private var webViewClient: CustomWebViewClient? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var presentation: Presentation? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
        createNotificationChannel()
        startForeground(999, createNotification())
        initWebView()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_SERVICE) {
            stopForeground(true)
            stopSelf()
            return START_NOT_STICKY
        }
        return START_NOT_STICKY
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun initWebView() {
        try {
            val displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
            virtualDisplay = displayManager.createVirtualDisplay(
                "WebViewDisplay",
                1920, 1080, 160,
                null,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_PRESENTATION
            )
            
            presentation = object : Presentation(this, virtualDisplay!!.display) {
                override fun onCreate(savedInstanceState: Bundle?) {
                    super.onCreate(savedInstanceState)
                    window?.setType(
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                        else WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
                    ) // Presentation windows don't strictly require SYSTEM_ALERT_WINDOW if they are on a private virtual display!
                    // Actually, setting type might crash if we don't have permission. Let's rely on Presentation's default window type!
                }
            }
            
            // Re-create without custom window type to avoid permission crashes
            presentation = object : Presentation(this, virtualDisplay!!.display) {
                override fun onCreate(savedInstanceState: Bundle?) {
                    super.onCreate(savedInstanceState)
                    webView = WebView(context)
                    setContentView(webView!!)
                    setupWebView(webView!!)
                }
            }
            presentation?.show()
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing WebView", e)
        }
    }
    
    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView(wv: WebView) {
        try {
            wv.settings.apply {
                javaScriptEnabled = true
                    mediaPlaybackRequiresUserGesture = false
                    domStorageEnabled = true
                    cacheMode = WebSettings.LOAD_NO_CACHE
                }
                
                // No need to manually measure/layout as it's attached to the Presentation window!
                
                wv.resumeTimers()
                wv.onResume()

                wv.webChromeClient = WebChromeClient()
                webViewClient = CustomWebViewClient()
                wv.webViewClient = webViewClient!!

                wv.addJavascriptInterface(WebViewInterface(), "NativeLog")

                val html = """
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style>body, html { width: 100%; height: 100%; margin: 0; padding: 0; background-color: #000; }</style>
                    </head>
                    <body>
                        <div id="player"></div>
                        <script>
                            // Spoof visibility
                            Object.defineProperty(document, 'hidden', { get: () => false });
                            Object.defineProperty(document, 'visibilityState', { get: () => 'visible' });

                            var tag = document.createElement('script');
                            tag.src = "https://www.youtube.com/iframe_api";
                            var firstScriptTag = document.getElementsByTagName('script')[0];
                            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

                            var player;
                            function onYouTubeIframeAPIReady() {
                                NativeLog.log("IFrame API Ready");
                                player = new YT.Player('player', {
                                    height: '100%',
                                    width: '100%',
                                    videoId: '',
                                    playerVars: {
                                        'playsinline': 1,
                                        'controls': 0,
                                        'disablekb': 1,
                                        'fs': 0,
                                        'rel': 0,
                                        'modestbranding': 1,
                                        'autoplay': 1,
                                        'origin': 'https://ppplayer.com'
                                    },
                                    events: {
                                        'onReady': onPlayerReady,
                                        'onStateChange': onPlayerStateChange,
                                        'onError': onPlayerError
                                    }
                                });
                            }

                            function onPlayerReady(event) {
                                NativeLog.onReady();
                            }

                            function onPlayerStateChange(event) {
                                NativeLog.onStateChange(event.data);
                            }

                            function onPlayerError(event) {
                                NativeLog.onError(event.data);
                            }

                            function loadVideo(videoId, startSeconds) {
                                if (player && player.loadVideoById) {
                                    player.loadVideoById({videoId: videoId, startSeconds: startSeconds});
                                }
                            }

                            function cueVideo(videoId, startSeconds) {
                                if (player && player.cueVideoById) {
                                    player.cueVideoById({videoId: videoId, startSeconds: startSeconds});
                                }
                            }

                            function playVideo() {
                                if (player && player.playVideo) player.playVideo();
                            }

                            function pauseVideo() {
                                if (player && player.pauseVideo) player.pauseVideo();
                            }

                            function seekTo(seconds) {
                                if (player && player.seekTo) player.seekTo(seconds, true);
                            }

                            function setVolume(volume) {
                                if (player && player.setVolume) player.setVolume(volume);
                            }
                            
                            function getPosition() {
                                if (player && player.getCurrentTime) {
                                    NativeLog.onPosition(player.getCurrentTime(), player.getDuration());
                                }
                            }
                            
                            setInterval(getPosition, 500);
                        </script>
                    </body>
                    </html>
                """.trimIndent()

                wv.loadDataWithBaseURL("https://ppplayer.com", html, "text/html", "utf-8", null)
                Log.d(TAG, "WebView initialized in VirtualDisplay")
        } catch (e: Exception) {
            Log.e(TAG, "Error setting up WebView", e)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
        try {
            webView?.apply {
                removeJavascriptInterface("NativeLog")
                loadUrl("about:blank")
                stopLoading()
                clearHistory()
                removeAllViews()
                destroy()
            }
            webView = null
            presentation?.dismiss()
            presentation = null
            virtualDisplay?.release()
            virtualDisplay = null
        } catch (e: Exception) {
            Log.e(TAG, "Error destroying WebView", e)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "WebView Service Channel",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("PPPlayer Headless Engine")
            .setContentText("Running YouTube engine in background")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
    
    // Commands to send JS
    fun loadVideo(videoId: String, startSeconds: Double = 0.0) {
        runJs("loadVideo('$videoId', $startSeconds)")
    }

    fun prepareVideo(videoId: String, startSeconds: Double = 0.0) {
        runJs("cueVideo('$videoId', $startSeconds)")
    }
    
    fun playVideo() {
        runJs("playVideo()")
    }
    
    fun pauseVideo() {
        runJs("pauseVideo()")
    }
    
    fun seekTo(seconds: Double) {
        runJs("seekTo($seconds)")
    }
    
    fun setVolume(volume: Int) {
        runJs("setVolume($volume)")
    }

    private fun runJs(js: String) {
        // Must run on main thread
        webView?.post {
            webView?.evaluateJavascript(js, null)
        }
    }

    inner class WebViewInterface {
        @JavascriptInterface
        fun log(message: String) {
            Log.d(TAG, "JS Log: \$message")
        }

        @JavascriptInterface
        fun onReady() {
            WebViewPlugin.sendReadyEvent()
        }

        @JavascriptInterface
        fun onStateChange(state: Int) {
            Log.d(TAG, "JS onStateChange: $state")
            WebViewPlugin.sendStateChange(state)
        }

        @JavascriptInterface
        fun onError(error: Int) {
            WebViewPlugin.sendError(error)
        }
        
        @JavascriptInterface
        fun onPosition(currentTime: Double, duration: Double) {
            WebViewPlugin.sendPosition(currentTime, duration)
        }
    }

    private inner class CustomWebViewClient : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
            return true // Prevent navigation
        }
    }
}
