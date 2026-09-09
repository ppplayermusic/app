import 'dart:math';
import './track.dart';

enum RepeatMode { none, one, all }

/// Pure deterministic playback queue model.
class PlaybackQueue {
  final List<Track> tracks;
  final int currentIndex;
  final RepeatMode repeatMode;
  final bool isShuffled;

  const PlaybackQueue({
    this.tracks = const [],
    this.currentIndex = 0,
    this.repeatMode = RepeatMode.none,
    this.isShuffled = false,
  });

  factory PlaybackQueue.fromJson(Map<String, dynamic> json) {
    return PlaybackQueue(
      tracks: (json['tracks'] as List<dynamic>?)?.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      currentIndex: json['currentIndex'] as int? ?? 0,
      repeatMode: RepeatMode.values[json['repeatMode'] as int? ?? 0],
      isShuffled: json['isShuffled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map((e) => e.toJson()).toList(),
      'currentIndex': currentIndex,
      'repeatMode': repeatMode.index,
      'isShuffled': isShuffled,
    };
  }

  Track? get currentTrack =>
      tracks.isNotEmpty && currentIndex >= 0 && currentIndex < tracks.length
          ? tracks[currentIndex]
          : null;

  PlaybackQueue copyWith({
    List<Track>? tracks,
    int? currentIndex,
    RepeatMode? repeatMode,
    bool? isShuffled,
  }) {
    return PlaybackQueue(
      tracks: tracks ?? this.tracks,
      currentIndex: currentIndex ?? this.currentIndex,
      repeatMode: repeatMode ?? this.repeatMode,
      isShuffled: isShuffled ?? this.isShuffled,
    );
  }

  /// Calculates the next state in the queue depending on repeat and shuffle modes.
  PlaybackQueue next() {
    if (tracks.isEmpty) return this;

    if (repeatMode == RepeatMode.one) {
      return this; // Stay on the same track
    }

    if (isShuffled && tracks.length > 1) {
      int nextIdx;
      // Simple shuffle: pick random index avoiding current
      do {
        nextIdx = Random().nextInt(tracks.length);
      } while (nextIdx == currentIndex);
      return copyWith(currentIndex: nextIdx);
    }

    int nextIdx = currentIndex + 1;
    if (nextIdx >= tracks.length) {
      if (repeatMode == RepeatMode.all) {
        nextIdx = 0;
      } else {
        // Stop playback by moving to an out-of-bounds index
        return copyWith(currentIndex: tracks.length); 
      }
    }

    return copyWith(currentIndex: nextIdx);
  }

  /// Calculates the previous track, with generic previous rules.
  PlaybackQueue previous(Duration currentPosition) {
    if (tracks.isEmpty) return this;

    // Restart track if past 3 seconds
    if (currentPosition.inSeconds > 3) {
      return this;
    }

    int prevIdx = currentIndex - 1;
    if (prevIdx < 0) {
      if (repeatMode == RepeatMode.all) {
        prevIdx = tracks.length - 1;
      } else {
        prevIdx = 0;
      }
    }

    return copyWith(currentIndex: prevIdx);
  }

  PlaybackQueue add(Track track) {
    // Generate a unique ID for this instance in the queue
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(10000);
    final uniqueId = '${track.spotifyId}_${timestamp}_$random';
    final t = track.copyWith(queueItemId: uniqueId);
    
    final newTracks = List<Track>.from(tracks);
    if (t.queueOrigin != QueueItemOrigin.autoplay) {
      int insertIndex = newTracks.length;
      for (int i = currentIndex + 1; i < newTracks.length; i++) {
        if (newTracks[i].queueOrigin == QueueItemOrigin.autoplay) {
          insertIndex = i;
          break;
        }
      }
      newTracks.insert(insertIndex, t);
    } else {
      newTracks.add(t);
    }
    
    return copyWith(tracks: newTracks);
  }

  PlaybackQueue insertNext(Track track) {
    if (tracks.isEmpty) return add(track);
    final insertIdx = (currentIndex + 1).clamp(0, tracks.length);
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(10000);
    final uniqueId = '${track.spotifyId}_${timestamp}_$random';
    final newTracks = [...tracks]..insert(insertIdx, track.copyWith(queueItemId: uniqueId));
    return copyWith(tracks: newTracks);
  }

  PlaybackQueue removeAt(int index) {
    if (index < 0 || index >= tracks.length) return this;

    final newTracks = [...tracks]..removeAt(index);
    int newIndex = currentIndex;

    if (index < currentIndex) {
      newIndex -= 1;
    } else if (index == currentIndex) {
      if (newTracks.isEmpty) {
        newIndex = 0;
      } else if (newIndex >= newTracks.length) {
        newIndex = newTracks.length - 1;
      }
    }

    return copyWith(
      tracks: newTracks,
      currentIndex: newIndex.clamp(0, newTracks.isEmpty ? 0 : newTracks.length - 1),
    );
  }

  PlaybackQueue reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    if (oldIndex < 0 || oldIndex >= tracks.length || newIndex < 0 || newIndex > tracks.length) {
       return this;
    }

    final newTracks = [...tracks];
    final item = newTracks.removeAt(oldIndex);
    newTracks.insert(newIndex, item);

    int newCurrentIndex = currentIndex;
    if (currentIndex == oldIndex) {
      newCurrentIndex = newIndex;
    } else if (oldIndex < currentIndex && newIndex >= currentIndex) {
      newCurrentIndex--;
    } else if (oldIndex > currentIndex && newIndex <= currentIndex) {
      newCurrentIndex++;
    }

    return copyWith(tracks: newTracks, currentIndex: newCurrentIndex);
  }

  /// Helpers for UI state
  int? get nextIndex {
    final nextState = next();
    if (nextState.currentIndex >= tracks.length) return null;
    return nextState.currentIndex;
  }

  int? get previousIndex {
    final prevState = previous(Duration.zero);
    return prevState.currentIndex;
  }
}
