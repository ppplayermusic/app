import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'pip_handler.dart';

enum EngineOwner { foreground, background }

class HybridPlaybackEngine implements PlaybackController {
  final PlaybackController _foregroundEngine;
  final PlaybackController _backgroundEngine;
  
  EngineOwner _owner = EngineOwner.foreground;
  bool _isTransferring = false;
  int _handoffGeneration = 0;
  
  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();
  
  PlaybackStatus _currentStatus = const PlaybackStatus();
  PlaybackState _intendedState = PlaybackState.idle;
  PlaybackTrack? _currentTrack;
  PlaybackTrack? _prewarmedTrack; // track currently cued in the inactive engine
  bool _disposed = false;
  int _playGeneration = 0;
  int _lastCompletedGeneration = -1;
  Timer? _handoffTimeout;
  
  HybridPlaybackEngine({
    PlaybackController? foregroundEngine,
    PlaybackController? backgroundEngine,
  })  : _foregroundEngine = foregroundEngine ?? MediaKitPlaybackEngine(),
        _backgroundEngine = backgroundEngine ?? NativeServicePlaybackEngine() {
      
    _foregroundEngine.statusStream.listen((status) {
       _handleSubStatus(EngineOwner.foreground, status);
    });
    
    _foregroundEngine.eventStream.listen((event) {
       _handleSubEvent(EngineOwner.foreground, event);
    });
    
    _backgroundEngine.statusStream.listen((status) {
       _handleSubStatus(EngineOwner.background, status);
    });
    
    _backgroundEngine.eventStream.listen((event) {
       _handleSubEvent(EngineOwner.background, event);
    });
    
    PipHandler.addActivityStoppedListener(_onActivityStopped);
    PipHandler.addActivityStartedListener(_onActivityStarted);
  }

  void _onActivityStopped() {
    _initiateHandoff(EngineOwner.background);
  }

  void _onActivityStarted() {
    _initiateHandoff(EngineOwner.foreground);
  }
  
  void _updateStatus(PlaybackStatus status) {
     if (_disposed) return;
     _currentStatus = status;
     _statusController.add(status);
  }
  
  void _handleSubStatus(EngineOwner source, PlaybackStatus status) {
     if (source != _owner) {
         if (status.state == PlaybackState.playing) {
             _log('Containment: Inactive engine $source emitted playing, pausing it.');
             final engine = source == EngineOwner.foreground ? _foregroundEngine : _backgroundEngine;
             engine.pause(caller: 'containment');
         }
         return;
     }
     if (_isTransferring) return;
     _updateStatus(status);
  }

  void _handleSubEvent(EngineOwner source, PlaybackEvent event) {
     if (event.type == PlaybackEventType.trackEnded) {
         if (_currentTrack == null || event.track?.id != _currentTrack!.id || _lastCompletedGeneration == _playGeneration) {
             return;
         }
         _lastCompletedGeneration = _playGeneration;
         
         if (_isTransferring) {
             _log('Source engine emitted trackEnded during transfer. Advancing queue.');
             _handoffGeneration++;
             _isTransferring = false;
         }
         if (!_disposed) _eventController.add(event);
         return;
     }

     if (source == _owner) {
         if (_isTransferring) return;
         if (!_disposed) _eventController.add(event);
     }
  }

  void _log(String msg) {
      debugPrint('HybridPlaybackEngine: $msg');
  }

  PlaybackController get _activeEngine => _owner == EngineOwner.foreground ? _foregroundEngine : _backgroundEngine;
  PlaybackController get _inactiveEngine => _owner == EngineOwner.foreground ? _backgroundEngine : _foregroundEngine;

  Future<void> _initiateHandoff(EngineOwner targetOwner) async {
      if (_owner == targetOwner) return;
      if (_disposed) return;
      if (_currentTrack == null) return;
      
      _handoffGeneration++;
      final myGen = _handoffGeneration;
      
      _log('Initiating handoff to $targetOwner (gen: $myGen) intendedState: $_intendedState');
      
      _isTransferring = true;
      _owner = targetOwner;
      
      final sourceEngine = _inactiveEngine;
      final destEngine = _activeEngine;
      
      try {
          // Snapshot the position before anything else.
          final pos = sourceEngine.currentStatus.position;
          _prewarmedTrack = null; // pre-warm superseded by real handoff
          
          if (_intendedState == PlaybackState.playing) {
              _log('Handoff: play(startAt: $pos) on $targetOwner');
              // Pause source and start destination atomically in parallel.
              // play(track, startAt: pos) passes the position through loadVideoById/
              // loadVideo in a single round-trip — no separate seekTo needed.
              await Future.wait([
                  sourceEngine.pause(caller: 'handoff'),
                  destEngine.play(_currentTrack!, startAt: pos),
              ]);
              
              if (_disposed || _handoffGeneration != myGen) return;
              
              await destEngine.setVolume(_currentStatus.volume);
              
              // Wait for destination to reach playing state.
              if (destEngine.currentStatus.state != PlaybackState.playing) {
                  try {
                      await destEngine.statusStream
                          .firstWhere((s) => s.state == PlaybackState.playing)
                          .timeout(const Duration(seconds: 5));
                  } catch (_) {
                      _log('Timeout waiting for destination to play');
                      // Invalidate generation first so late events are discarded.
                      _handoffGeneration++;
                      _isTransferring = false;
                      try {
                          await destEngine.pause(caller: 'timeout_cleanup')
                              .timeout(const Duration(seconds: 2));
                      } catch (_) {
                          _log('Failed to pause destination during timeout cleanup');
                      }
                      if (_handoffGeneration == myGen + 1) {
                          _intendedState = PlaybackState.paused;
                          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
                      }
                      return;
                  }
              }
          } else {
              // User paused/stopped — just stop the source, don't start destination.
              await sourceEngine.pause(caller: 'handoff');
              await destEngine.setVolume(_currentStatus.volume);
          }
          
      } catch (e) {
          _log('Handoff failed: $e');
      } finally {
          if (_handoffGeneration == myGen) {
              _isTransferring = false;
              _log('Handoff complete');
              _updateStatus(destEngine.currentStatus);
          }
      }
  }


  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  PlaybackStatus get currentStatus => _currentStatus;

  @override
  dynamic get renderer => _foregroundEngine.renderer;

  @override
  YoutubePlayerController? get youtubeController => _foregroundEngine.youtubeController;

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
      _playGeneration++;
      _currentTrack = track;
      _intendedState = PlaybackState.paused;
      await _activeEngine.prepare(track, position: position);
  }

  @override
  Future<void> play(PlaybackTrack track, {Duration startAt = Duration.zero}) async {
      _playGeneration++;
      _handoffGeneration++;
      _isTransferring = false;
      _currentTrack = track;
      _prewarmedTrack = null; // new track supersedes any prior pre-warm
      _intendedState = PlaybackState.playing;
      _inactiveEngine.stop();
      await _activeEngine.play(track, startAt: startAt);
      // Pre-warm the inactive engine so it has the video cued and ready.
      // This drastically reduces handoff latency on minimize.
      _prewarmInactiveEngine(track);
  }

  /// Silently cues the given track on the inactive engine so it is ready
  /// to take over on the next handoff without a full prepare round-trip.
  void _prewarmInactiveEngine(PlaybackTrack track) {
      final inactive = _inactiveEngine;
      _prewarmedTrack = track;
      // Use position=0 for pre-warm; actual position is seeked on handoff.
      inactive.prepare(track, position: Duration.zero).catchError((e) {
          _log('Pre-warm error (ignored): $e');
          if (_prewarmedTrack?.id == track.id) _prewarmedTrack = null;
      });
  }

  @override
  Future<void> pause({String caller = 'user'}) async {
      _intendedState = PlaybackState.paused;
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      await _activeEngine.pause(caller: caller);
  }

  @override
  Future<void> resume() async {
      _intendedState = PlaybackState.playing;
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.playing));
      await _activeEngine.resume();
  }

  @override
  Future<void> stop() async {
      _handoffGeneration++;
      _isTransferring = false;
      _intendedState = PlaybackState.idle;
      _currentTrack = null;
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.idle, track: null, activeVideoId: null));
      await _foregroundEngine.stop();
      await _backgroundEngine.stop();
  }

  @override
  Future<void> seekTo(Duration position) async {
      _updateStatus(_currentStatus.copyWith(position: position));
      await _activeEngine.seekTo(position);
  }

  @override
  Future<void> setVolume(double volume) async {
      _updateStatus(_currentStatus.copyWith(volume: volume));
      await _foregroundEngine.setVolume(volume);
      await _backgroundEngine.setVolume(volume);
  }

  @override
  Future<void> setSpeed(double speed) async {
      await _foregroundEngine.setSpeed(speed);
      await _backgroundEngine.setSpeed(speed);
  }

  @override
  void dispose() {
      _disposed = true;
      PipHandler.removeActivityStoppedListener(_onActivityStopped);
      PipHandler.removeActivityStartedListener(_onActivityStarted);
      _handoffTimeout?.cancel();
      _foregroundEngine.dispose();
      _backgroundEngine.dispose();
      _statusController.close();
      _eventController.close();
  }
}
