import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';
import 'playback_controller.dart';
import 'background_playback_experiment.dart';

/// Returns an ISO-8601-like timestamp for diagnostic log lines.
String _ts() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}.'
      '${now.millisecond.toString().padLeft(3, '0')}';
}

/// Tagged diagnostic print — always present regardless of experiment flag.
void _diag(String msg) =>
    debugPrint('${_ts()} ${BackgroundPlaybackExperiment.tag} $msg');

// ---------------------------------------------------------------------------
// INativePlayerAdapter — injectable for production and tests
// ---------------------------------------------------------------------------

/// Abstraction over a single native media_kit player instance.
///
/// The production implementation ([MediaKitPlayerAdapter]) wraps the real
/// [Player]. Tests inject a fake that exposes the same event streams so the
/// engine's lifecycle logic can be exercised without a real media_kit player.
abstract class INativePlayerAdapter {
  Stream<bool> get playingStream;
  Stream<bool> get bufferingStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<Duration> get bufferStream;
  Stream<String> get errorStream;
  Stream<bool> get completedStream;
  Stream<VideoParams> get videoParamsStream;

  /// The [VideoController] associated with this player, or null for adapters
  /// that do not render video (e.g. audio-only test fakes).
  VideoController? get videoController;

  Future<void> open(String uri, {bool play = false});
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume100);
  Future<void> setRate(double rate);
  Future<void> setSubtitleTrack(SubtitleTrack track);
  Future<void> setSubtitleDelay(Duration delay);
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor});

  bool get supportsTrackSelection;
  bool get supportsExternalSubtitles;
  bool get supportsSubtitleDelay;
  bool get supportsSubtitleTextSize;
  bool get supportsSubtitleBackgroundStyling;

  /// Dispose this adapter and its underlying player. Must be idempotent.
  Future<void> dispose();
}

/// Production adapter wrapping a real [media_kit] [Player].
class MediaKitPlayerAdapter implements INativePlayerAdapter {
  static Player? _sharedPlayer;
  static VideoController? _sharedVideoController;

  MediaKitPlayerAdapter() {
    _sharedPlayer ??= Player();
    _sharedVideoController ??= VideoController(_sharedPlayer!);
    _player = _sharedPlayer!;
    _videoController = _sharedVideoController!;
  }

  late final Player _player;
  late final VideoController _videoController;
  bool _disposed = false;

  @override
  VideoController? get videoController => _videoController;

  @override
  Stream<bool> get playingStream => _player.stream.playing;
  @override
  Stream<bool> get bufferingStream => _player.stream.buffering;
  @override
  Stream<Duration> get positionStream => _player.stream.position;
  @override
  Stream<Duration> get durationStream => _player.stream.duration;
  @override
  Stream<Duration> get bufferStream => _player.stream.buffer;
  @override
  Stream<String> get errorStream => _player.stream.error;
  @override
  Stream<bool> get completedStream => _player.stream.completed;
  @override
  Stream<VideoParams> get videoParamsStream => _player.stream.videoParams;

  @override
  Future<void> open(String uri, {bool play = false}) =>
      _player.open(Media(uri), play: play);

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> setVolume(double volume100) => _player.setVolume(volume100);
  @override
  Future<void> setRate(double rate) => _player.setRate(rate);
  @override
  Future<void> setSubtitleTrack(SubtitleTrack track) =>
      _player.setSubtitleTrack(track);
  
  @override
  Future<void> setSubtitleDelay(Duration delay) async {
    if (_player.platform != null) {
      try {
        await (_player.platform as dynamic).setProperty('sub-delay', (delay.inMilliseconds / 1000.0).toString());
      } catch (e) {
        debugPrint('Failed to set subtitle delay: $e');
      }
    }
  }
  @override
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor}) async {
    if (_player.platform != null) {
      try {
        if (textSize != null) {
          await (_player.platform as dynamic).setProperty('sub-font-size', textSize.toString());
        }
        if (backgroundColor != null) {
          final hexColor = '#${backgroundColor.toRadixString(16).padLeft(8, '0')}';
          await (_player.platform as dynamic).setProperty('sub-back-color', hexColor);
        }
      } catch (e) {
        debugPrint('Failed to set subtitle appearance: $e');
      }
    }
  }
  @override
  bool get supportsTrackSelection => true;
  @override
  bool get supportsExternalSubtitles => true;
  @override
  bool get supportsSubtitleDelay => true;
  @override
  bool get supportsSubtitleTextSize => true;
  @override
  bool get supportsSubtitleBackgroundStyling => true;

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    // We do NOT dispose the shared player to avoid native FFI crashes.
  }
}

// ---------------------------------------------------------------------------
// NativePlaybackSession — one per play/prepare attempt
// ---------------------------------------------------------------------------

/// Owns one native player instance and all its event subscriptions.
///
/// Event callbacks capture this object directly. When the engine replaces
/// [_activeSession] the old session reference no longer matches, so any
/// late-arriving event from the old player is trivially discarded without
/// inspecting URIs, extras, or readiness flags.
class NativePlaybackSession {
  NativePlaybackSession({required this.generation, required this.adapter});

  final int generation;
  final INativePlayerAdapter adapter;
  final List<StreamSubscription<dynamic>> subscriptions = [];
  bool _torn = false;

  VideoController? get videoController => adapter.videoController;

  /// Cancel subscriptions and dispose the adapter exactly once (idempotent).
  Future<void> tear() async {
    if (_torn) return;
    _torn = true;
    for (final sub in subscriptions) {
      sub.cancel();
    }
    subscriptions.clear();
    await adapter.dispose();
  }
}

// ---------------------------------------------------------------------------
// MediaKitPlaybackEngine
// ---------------------------------------------------------------------------

class MediaKitPlaybackEngine implements PlaybackController {
  /// Factory for YouTube player controllers (used in tests and production).
  final yt.YoutubePlayerController Function(String, yt.YoutubePlayerParams)?
  youtubeControllerFactory;

  /// Factory for native player adapters.
  ///
  /// Defaults to creating a [MediaKitPlayerAdapter] (production).
  /// Inject a controlled fake in tests to exercise the production engine's
  /// lifecycle logic without a real media_kit player.
  final INativePlayerAdapter Function()? nativeAdapterFactory;

  MediaKitPlaybackEngine({
    this.youtubeControllerFactory,
    this.nativeAdapterFactory,
  }) {
    _initMediaKit();
  }

  void _initMediaKit() {
    try {
      MediaKit.ensureInitialized();
    } catch (e) {
      debugPrint(
        'MediaKitPlaybackEngine: MediaKit.ensureInitialized skipped (test env?): $e',
      );
    }
  }

  /// Informs the engine that the host activity is stopped (e.g. screen locked).
  /// Used to block IFrame playback dispatches when the WebView is frozen.
  static bool isActivityStopped = false;

  // ── Native session ─────────────────────────────────────────────────────────
  NativePlaybackSession? _activeSession;

  // ── YouTube/IFrame state ──────────────────────────────────────────────────
  yt.YoutubePlayerController? _youtubeController;

  /// Long-lived IFrame subscriptions, separate from session subscriptions.
  final List<StreamSubscription<dynamic>> _iframeSubscriptions = [];

  // ── Engine counters ────────────────────────────────────────────────────────
  int _playGeneration = 0;
  int _lastPlayedGeneration = 0;
  int _intentRevision = 0;
  bool _disposed = false;
  bool _attemptActive = false;
  Future<void>? _invalidationFuture;
  bool _recoveryUsed = false;
  bool _ready = false;
  int? _latePauseGeneration;

  bool _valid(int generation) =>
      !_disposed && _attemptActive && generation == _playGeneration;

  double? _currentStartSeconds;
  Duration? _confirmedPlaybackPosition;
  int _confirmedPositionGeneration = -1;

  Timer? _watchdogTimer;
  Timer? _iframePositionTimer;

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();

  PlaybackStatus _currentStatus = const PlaybackStatus(supportsSpeed: true);
  PlaybackState? _intendedState;

  // ---------------------------------------------------------------------------
  // Session management
  // ---------------------------------------------------------------------------

  INativePlayerAdapter _makeAdapter() =>
      nativeAdapterFactory != null
          ? nativeAdapterFactory!()
          : MediaKitPlayerAdapter();

  /// Immediately detach [_activeSession] (so its callbacks are rejected), then
  /// stop + dispose it asynchronously. Must be called *before* any await so
  /// a superseded open() cannot race with cleanup.
  Future<void> _invalidateActiveSession() async {
    final old = _activeSession;
    _activeSession =
        null; // detach synchronously — callbacks rejected immediately

    if (old == null) return;

    Future<void> doInvalidate() async {
      try {
        await old.adapter.stop().timeout(const Duration(seconds: 1));
      } catch (_) {}
      await old.tear();
    }

    final previous = _invalidationFuture;
    final current =
        (previous == null)
            ? doInvalidate()
            : previous.whenComplete(doInvalidate);

    _invalidationFuture = current;
    // We only await the current teardown if we want to serialize creation.
    // To avoid blocking the caller too long, we only await the OLD session's teardown.
    await doInvalidate();
  }

  /// Bind session-owned adapter streams to engine update handlers.
  ///
  /// Each closure captures [session] by reference. If [session] is no longer
  /// [_activeSession] when the event fires the update is dropped with a single
  /// identity check — no URI comparison, no extras, no readiness flag.
  void _bindSession(NativePlaybackSession session) {
    final a = session.adapter;
    session.subscriptions.addAll([
      a.positionStream.listen((pos) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        _updateStatus(
          _currentStatus.copyWith(
            position: pos,
            isLive: _currentStatus.track?.liveStatus == PlaybackLiveStatus.live,
          ),
        );
      }),
      a.durationStream.listen((dur) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        final track = _currentStatus.track;
        final isNetwork = track?.sourceType == PlaybackSourceType.networkStream;
        bool isSeekable = dur > Duration.zero;
        // Conservatively disable seeking for live/unknown network streams.
        if (isNetwork && track?.liveStatus != PlaybackLiveStatus.onDemand) {
          isSeekable = false;
        }
        _updateStatus(
          _currentStatus.copyWith(
            duration: dur,
            isSeekable: isSeekable,
            isLive: track?.liveStatus == PlaybackLiveStatus.live,
          ),
        );
      }),
      a.bufferStream.listen((buf) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        _updateStatus(_currentStatus.copyWith(buffered: buf));
      }),
      a.playingStream.listen((playing) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        // Don't overwrite preparing — wait for buffering/playing stream events.
        if (_currentStatus.state == PlaybackState.preparing) return;
        if (playing) {
          _watchdogTimer?.cancel();
        }
        _updateStatus(
          _currentStatus.copyWith(
            state: playing ? PlaybackState.playing : PlaybackState.paused,
          ),
        );
      }),
      a.errorStream.listen((err) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        final errStr = err.toLowerCase();
        String errorCode = 'error:playback_failed';
        if (errStr.contains('timeout')) {
          errorCode = 'error:playback_timeout';
        } else if (errStr.contains('format') ||
            errStr.contains('codec') ||
            errStr.contains('corrupt')) {
          errorCode = 'error:unsupported_format';
        } else if (errStr.contains('access') ||
            errStr.contains('permission') ||
            errStr.contains('not found')) {
          errorCode = 'error:file_inaccessible';
        }
        _watchdogTimer?.cancel();
        _updateStatus(
          _currentStatus.copyWith(state: PlaybackState.error, error: errorCode),
        );
      }),
      a.completedStream.listen((completed) {
        if (!completed) return;
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        _watchdogTimer?.cancel();
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
      }),
      a.bufferingStream.listen((buffering) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        // Don't regress from a valid non-preparing state to "not-buffering"
        // unless we're already in buffering/playing.
        if (_currentStatus.state == PlaybackState.preparing && !buffering) {
          return;
        }
        _updateStatus(
          _currentStatus.copyWith(
            state:
                buffering
                    ? PlaybackState.buffering
                    : (_intendedState ?? PlaybackState.paused),
          ),
        );
      }),
      a.videoParamsStream.listen((params) {
        if (session != _activeSession || _disposed) return;
        if (_currentStatus.isIFrameMode) return;
        final w = params.w ?? 0;
        final h = params.h ?? 0;
        final hasDimensions = w > 0 && h > 0;

        // If the track is statically known to be a video, don't let a transient 0x0
        // size param hide the view, which breaks native macOS texture binding.
        final hasVideo =
            (_currentStatus.track?.isVideo == true) || hasDimensions;

        _updateStatus(
          _currentStatus.copyWith(
            hasVideo: hasVideo,
            videoAspectRatio: hasDimensions ? w / h : null,
          ),
        );
      }),
    ]);
  }

  // ---------------------------------------------------------------------------
  // PlaybackController interface
  // ---------------------------------------------------------------------------

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  PlaybackStatus get currentStatus => _currentStatus;

  /// Returns the [VideoController] for the currently active native session,
  /// or null when no native session is active (idle, IFrame mode, or disposed).
  @override
  dynamic get renderer => _activeSession?.videoController;

  @override
  yt.YoutubePlayerController? get youtubeController => _youtubeController;

  // ---------------------------------------------------------------------------
  // prepare()
  // ---------------------------------------------------------------------------

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
    if (_disposed) return;

    if (track.isLocal || track.sourceType == PlaybackSourceType.networkStream) {
      final uri = track.isLocal ? track.localMediaUri : track.networkMediaUri;
      if (uri == null) {
        _updateStatus(
          _currentStatus.copyWith(
            track: track,
            state: PlaybackState.error,
            error: 'Media URI is missing for ${track.id}',
          ),
        );
        return;
      }

      // ── Invalidate immediately BEFORE any await ───────────────────────────
      _intentRevision++;
      _intendedState = PlaybackState.paused;
      _playGeneration++;
      final myGen = _playGeneration;

      await _invalidateActiveSession();
      if (_disposed || _playGeneration != myGen) return;

      // ── Create and activate the new session ───────────────────────────────
      final session = NativePlaybackSession(
        generation: myGen,
        adapter: _makeAdapter(),
      );
      // Assign _activeSession first so its callbacks are accepted and the
      // renderer getter immediately returns the new VideoController.
      _activeSession = session;
      _attemptActive = true;
      _recoveryUsed = false;
      _ready = false;
      _latePauseGeneration = null;

      // Bind callbacks BEFORE opening so initialization events during open()
      // are accepted.
      _bindSession(session);

      // Arm watchdog to prevent hanging on inaccessible files or broken streams
      _watchdogTimer?.cancel();
      _watchdogTimer = Timer(Duration(seconds: track.isLocal ? 5 : 20), () {
        if (_disposed || _activeSession != session) return;
        if (_currentStatus.state == PlaybackState.preparing ||
            _currentStatus.state == PlaybackState.buffering) {
          _failAttempt(
            myGen,
            track.isLocal
                ? 'error:file_inaccessible'
                : 'error:playback_timeout',
          );
        }
      });

      // Publish the new renderer and status BEFORE opening media.
      _updateStatus(
        _currentStatus.copyWith(
          track: track,
          state: PlaybackState.preparing,
          clearError: true,
          activeVideoId: track.id,
          hasVideo: track.isVideo,
          isIFrameMode: false,
          generation: myGen,
          isLive: track.liveStatus == PlaybackLiveStatus.live,
          isSeekable: false,
          position: Duration.zero,
          duration: Duration.zero,
          buffered: Duration.zero,
        ),
      );

      if (_currentStatus.isIFrameMode) {
        try {
          await _youtubeController?.pauseVideo().timeout(
            const Duration(seconds: 1),
          );
        } catch (_) {}
      }

      try {
        // Non-autoplay: open without starting playback.
        await session.adapter
            .open(uri, play: false)
            .timeout(const Duration(seconds: 10));
        if (_disposed || _activeSession != session) return;

        // Apply settings AFTER open() to avoid hanging media_kit on Android.
        await session.adapter.setVolume(_currentStatus.volume * 100);
        if (_disposed || _activeSession != session) return;
        await session.adapter.setRate(_currentStatus.speed);
        if (_disposed || _activeSession != session) return;

        if (position != null) {
          await session.adapter.seek(position);
          if (_disposed || _activeSession != session) return;
        }

        // Do not overwrite a terminal state (error/ended) that may have arrived
        // from a stream event during open().
        if (_currentStatus.state == PlaybackState.preparing) {
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
        }
      } catch (e) {
        if (_disposed || _activeSession != session) return;
        final errStr = e.toString().toLowerCase();
        String errorCode = 'error:playback_failed';
        if (errStr.contains('format') || errStr.contains('codec')) {
          errorCode = 'error:unsupported_format';
        } else if (errStr.contains('access') ||
            errStr.contains('not found') ||
            errStr.contains('no such file') ||
            errStr.contains('timeout')) {
          errorCode = 'error:file_inaccessible';
        }
        _updateStatus(
          _currentStatus.copyWith(state: PlaybackState.error, error: errorCode),
        );
      }
      return;
    }

    // ── YouTube prepare path ──────────────────────────────────────────────────
    _attemptActive = true;
    _intentRevision++;
    _intendedState = PlaybackState.paused;
    _playGeneration++;
    final myGenYt = _playGeneration;

    if (!_currentStatus.isIFrameMode) {
      await _invalidateActiveSession();
      if (_disposed || _playGeneration != myGenYt) return;
    }

    final ss =
        position?.inMilliseconds != null
            ? position!.inMilliseconds / 1000.0
            : null;
    _currentStartSeconds = ss;

    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        isIFrameMode: true,
        hasVideo: true,
        activeVideoId: track.id,
      ),
    );

    if (_youtubeController == null) {
      await _enterIFrameMode(track.id, generation: myGenYt);
    }

    if (_disposed || myGenYt != _playGeneration) return;

    try {
      _diag('PREPARE cueVideo/Playlist gen=$myGenYt videoId=${track.id} ss=$ss');
      if (track.id.length > 11 && (track.id.startsWith('PL') || track.id.startsWith('RD') || track.id.startsWith('LL'))) {
        await _youtubeController!.cuePlaylist(
          list: [track.id],
          listType: yt.ListType.playlist,
          startSeconds: ss,
        );
      } else {
        await _youtubeController!.cueVideoById(
          videoId: track.id,
          startSeconds: ss,
        );
      }
    } catch (e) {
      debugPrint('MediaKitPlaybackEngine: prepare cueVideo/Playlist failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // play()
  // ---------------------------------------------------------------------------

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    if (_disposed) return;

    debugPrint('ENGINE: play called for track ${track.id} (startAt: $startAt)');

    if (track.isLocal || track.sourceType == PlaybackSourceType.networkStream) {
      final uri = track.isLocal ? track.localMediaUri : track.networkMediaUri;
      if (uri == null) {
        _updateStatus(
          _currentStatus.copyWith(
            track: track,
            state: PlaybackState.error,
            error: 'Media URI is missing for ${track.id}',
          ),
        );
        return;
      }

      // ── Invalidate immediately BEFORE any await ───────────────────────────
      _attemptActive = false;
      _intentRevision++;
      _intendedState = PlaybackState.playing;
      _playGeneration++;
      final myGen = _playGeneration;
      _watchdogTimer?.cancel();

      await _invalidateActiveSession();
      if (_disposed || _playGeneration != myGen) return;

      // ── Create and activate the new session ───────────────────────────────
      final session = NativePlaybackSession(
        generation: myGen,
        adapter: _makeAdapter(),
      );
      _activeSession = session;
      _attemptActive = true;
      _recoveryUsed = false;
      _ready = false;
      _latePauseGeneration = null;

      // Bind callbacks BEFORE opening so initialization events during open()
      // are accepted.
      _bindSession(session);

      // Arm watchdog to prevent hanging on inaccessible files or broken streams
      _watchdogTimer?.cancel();
      _watchdogTimer = Timer(Duration(seconds: track.isLocal ? 5 : 20), () {
        if (_disposed || _activeSession != session) return;
        if (_currentStatus.state == PlaybackState.preparing ||
            _currentStatus.state == PlaybackState.buffering) {
          _failAttempt(
            myGen,
            track.isLocal
                ? 'error:file_inaccessible'
                : 'error:playback_timeout',
          );
        }
      });

      // Publish the new renderer and status BEFORE opening media.
      _updateStatus(
        _currentStatus.copyWith(
          track: track,
          state: PlaybackState.preparing,
          clearError: true,
          activeVideoId: track.id,
          hasVideo: track.isVideo,
          isIFrameMode: false,
          generation: myGen,
          isLive: track.liveStatus == PlaybackLiveStatus.live,
          isSeekable: false,
          position: Duration.zero,
          duration: Duration.zero,
          buffered: Duration.zero,
        ),
      );

      try {
        // Non-autoplay open: explicitly start after verifying session ownership.
        await session.adapter
            .open(uri, play: false)
            .timeout(const Duration(seconds: 10));
        if (_disposed || _activeSession != session) return;

        // Apply user settings AFTER open() to prevent Android deadlocks.
        await session.adapter.setVolume(_currentStatus.volume * 100);
        await session.adapter.setRate(_currentStatus.speed);

        if (startAt > Duration.zero) {
          await session.adapter.seek(startAt);
          if (_disposed || _activeSession != session) return;
        }

        if (_intendedState == PlaybackState.playing) {
          await session.adapter.play();
          if (_disposed || _activeSession != session) return;
        }

        // Reconcile: move out of preparing if no terminal state arrived yet.
        final terminalStates = {PlaybackState.error, PlaybackState.ended};
        if (!terminalStates.contains(_currentStatus.state) &&
            _currentStatus.state == PlaybackState.preparing) {
          _updateStatus(
            _currentStatus.copyWith(state: PlaybackState.buffering),
          );
        }
      } catch (e) {
        if (_disposed || _activeSession != session) return;
        if (_valid(myGen)) {
          final errStr = e.toString().toLowerCase();
          String errorCode = 'error:playback_failed';
          if (errStr.contains('format') || errStr.contains('codec')) {
            errorCode = 'error:unsupported_format';
          } else if (errStr.contains('access') ||
              errStr.contains('not found') ||
              errStr.contains('no such file') ||
              errStr.contains('timeout')) {
            errorCode = 'error:file_inaccessible';
          }
          _failAttempt(myGen, errorCode);
        }
      }
      return;
    }

    // ── YouTube play path ─────────────────────────────────────────────────────
    _attemptActive = false;
    _intentRevision++;
    _intendedState = PlaybackState.playing;
    _playGeneration++;
    final myGenYt = _playGeneration;

    _watchdogTimer?.cancel();
    if (!_currentStatus.isIFrameMode) {
      await _invalidateActiveSession();
    } else {
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 1),
        );
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: pauseVideo failed/timed out: $e');
      }
    }

    if (_disposed || myGenYt != _playGeneration) return;
    _attemptActive = true;
    _recoveryUsed = false;
    _ready = false;
    _latePauseGeneration = null;

    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        clearError: true,
        activeVideoId: track.id,
        hasVideo: true,
        isIFrameMode: true,
        generation: myGenYt,
      ),
    );

    final ss =
        startAt.inMilliseconds > 0 ? startAt.inMilliseconds / 1000.0 : null;
    _currentStartSeconds = ss;
    await _enterIFrameMode(track.id, generation: myGenYt, startSeconds: ss);
  }

  // ---------------------------------------------------------------------------
  // YouTube helpers (unchanged logic, adapted variable names)
  // ---------------------------------------------------------------------------

  void _failAttempt(int generation, String error) {
    if (!_valid(generation)) return;
    _attemptActive = false;
    _watchdogTimer?.cancel();
    _updateStatus(
      _currentStatus.copyWith(state: PlaybackState.error, error: error),
    );
  }

  void _armWatchdog(int generation, {required bool loading}) {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer(Duration(seconds: _recoveryUsed ? 10 : 20), () {
      if (!_valid(generation) || _intendedState != PlaybackState.playing)
        return;
      if (_currentStatus.state == PlaybackState.playing) return;
      if (!BackgroundPlaybackExperiment.enabled && isActivityStopped) return;
      if (_recoveryUsed) {
        _failAttempt(
          generation,
          loading
              ? 'error: YouTube loading timed out (gen=$generation)'
              : 'error: YouTube playback start timed out (gen=$generation)',
        );
        return;
      }
      _recoveryUsed = true;
      _ready = false;
      _lastPlayedGeneration = -1;
      if (!_valid(generation)) return;
      _armWatchdog(generation, loading: true);
      final recoveryStart =
          (_confirmedPositionGeneration == generation &&
                  _confirmedPlaybackPosition != null)
              ? _confirmedPlaybackPosition!.inMilliseconds / 1000.0
              : _currentStartSeconds;
      unawaited(
        _load(
          generation,
          _currentStatus.track!.id,
          startSeconds: recoveryStart,
        ),
      );
    });
  }

  Future<void> _enterIFrameMode(
    String videoId, {
    required int generation,
    double? startSeconds,
  }) async {
    if (_youtubeController == null) {
      debugPrint(
        'MediaKitPlaybackEngine: [INIT] Creating YoutubePlayerController (persistent singleton)',
      );

      if (youtubeControllerFactory != null) {
        _youtubeController = youtubeControllerFactory!(
          videoId,
          const yt.YoutubePlayerParams(
            showControls: false,
            showFullscreenButton: false,
            mute: false,
            loop: false,
            strictRelatedVideos: true,
            origin: 'https://ppplayer.com',
            pointerEvents: yt.PointerEvents.none,
          ),
        );
      } else {
        _youtubeController = yt.YoutubePlayerController(
          params: const yt.YoutubePlayerParams(
            showControls: false,
            showFullscreenButton: false,
            mute: false,
            loop: false,
            strictRelatedVideos: true,
            origin: 'https://ppplayer.com',
            pointerEvents: yt.PointerEvents.none,
          ),
        );
      }

      // ignore: invalid_use_of_internal_member
      _youtubeController!.webViewController.addJavaScriptChannel(
        'NativeLog',
        onMessageReceived: (msg) {
          debugPrint('MediaKitPlaybackEngine: [NativeLog] ${msg.message}');
        },
      );

      // Persistent generation-aware listener. This is the ONLY place that
      // calls playVideo() in response to a 'cued' state.
      _iframeSubscriptions.add(
        _youtubeController!.listen((ytState) {
          if (!_currentStatus.isIFrameMode || !_valid(_playGeneration)) return;
          final eventId = ytState.metaData.videoId;
          if (eventId.isNotEmpty && eventId != _currentStatus.track?.id) return;

          final gen = _playGeneration;
          _diag(
            'BRIDGE gen=$gen iframeState=${ytState.playerState} '
            'engineState=${_currentStatus.state} intended=$_intendedState '
            'activityStopped=$isActivityStopped',
          );

          if (ytState.hasError && ytState.error != yt.YoutubeError.none) {
            debugPrint(
              'MediaKitPlaybackEngine: [ERROR] YouTube IFrame error: ${ytState.error}',
            );
            final eventVideoId = ytState.metaData.videoId;
            final currentVideoId = _currentStatus.track?.id;
            if (eventVideoId.isNotEmpty &&
                currentVideoId != null &&
                eventVideoId != currentVideoId) {
              debugPrint(
                'MediaKitPlaybackEngine: [BRIDGE] Ignoring stale error for $eventVideoId (current: $currentVideoId).',
              );
              return;
            }
            if (ytState.error == yt.YoutubeError.videoNotFound ||
                ytState.error == yt.YoutubeError.notEmbeddable ||
                ytState.error == yt.YoutubeError.cannotFindVideo ||
                ytState.error == yt.YoutubeError.sameAsNotEmbeddable ||
                ytState.error == yt.YoutubeError.invalidParam) {
              _failAttempt(gen, 'unavailable_media:${ytState.error.name}');
              return;
            }
            // Transient errors are ignored.
          }

          switch (ytState.playerState) {
            case yt.PlayerState.cued:
            case yt.PlayerState.unStarted:
              _ready = true;
              // Repeated readiness events must not restart the start deadline.
              if (_lastPlayedGeneration != gen) {
                if (_intendedState == PlaybackState.paused) {
                  // prepare() path: resolve to paused with saved position.
                  final savedPos =
                      _currentStartSeconds != null
                          ? Duration(
                            milliseconds:
                                (_currentStartSeconds! * 1000).toInt(),
                          )
                          : Duration.zero;
                  _updateStatus(
                    _currentStatus.copyWith(
                      state: PlaybackState.paused,
                      position: savedPos,
                      activeVideoId: _currentStatus.track?.id,
                    ),
                  );
                } else {
                  unawaited(_dispatchIFramePlay(gen, ytState.playerState.name));
                }
              }
              break;
            default:
              break;
          }

          final newState = switch (ytState.playerState) {
            yt.PlayerState.playing => PlaybackState.playing,
            yt.PlayerState.paused => PlaybackState.paused,
            yt.PlayerState.unStarted => PlaybackState.paused,
            yt.PlayerState.buffering => PlaybackState.buffering,
            yt.PlayerState.ended => PlaybackState.ended,
            // A cued video is ready-but-paused.
            yt.PlayerState.cued => PlaybackState.paused,
            _ => _currentStatus.state,
          };

          if (newState == PlaybackState.ended) {
            final eventVideoId = ytState.metaData.videoId;
            final currentVideoId = _currentStatus.track?.id;
            if (eventVideoId.isNotEmpty &&
                currentVideoId != null &&
                eventVideoId != currentVideoId) {
              debugPrint(
                'MediaKitPlaybackEngine: [BRIDGE] Ignoring stale ended event for $eventVideoId (current: $currentVideoId).',
              );
              return;
            }
            _eventController.add(
              PlaybackEvent(
                type: PlaybackEventType.trackEnded,
                track: _currentStatus.track,
                generation: gen,
              ),
            );
          }

          if ((newState == PlaybackState.playing ||
                  newState == PlaybackState.buffering) &&
              _intendedState == PlaybackState.paused) {
            if (!BackgroundPlaybackExperiment.enabled) {
              _diag(
                'BRIDGE SPURIOUS-PLAY: intendedState=paused. [BASELINE] forcing pauseVideo().',
              );
              unawaited(
                _youtubeController?.pauseVideo().catchError((Object error) {
                  _diag('Corrective pause failed: $error');
                }),
              );
              return;
            } else {
              _diag(
                'BRIDGE SPURIOUS-PLAY: intendedState=paused. [EXPERIMENT] OBSERVE ONLY.',
              );
            }
          }

          if (ytState.playerState == yt.PlayerState.paused &&
              _intendedState == PlaybackState.paused) {
            _latePauseGeneration = null;
          }
          if (newState == PlaybackState.paused &&
              _intendedState == PlaybackState.playing) {
            if (ytState.playerState == yt.PlayerState.paused &&
                _latePauseGeneration == gen) {
              _latePauseGeneration = null;
              unawaited(_dispatchIFramePlay(gen, 'late-pause'));
            }
            if (ytState.playerState == yt.PlayerState.unStarted) return;
          }
          if (newState == PlaybackState.playing) {
            _watchdogTimer?.cancel();
            _confirmedPositionGeneration = gen;
          }

          if (newState != _currentStatus.state) {
            _updateStatus(_currentStatus.copyWith(state: newState));
          }
        }),
      );
    }

    if (generation != _playGeneration) {
      debugPrint(
        'MediaKitPlaybackEngine: Stale enterIFrameMode (gen: $generation). Aborting.',
      );
      return;
    }

    _updateStatus(_currentStatus);
    _armWatchdog(generation, loading: true);
    await _load(generation, videoId, startSeconds: startSeconds);
  }

  Future<void> _load(
    int generation,
    String videoId, {
    double? startSeconds,
  }) async {
    if (!_valid(generation)) return;
    bool eligible() =>
        _valid(generation) &&
        _intendedState == PlaybackState.playing &&
        (BackgroundPlaybackExperiment.enabled || !isActivityStopped);
    try {
      if (!eligible()) {
        if (_intendedState != PlaybackState.paused) {
          _diag('ENGINE _load() BLOCKED: not eligible to play.');
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
        } else {
          _diag(
            'ENGINE _load() BLOCKED (prepare path): skipping spurious paused emit.',
          );
        }
        return;
      }
      if (videoId.length > 11 && (videoId.startsWith('PL') || videoId.startsWith('RD') || videoId.startsWith('LL'))) {
        await _youtubeController!.loadPlaylist(
          list: [videoId],
          listType: yt.ListType.playlist,
          startSeconds: startSeconds,
        );
      } else {
        await _youtubeController!.loadVideoById(
          videoId: videoId,
          startSeconds: startSeconds,
        );
      }
    } catch (error) {
      _failAttempt(generation, 'YouTube loading failed: $error');
    }
  }

  // ---------------------------------------------------------------------------
  // pause / resume / stop / seekTo / setVolume / setSpeed / setSubtitleTrack
  // ---------------------------------------------------------------------------

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {
    if ((_currentStatus.state == PlaybackState.paused ||
            _currentStatus.state == PlaybackState.idle) &&
        _intendedState != PlaybackState.playing) {
      return;
    }

    _diag(
      'ENGINE pause() caller=$caller failOnTimeout=$failOnTimeout '
      'intendedWas=$_intendedState gen=$_playGeneration',
    );
    _intentRevision++;
    _watchdogTimer?.cancel();
    _intendedState = PlaybackState.paused;

    final pauseAck = statusStream
        .firstWhere(
          (s) =>
              s.state == PlaybackState.paused || s.state == PlaybackState.idle,
        )
        .timeout(const Duration(seconds: 2));

    if (!failOnTimeout) {
      // Optimistically update the state so the UI and OS MediaSession reflect
      // the paused state immediately, rather than waiting for the JS bridge
      // (which may be suspended by the OS and never fire the event).
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }

    if (_currentStatus.isIFrameMode) {
      _latePauseGeneration = _playGeneration;
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: pauseVideo failed/timed out: $e');
        if (failOnTimeout) {
          throw TimeoutException(
            'Source pause failed (IFrame error)',
            const Duration(seconds: 2),
          );
        }
        if (_intendedState == PlaybackState.paused) {
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
        }
        return;
      }
    } else {
      await _activeSession?.adapter.pause();
    }

    try {
      await pauseAck;
    } catch (e) {
      // TimeoutException: ack didn't arrive within 2 s.
      // StateError ("No element"): engine disposed while pause was pending.
      debugPrint(
        'MediaKit: pause ack timeout/close (caller=$caller, failOnTimeout=$failOnTimeout): $e',
      );
      if (failOnTimeout && e is TimeoutException) {
        throw TimeoutException(
          'Source pause unconfirmed by IFrame',
          const Duration(seconds: 2),
        );
      }
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }
  }

  Future<void> _dispatchIFramePlay(
    int expectedGeneration,
    String source,
  ) async {
    bool eligible() =>
        _valid(expectedGeneration) &&
        _intendedState == PlaybackState.playing &&
        (BackgroundPlaybackExperiment.enabled || !isActivityStopped);
    if (!eligible()) {
      if (_valid(expectedGeneration) && isActivityStopped) {
        _watchdogTimer?.cancel();
        _intendedState = PlaybackState.paused;
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      }
      return;
    }
    final revision = _intentRevision;
    _lastPlayedGeneration = expectedGeneration;
    try {
      await _youtubeController!.setVolume(
        (_currentStatus.volume * 100).toInt(),
      );
      if (!eligible() || revision != _intentRevision) return;
      _diag('DISPATCH playVideo gen=$expectedGeneration source=$source');
      final command = _youtubeController!.playVideo();
      _armWatchdog(expectedGeneration, loading: false);
      await command;
    } catch (error) {
      if (eligible() && revision == _intentRevision) {
        _failAttempt(
          expectedGeneration,
          'YouTube playback dispatch failed: $error',
        );
      }
    }
  }

  @override
  Future<void> resume() async {
    _intentRevision++;
    _diag(
      'ENGINE resume() iframeMode=${_currentStatus.isIFrameMode} '
      'activityStopped=$isActivityStopped gen=$_playGeneration',
    );

    // Activity-stopped guard (baseline only).
    if (!BackgroundPlaybackExperiment.enabled &&
        _currentStatus.isIFrameMode &&
        isActivityStopped) {
      _diag(
        'ENGINE resume() BLOCKED [BASELINE guard]: activity stopped. '
        'Setting intendedState=paused, emitting paused.',
      );
      _intendedState = PlaybackState.paused;
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      return;
    }

    if (BackgroundPlaybackExperiment.enabled &&
        _currentStatus.isIFrameMode &&
        isActivityStopped) {
      _diag(
        'ENGINE resume() PASS-THROUGH [EXPERIMENT]: activity stopped but guard disabled.',
      );
    }

    _intendedState = PlaybackState.playing;
    if (_currentStatus.isIFrameMode) {
      if (_ready) {
        // Ensure _attemptActive is set so _valid() passes inside
        // _dispatchIFramePlay. prepare() already sets it to true, but
        // an intermediate pause() call can clear it; reassert here.
        _attemptActive = true;
        await _dispatchIFramePlay(_playGeneration, 'resume');
      } else if (_valid(_playGeneration)) {
        _armWatchdog(_playGeneration, loading: true);
        await _load(
          _playGeneration,
          _currentStatus.track!.id,
          startSeconds: _currentStartSeconds,
        );
      }
    } else {
      await _activeSession?.adapter.play();
    }
  }

  @override
  Future<void> stop() async {
    _playGeneration++;
    _intentRevision++;
    _attemptActive = false;
    _latePauseGeneration = null;
    _watchdogTimer?.cancel();
    _stopIFramePolling();
    _intendedState = PlaybackState.paused;

    // Optimistically update before awaiting so the UI reflects idle immediately.
    _updateStatus(
      _currentStatus.copyWith(
        state: PlaybackState.idle,
        track: null,
        activeVideoId: null,
      ),
    );

    if (_currentStatus.isIFrameMode) {
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint(
          'MediaKitPlaybackEngine: stop() pauseVideo threw/timed out: $e',
        );
      }
      // Keep IFrame controller alive to avoid recreating the platform view.
    } else {
      await _invalidateActiveSession();
    }
  }

  @override
  Future<void> seekTo(Duration position) async {
    if (!_currentStatus.isSeekable) {
      debugPrint(
        'MediaKitPlaybackEngine: Blocked seek attempt to $position '
        '(isSeekable=false). Network capability is unknown or stream is live.',
      );
      return;
    }

    final generation = _playGeneration;
    final revision = _intentRevision;
    final wasPlaying = _currentStatus.state == PlaybackState.playing;

    if (_currentStatus.isIFrameMode) {
      if (!_valid(generation)) return;
      if (!_ready) {
        // If not ready, we must load to prepare the offset.
        await _load(
          generation,
          _currentStatus.track!.id,
          startSeconds: position.inMilliseconds / 1000,
        );
      } else {
        await _youtubeController?.seekTo(
          seconds: position.inMilliseconds / 1000.0,
          allowSeekAhead: true,
        );
        // Seeking a paused video can start it implicitly; enforce intent.
        if (_intendedState != PlaybackState.playing) {
          unawaited(_youtubeController?.pauseVideo());
        }
      }
      if (_valid(generation)) {
        _currentStartSeconds = position.inMilliseconds / 1000.0;
        _updateStatus(_currentStatus.copyWith(position: position));
      }
      if (wasPlaying && revision == _intentRevision) {
        await _dispatchIFramePlay(generation, 'seek');
      }
    } else {
      final session = _activeSession;
      if (session == null) return;
      await session.adapter.seek(position);
      if (wasPlaying && _activeSession == session) {
        await session.adapter.play();
      }
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setVolume((volume * 100).toInt());
    } else {
      await _activeSession?.adapter.setVolume(volume * 100);
    }
    _updateStatus(_currentStatus.copyWith(volume: volume));
  }

  @override
  bool get supportsSpeed => true;

  /// True only when MediaKit is rendering the video surface (not YouTube iframe).
  @override
  bool get supportsVideoFitMode =>
      _currentStatus.hasVideo && !_currentStatus.isIFrameMode;

  @override
  Future<void> setSpeed(double speed) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setPlaybackRate(speed);
    } else {
      await _activeSession?.adapter.setRate(speed);
    }
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {
    if (_currentStatus.isIFrameMode) return;
    if (uri == null) {
      await _activeSession?.adapter.setSubtitleTrack(SubtitleTrack.no());
    } else {
      await _activeSession?.adapter.setSubtitleTrack(SubtitleTrack.uri(uri));
    }
  }
  @override
  bool get supportsTrackSelection => _activeSession?.adapter.supportsTrackSelection ?? false;

  @override
  bool get supportsExternalSubtitles => _activeSession?.adapter.supportsExternalSubtitles ?? false;

  @override
  bool get supportsSubtitleDelay => _activeSession?.adapter.supportsSubtitleDelay ?? false;

  @override
  bool get supportsSubtitleTextSize => _activeSession?.adapter.supportsSubtitleTextSize ?? false;

  @override
  bool get supportsSubtitleBackgroundStyling => _activeSession?.adapter.supportsSubtitleBackgroundStyling ?? false;

  @override
  Future<void> setSubtitleDelay(Duration delay) async {
    if (_currentStatus.isIFrameMode) return;
    await _activeSession?.adapter.setSubtitleDelay(delay);
  }

  @override
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor}) async {
    if (_currentStatus.isIFrameMode) return;
    await _activeSession?.adapter.setSubtitleAppearance(textSize: textSize, backgroundColor: backgroundColor);
  }
  // ---------------------------------------------------------------------------
  // Status update + IFrame position polling
  // ---------------------------------------------------------------------------

  void _updateStatus(PlaybackStatus status) {
    if (_disposed) return;
    if (status.state != _currentStatus.state) {
      _diag(
        'STATE ${_currentStatus.state} → ${status.state} '
        'gen=$_playGeneration intended=$_intendedState '
        'activityStopped=$isActivityStopped',
      );
    }
    _currentStatus = status.copyWith(generation: _playGeneration);
    _statusController.add(_currentStatus);

    // Manage IFrame position polling.
    if (status.isIFrameMode && status.state == PlaybackState.playing) {
      if (_iframePositionTimer == null) {
        _startIFramePolling();
      }
    } else if (status.state != PlaybackState.playing) {
      _stopIFramePolling();
    }
  }

  // Tracks consecutive ticks where getCurrentTime returned the same frozen
  // value. A position that hasn't advanced for ~2 seconds while >= duration is
  // treated as a synthetic end-of-track signal.
  double _lastPolledPosition = -1;
  int _frozenPositionTicks = 0;
  static const int _frozenTicksThreshold = 4; // 4 × 500 ms = 2 s

  void _startIFramePolling() {
    final generation = _playGeneration;
    _lastPolledPosition = -1;
    _frozenPositionTicks = 0;
    _iframePositionTimer?.cancel();
    _iframePositionTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) async {
      if (_youtubeController == null || !_currentStatus.isIFrameMode) {
        timer.cancel();
        return;
      }

      double currentTime;
      double duration;
      try {
        // Each JS bridge call is individually guarded so a single hung call
        // does not block the timer indefinitely.
        currentTime = await _youtubeController!.currentTime.timeout(
          const Duration(milliseconds: 400),
        );
        duration = await _youtubeController!.duration.timeout(
          const Duration(milliseconds: 400),
        );
      } catch (e) {
        return;
      }

      // Synthetic end-of-track detection (for macOS App Nap).
      if (duration > 0 &&
          currentTime >= duration - 0.5 &&
          _intendedState == PlaybackState.playing) {
        final positionFrozen = (currentTime - _lastPolledPosition).abs() < 0.01;
        if (positionFrozen) {
          _frozenPositionTicks++;
        } else {
          _frozenPositionTicks = 0;
        }
        _lastPolledPosition = currentTime;

        if (_frozenPositionTicks >= _frozenTicksThreshold) {
          _diag(
            'RENDERER gen=$generation synthetic end-of-track: '
            'pos=$currentTime dur=$duration frozen=$_frozenPositionTicks ticks',
          );
          timer.cancel();
          _iframePositionTimer = null;
          if (!_disposed) {
            _eventController.add(
              PlaybackEvent(
                type: PlaybackEventType.trackEnded,
                track: _currentStatus.track,
                generation: _playGeneration,
              ),
            );
          }
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
          return;
        }
      } else {
        _frozenPositionTicks = 0;
        _lastPolledPosition = currentTime;
      }

      if (!_valid(generation)) return;

      if (_currentStatus.state == PlaybackState.playing) {
        _diag(
          'RENDERER gen=$generation position=$currentTime duration=$duration',
        );
        final positionDuration = Duration(
          milliseconds: (currentTime * 1000).toInt(),
        );
        // Update confirmed position for watchdog recovery.
        if (_confirmedPositionGeneration == generation) {
          _confirmedPlaybackPosition = positionDuration;
        }
        _updateStatus(
          _currentStatus.copyWith(
            position: positionDuration,
            duration: Duration(milliseconds: (duration * 1000).toInt()),
          ),
        );
      }
    });
  }

  void _stopIFramePolling() {
    _iframePositionTimer?.cancel();
    _iframePositionTimer = null;
  }

  // ---------------------------------------------------------------------------
  // dispose
  // ---------------------------------------------------------------------------

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _attemptActive = false;
    _playGeneration++;
    _watchdogTimer?.cancel();
    _iframePositionTimer?.cancel();

    // Detach and cancel the active session's subscriptions synchronously;
    // adapter disposal is awaited to ensure native resources are freed.
    // Subscriptions must be cancelled BEFORE the native object is freed to
    // prevent a callback firing into a freed object (SIGABRT in libmpv).
    final session = _activeSession;
    _activeSession = null;
    if (session != null) {
      for (final sub in session.subscriptions) {
        sub.cancel();
      }
      session.subscriptions.clear();
      try {
        await session.adapter.dispose().timeout(const Duration(seconds: 2));
      } catch (e) {
        // Native cleanup failed or timed out, but Dart state is isolated.
      }
    }

    for (final sub in _iframeSubscriptions) {
      sub.cancel();
    }
    _iframeSubscriptions.clear();

    _youtubeController?.close();
    _statusController.close();
    _eventController.close();
  }
}
