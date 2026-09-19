import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';

void main() {
  test('PlaybackTrack correctly maps liveStatus from app layer to engine layer during source switching', () {
    final trackOnDemand = Track(
      spotifyId: 'id1',
      name: 'On Demand',
      artistId: '1',
      artistName: 'Artist 1',
      sourceType: TrackSourceType.networkStream,
      liveStatus: StreamLiveStatus.onDemand,
    );

    final trackLive = Track(
      spotifyId: 'id2',
      name: 'Live Stream',
      artistId: '2',
      artistName: 'Artist 2',
      sourceType: TrackSourceType.networkStream,
      liveStatus: StreamLiveStatus.live,
    );

    // Map to PlaybackTrack
    final playbackOnDemand = PlaybackTrack(
      id: trackOnDemand.spotifyId,
      title: trackOnDemand.name,
      artist: trackOnDemand.artistName,
      sourceType: PlaybackSourceType.networkStream,
      liveStatus: trackOnDemand.liveStatus == StreamLiveStatus.live
          ? PlaybackLiveStatus.live
          : trackOnDemand.liveStatus == StreamLiveStatus.onDemand
              ? PlaybackLiveStatus.onDemand
              : PlaybackLiveStatus.unknown,
    );

    final playbackLive = PlaybackTrack(
      id: trackLive.spotifyId,
      title: trackLive.name,
      artist: trackLive.artistName,
      sourceType: PlaybackSourceType.networkStream,
      liveStatus: trackLive.liveStatus == StreamLiveStatus.live
          ? PlaybackLiveStatus.live
          : trackLive.liveStatus == StreamLiveStatus.onDemand
              ? PlaybackLiveStatus.onDemand
              : PlaybackLiveStatus.unknown,
    );

    expect(playbackOnDemand.liveStatus, PlaybackLiveStatus.onDemand);
    expect(playbackLive.liveStatus, PlaybackLiveStatus.live);
  });
}
