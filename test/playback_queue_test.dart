import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/models/playback_queue.dart';
import 'package:ppplayer/core/models/track.dart';

void main() {
  group('PlaybackQueue', () {
    final t1 = Track(spotifyId: '1', name: 't1', artistId: 'a1', artistName: 'a', albumId: 'b1', albumName: 'b');
    final t2 = Track(spotifyId: '2', name: 't2', artistId: 'a1', artistName: 'a', albumId: 'b1', albumName: 'b');
    final t3 = Track(spotifyId: '3', name: 't3', artistId: 'a1', artistName: 'a', albumId: 'b1', albumName: 'b');
    final tracks = [t1, t2, t3];

    test('next() goes to next index normally', () {
      var q = PlaybackQueue(tracks: tracks, currentIndex: 0);
      q = q.next();
      expect(q.currentIndex, 1);
    });

    test('next() at end stops when none repeat', () {
      var q = PlaybackQueue(tracks: tracks, currentIndex: 2);
      q = q.next();
      expect(q.currentIndex, 3); // out of bounds = stopped
    });

    test('next() wraps when repeat all', () {
      var q = PlaybackQueue(tracks: tracks, currentIndex: 2, repeatMode: RepeatMode.all);
      q = q.next();
      expect(q.currentIndex, 0);
    });

    test('next() stays when repeat one', () {
      var q = PlaybackQueue(tracks: tracks, currentIndex: 1, repeatMode: RepeatMode.one);
      q = q.next();
      expect(q.currentIndex, 1);
    });

    test('previous() goes to end if repeat all and at 0', () {
      var q = PlaybackQueue(tracks: tracks, currentIndex: 0, repeatMode: RepeatMode.all);
      q = q.previous(Duration.zero);
      expect(q.currentIndex, 2);
    });

    test('reorder() updates current index correctly moving down', () {
      var q = PlaybackQueue(tracks: [t1, t2, t3], currentIndex: 0);
      q = q.reorder(0, 2); // t1 moves to index 1 (t2, t1, t3)
      expect(q.tracks[1].spotifyId, '1');
      expect(q.currentIndex, 1);
    });

    test('reorder() updates current index correctly moving up', () {
      var q = PlaybackQueue(tracks: [t1, t2, t3], currentIndex: 2);
      q = q.reorder(2, 0); // t3 moves to index 0 (t3, t1, t2)
      expect(q.tracks[0].spotifyId, '3');
      expect(q.currentIndex, 0);
    });
  });
}
