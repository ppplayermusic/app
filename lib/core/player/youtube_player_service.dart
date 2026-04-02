import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'player_provider.dart';
import 'media_handler.dart';

/// Service that manages the YouTube IFrame player.
/// Uses [WebViewController] on Desktop/macOS and [mobile.YoutubePlayerController] on Mobile.
class YoutubePlayerService with WidgetsBindingObserver {
  YoutubePlayerService(this.ref) {
    if (!kIsWeb && Platform.isAndroid) {
      _initMobileController();
    } else {
      _initDesktopController();
    }

    // Resume playback after the app window is restored from minimize
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));

    // Configure Audio Session listeners for interruptions and noisy events
    _initAudioSessionListeners();

    // Listen to player state and sync with the underlying player
    ref.listen(playerProvider, (previous, next) {
      final audioHandler = ref.read(audioHandlerProvider);

      if (previous?.videoId != next.videoId) {
        if (next.videoId != null) {
          _loadVideo(next.videoId!);
        } else {
          // Explicitly clear/stop when videoId is set to null
          _pause();
          _intentionalPause = false; // still wanting to play eventually
        }
      }

      // Sync Metadata
      if (previous?.currentTrack != next.currentTrack && next.currentTrack != null) {
        final track = next.currentTrack!;
        audioHandler.updateMetadata(
          id: track.spotifyId,
          title: track.name,
          artist: track.artistName,
          album: track.albumName,
          artUri: track.albumImage,
          duration: Duration(milliseconds: track.durationMs ?? 0),
        );
      }

      // Sync Playback State
      if (previous?.isPlaying != next.isPlaying || 
          previous?.position != next.position ||
          previous?.duration != next.duration) {
        audioHandler.updatePlaybackState(
          playing: next.isPlaying,
          position: next.position,
          bufferedPosition: next.position, // We don't have precise buffering info for all providers yet
          processingState: next.isLoadingVideo ? AudioProcessingState.loading : AudioProcessingState.ready,
        );

        if (previous?.isPlaying != next.isPlaying) {
          if (next.isPlaying) {
            _resume();
          } else {
            _pause();
          }
        }
      }

      if (previous != null &&
          (next.position.inSeconds - previous.position.inSeconds).abs() > 2) {
        seekTo(next.position.inSeconds.toDouble());
      }
    });
  }

  final Ref ref;

  // Desktop specific
  WebViewController? _desktopController;
  bool _isDesktopReady = false;

  // Mobile specific
  mobile.YoutubePlayerController? _mobileController;
  bool _isMobileReady = false;

  /// True when the pause was explicitly requested by user action.
  /// When false and YouTube fires an unexpected pause (stateChange=2),
  /// the service will auto-resume to survive tab switches, minimize, etc.
  bool _intentionalPause = false;

  bool get isMobile => !kIsWeb && Platform.isAndroid;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the macOS window is restored from minimize, resume playback.
    // WKWebView needs time to fully wake up from suspension — retry at
    // multiple intervals to cover all timing windows.
    if (state == AppLifecycleState.resumed) {
      for (final delay in [300, 600, 1200, 2000]) {
        Future.delayed(Duration(milliseconds: delay), () {
          if (ref.read(playerProvider).isPlaying) {
            _resume();
          }
        });
      }
    }
  }

  void _initAudioSessionListeners() {
    AudioSession.instance.then((session) {
      // Listen for interruptions (e.g. phone call, alarm)
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              // Pause if we are currently playing
              if (ref.read(playerProvider).isPlaying) {
                ref.read(playerProvider.notifier).pause();
              }
              break;
            case AudioInterruptionType.duck:
              // Optional: lowercase volume (not implemented in ppplayer standard yet)
              break;
          }
        } else {
          // Interruption ended — resume if appropriate
          if (event.type == AudioInterruptionType.pause && 
              !_intentionalPause && 
              ref.read(playerProvider).isPlaying) {
            _resume();
          }
        }
      });

      // Handle headphones unplugged
      session.becomingNoisyEventStream.listen((_) {
        if (ref.read(playerProvider).isPlaying) {
          ref.read(playerProvider.notifier).pause();
        }
      });
    });
  }

  void _initDesktopController() {
    // Clear cookies to prevent bot detection carry-over
    WebViewCookieManager().clearCookies();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Mozilla/5.0 (iPad; CPU OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
      );

    _desktopController = controller
      ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                // Ignore the baseline HTML load and internal iframe API loads
                if (request.url == 'https://www.youtube-nocookie.com/' || 
                    request.url.contains('youtube-nocookie.com/embed') || 
                    request.url.contains('iframe_api') || 
                    request.isMainFrame == false) {
                  return NavigationDecision.navigate;
                }

                // If the user clicked the video or a YouTube link, launch externally
                if (request.url.startsWith('http')) {
                  launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
                  return NavigationDecision.prevent;
                }
                
                return NavigationDecision.navigate;
              },
            ),
          )
          ..addJavaScriptChannel(
            'PlayerEvent',
            onMessageReceived: (JavaScriptMessage message) {
              try {
                final data = jsonDecode(message.message);
                final event = data['event'];

                if (event == 'ready') {
                  _isDesktopReady = true;
                  // If it's supposed to be playing, resume now
                  if (ref.read(playerProvider).isPlaying) {
                    _resume();
                  }
                } else if (event == 'stateChange') {
                  final state = data['state'];
                  if (state == 0) {
                    // Video ended — skip to next
                    _intentionalPause = false;
                    ref.read(playerProvider.notifier).skipNext();
                  } else if (state == 2) {
                    // YouTube paused (state=2). If this wasn't triggered by
                    // a user action (tab-switch, minimize, hide thumbnail…)
                    // auto-resume so music keeps playing.
                    if (_isDesktopReady &&
                        !_intentionalPause &&
                        ref.read(playerProvider).isPlaying) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (_isDesktopReady &&
                            !_intentionalPause &&
                            ref.read(playerProvider).isPlaying) {
                          _resume();
                        }
                      });
                    }
                  }
                } else if (event == 'position') {
                  final pos = data['position'];
                  final dur = data['duration'];
                  ref.read(playerProvider.notifier).updatePosition(
                    Duration(milliseconds: (pos * 1000).toInt()),
                    (dur != null && dur > 0) ? Duration(milliseconds: (dur * 1000).toInt()) : null,
                  );
                } else if (event == 'error') {
                  debugPrint('YouTube Player Error: ${data['code']}');
                  ref.read(playerProvider.notifier).onVideoError();
                } else if (event == 'log') {
                  debugPrint('JS LOG: ${data['message']}');
                }
              } catch (e) {
                // Ignore parse errors
              }
            },
          );
  }

  void _initMobileController() {
    _mobileController = mobile.YoutubePlayerController(
      initialVideoId: '',
      flags: const mobile.YoutubePlayerFlags(
        autoPlay: true,
        hideControls: true,
        mute: false,
        isLive: false,
        disableDragSeek: true,
        useHybridComposition: true,
      ),
    )..addListener(_onMobileStateChange);
  }

  WebViewController? get desktopController => _desktopController;
  mobile.YoutubePlayerController? get mobileController => _mobileController;

  void _onMobileStateChange() {
    if (_mobileController == null) return;

    if (!_isMobileReady && _mobileController!.value.isReady) {
      _isMobileReady = true;
      final currentVideoId = ref.read(playerProvider).videoId;
      if (currentVideoId != null) {
        _loadVideo(currentVideoId);
      }
    }

    if (_mobileController!.value.playerState == mobile.PlayerState.ended) {
      ref.read(playerProvider.notifier).skipNext();
    }

    if (_mobileController!.value.playerState == mobile.PlayerState.playing) {
      ref
          .read(playerProvider.notifier)
          .updatePosition(
            _mobileController!.value.position,
            _mobileController!.value.metaData.duration,
          );
    }

    if (_mobileController!.value.hasError) {
      debugPrint('Mobile Player Error: ${_mobileController!.value.errorCode}');
      // Trigger candidate cycling or error state
      ref.read(playerProvider.notifier).onVideoError();
    }
  }

  void _loadVideo(String id) {
    // Immediately sync metadata for the OS notification bar
    final next = ref.read(playerProvider);
    if (next.currentTrack != null) {
      final track = next.currentTrack!;
      ref.read(audioHandlerProvider).updateMetadata(
        id: track.spotifyId,
        title: track.name,
        artist: track.artistName,
        album: track.albumName,
        artUri: track.albumImage,
        duration: Duration(milliseconds: track.durationMs ?? 0),
      );
    }

    if (isMobile) {
      if (_mobileController != null) {
        _mobileController!.load(id);
      }
    } else {
      _isDesktopReady = false;
      final html = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body, html { 
            margin: 0; 
            padding: 0; 
            width: 100%; 
            height: 100%; 
            overflow: hidden; 
            background: black; 
        }
        .player-wrapper { 
            position: relative; 
            width: 100%; 
            height: 100%; 
            overflow: hidden; 
            background: black;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        iframe { 
            position: absolute; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            border: none;
        }
    </style>
</head>
<body>
    <div class="player-wrapper">
        <div id="player"></div>
    </div>
    <script>
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        // ── Page Visibility override ────────────────────────────────
        // Prevents YouTube from auto-pausing when the macOS window is
        // minimized or the app loses focus (Page Visibility API).
        //
        // We override BOTH the parent document AND any future iframes
        // (YouTube IFrame API creates an <iframe> that has its own
        //  visibility context — it must be patched too).
        function patchVisibility(doc) {
            try {
                Object.defineProperty(doc, 'hidden', {
                    get: function() { return false; },
                    configurable: true
                });
                Object.defineProperty(doc, 'visibilityState', {
                    get: function() { return 'visible'; },
                    configurable: true
                });
            } catch(e) {}
        }

        // Patch the parent document
        patchVisibility(document);

        // Intercept visibilitychange BEFORE YouTube can see it
        document.addEventListener('visibilitychange', function(e) {
            e.stopImmediatePropagation();
            // If guardian wants to keep playing, force resume immediately
            if (_shouldBePlaying && player && typeof player.playVideo === 'function') {
                try { player.playVideo(); } catch(e2) {}
            }
        }, true);
        window.addEventListener('visibilitychange', function(e) {
            e.stopImmediatePropagation();
        }, true);

        // Also patch any iframes added by the YouTube IFrame API
        var _iframePatchObserver = new MutationObserver(function(mutations) {
            mutations.forEach(function(m) {
                m.addedNodes.forEach(function(node) {
                    if (node.tagName === 'IFRAME') {
                        try { patchVisibility(node.contentDocument); } catch(e) {}
                    }
                });
            });
        });
        _iframePatchObserver.observe(document.body, { childList: true, subtree: true });
        // ───────────────────────────────────────────────────────────

        var player;
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: '$id',
                playerVars: {
                    'autoplay': 1,
                    'controls': 0,
                    'playsinline': 1, // Let iOS/macOS play video inside the frame
                    'enablejsapi': 1,
                    'modestbranding': 1,
                    'rel': 0,
                    'showinfo': 0,
                    'iv_load_policy': 3,
                    'fs': 0,
                    'cc_load_policy': 0,
                    'autohide': 1,
                    'hl': 'en',
                    'origin': 'https://www.youtube-nocookie.com'
                },
                events: {
                    'onReady': onPlayerReady,
                    'onStateChange': onPlayerStateChange,
                    'onError': onPlayerError
                }
            });
        }

        function onPlayerError(event) {
            window.PlayerEvent.postMessage(JSON.stringify({
                event: 'error',
                code: event.data
            }));
        }

        function log(msg) {
            try { window.PlayerEvent.postMessage(JSON.stringify({event: 'log', message: msg})); } catch(e) {}
        }

        function onPlayerReady(event) {
            log("Player ready");
            window.PlayerEvent.postMessage(JSON.stringify({event: 'ready'}));
            startPolling();
        }

        function onPlayerStateChange(event) {
            window.PlayerEvent.postMessage(JSON.stringify({
                event: 'stateChange',
                state: event.data
            }));
        }

        // Disable right-click
        window.addEventListener('contextmenu', function(e) { e.preventDefault(); }, false);

        function startPolling() {
            setInterval(function() {
                try {
                  if (player && typeof player.getCurrentTime === 'function') {
                    var current = player.getCurrentTime();
                    var duration = player.getDuration();
                    if (current !== undefined) {
                      window.PlayerEvent.postMessage(JSON.stringify({
                          event: 'position',
                          position: current,
                          duration: duration || 0
                      }));
                    }
                  }
                } catch(e) {
                }
            }, 1000);
        }

        // ── Playback guardian ─────────────────────────────────────────
        // Tracks whether WE want the video playing.
        // • setInterval (150ms): catches any mid-session auto-pause
        // • window.focus: catches window restore from macOS Dock minimize
        //   (JS engine is suspended during minimize so setInterval can't fire)
        var _shouldBePlaying = false;

        // Guard: resume on window focus (fires when restored from Dock)
        window.addEventListener('focus', function() {
            if (_shouldBePlaying && player &&
                typeof player.playVideo === 'function') {
                // Small delay so the player fully wakes before we command it
                setTimeout(function() {
                    try {
                        if (_shouldBePlaying) player.playVideo();
                    } catch(e) {}
                }, 100);
                setTimeout(function() {
                    try {
                        if (_shouldBePlaying) player.playVideo();
                    } catch(e) {}
                }, 500);
            }
        });

        setInterval(function() {
            try {
                // YT.PlayerState.PAUSED === 2
                if (_shouldBePlaying && player &&
                    typeof player.getPlayerState === 'function' &&
                    player.getPlayerState() === 2) {
                    player.playVideo();
                }
            } catch(e) {}
        }, 150);
        // ─────────────────────────────────────────────────────────────

        function pauseVideo() {
            _shouldBePlaying = false;
            if (player) player.pauseVideo();
        }
        function playVideo() {
            _shouldBePlaying = true;
            if (player) player.playVideo();
        }
        function seekTo(seconds) {
            if (player) player.seekTo(seconds, true);
        }
    </script>
</body>
</html>
''';
      _desktopController?.loadHtmlString(html, baseUrl: 'https://www.youtube-nocookie.com');
    }
  }

  void _pause() {
    _intentionalPause = true; // mark as user-requested so we don't auto-resume
    if (isMobile) {
      _mobileController?.pause();
    } else if (_isDesktopReady) {
      _desktopController?.runJavaScript('pauseVideo()').catchError((_) {});
    }
  }

  void _resume() {
    _intentionalPause = false; // clear flag — playing is now desired
    if (isMobile) {
      _mobileController?.play();
    } else {
      // For desktop/WebView player, we trigger the JS playVideo() function.
      // We retry at small intervals to ensure it catches if the OS had suspended the JS engine.
      for (final delay in [0, 200, 500, 1000]) {
        Future.delayed(Duration(milliseconds: delay), () {
          if (!_intentionalPause && 
              ref.read(playerProvider).isPlaying && 
              _isDesktopReady) {
            _desktopController
                ?.runJavaScript('try { playVideo(); } catch(e) {}')
                .catchError((_) {});
          }
        });
      }
    }
  }

  void seekTo(double seconds) {
    if (isMobile) {
      _mobileController?.seekTo(Duration(seconds: seconds.toInt()));
    } else if (_isDesktopReady) {
      _desktopController?.runJavaScript('seekTo($seconds)').catchError((_) {});
    }
  }
}

final youtubePlayerServiceProvider = Provider<YoutubePlayerService>((ref) {
  return YoutubePlayerService(ref);
});
