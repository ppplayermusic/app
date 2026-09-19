import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

// Mocks to simulate the exact logic used in MediaKitPlaybackEngine

class TestPlaybackEngine {
  int _playGeneration = 0;
  int _mediaKitReadyGeneration = 0;
  bool stateIncomplete = true;

  bool isStaleMediaKitEvent() {
    // Current logic: block everything if generations don't match
    return _playGeneration != _mediaKitReadyGeneration;
  }

  // Simulate the async play() method with variable delay
  Future<void> playWithDelay(String uri, Duration delay) async {
    _playGeneration++;
    final myGen = _playGeneration;

    // Simulate valid initialization events firing DURING open()
    Future.delayed(delay ~/ 2, () {
      if (!isStaleMediaKitEvent()) {
        stateIncomplete = false;
      }
    });

    // Simulate await _player!.open(...)
    await Future.delayed(delay);

    // If the play call was superseded during await, abort
    if (_playGeneration != myGen) return;

    _mediaKitReadyGeneration = myGen;
  }
}

void main() {
  test(
    'Vulnerability 1: Old event arriving after new open() completes is accepted',
    () async {
      final engine = TestPlaybackEngine();
      await engine.playWithDelay(
        'http://source.a',
        const Duration(milliseconds: 10),
      );

      final playB = engine.playWithDelay(
        'http://source.b',
        const Duration(milliseconds: 50),
      );

      // Wait for B to fully open
      await playB;

      // Simulate an event from A that was deeply queued and arrives NOW
      final isStale = engine.isStaleMediaKitEvent();

      expect(
        isStale,
        isFalse,
        reason:
            'The event is accepted because the engine cannot distinguish origin after unlocking',
      );
    },
  );

  test(
    'Race Condition: Two opens overlapping and completing out of order',
    () async {
      final engine = TestPlaybackEngine();

      // Start A (takes 100ms)
      final playA = engine.playWithDelay(
        'http://source.a',
        const Duration(milliseconds: 100),
      );

      // Start B (takes 20ms) - supersedes A immediately in _playGeneration
      final playB = engine.playWithDelay(
        'http://source.b',
        const Duration(milliseconds: 20),
      );

      await playB;

      // B finishes first. B sets _mediaKitReadyGeneration = 2.
      expect(engine._mediaKitReadyGeneration, equals(2));
      expect(engine._playGeneration, equals(2));

      // Wait for A to finish
      await playA;

      // A finishes. A's myGen is 1. _playGeneration is 2.
      // A should abort and NOT change _mediaKitReadyGeneration.
      expect(
        engine._mediaKitReadyGeneration,
        equals(2),
        reason: 'A must not regress the ready generation',
      );
    },
  );

  test(
    'Vulnerability 2: Valid initialization events during open() are blocked, leaving state incomplete',
    () async {
      final engine = TestPlaybackEngine();

      // playWithDelay fires a valid event halfway through the open() process.
      await engine.playWithDelay(
        'http://source.a',
        const Duration(milliseconds: 50),
      );

      expect(
        engine.stateIncomplete,
        isTrue,
        reason:
            'The initialization events were blocked because _mediaKitReadyGeneration was not set yet',
      );
    },
  );
}
