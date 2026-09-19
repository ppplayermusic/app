import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/models/track.dart';

void main() {
  test('Track.fromJson correctly falls back to legacy isLiveStream and maps liveStatus', () {
    final legacyJsonLive = {
      'spotifyId': 'stream:1',
      'name': 'Test',
      'artistId': 'stream',
      'artistName': 'Test',
      'isLiveStream': true
    };
    
    final legacyJsonUnknown = {
      'spotifyId': 'stream:2',
      'name': 'Test2',
      'artistId': 'stream',
      'artistName': 'Test2',
      'isLiveStream': false
    };

    final modernJsonLive = {
      'spotifyId': 'stream:3',
      'name': 'Test3',
      'artistId': 'stream',
      'artistName': 'Test3',
      'liveStatus': 1
    };

    final track1 = Track.fromJson(legacyJsonLive);
    expect(track1.liveStatus, StreamLiveStatus.live);

    final track2 = Track.fromJson(legacyJsonUnknown);
    expect(track2.liveStatus, StreamLiveStatus.unknown);

    final track3 = Track.fromJson(modernJsonLive);
    expect(track3.liveStatus, StreamLiveStatus.live);
  });
}
