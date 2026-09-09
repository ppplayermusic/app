import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/playback/playback_service.dart';
import 'package:ppplayer/core/api/spotify_repository.dart';
import 'package:ppplayer/core/api/api_providers.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/models/playback_queue.dart';
import 'package:ppplayer/core/cache/cache_config.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------

class FakePlaybackService implements PlaybackService {
  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<List<String>> resolveCandidates(Track track, String? regionCode) async {
    return ['test_video_id'];
  }

  @override
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {}

  @override
  Future<void> recordPlay(Track track) async {}

  @override
  Future<void> toggleFavorite(Track track, bool isFavorite) async {}

  @override
  Future<void> prefetchNext(Track track, String? regionCode) async {}

  @override
  Future<List<Track>> getPlaylistTracks(int playlistId) async => [];

  @override
  Future<List<Track>> getRadioTracks(String artistId) async => [];

  @override
  Future<List<Track>> getRecentlyPlayed({int limit = 50}) async => [];
}

class FakePlaybackController implements PlaybackController {
  final _statusController = StreamController<PlaybackStatus>.broadcast();
  
  void emitStatus(PlaybackStatus s) => _statusController.add(s);

  @override
  dynamic get renderer => null;

  @override
  Future<void> setSpeed(double speed) async {}

  @override
  yt.YoutubePlayerController? get youtubeController => null;

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => const Stream.empty();

  @override
  PlaybackStatus get currentStatus => const PlaybackStatus();

  @override
  Future<void> play(PlaybackTrack track) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> seekTo(Duration position) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> dispose() async {}
}

class FakeSpotifyRepository implements SpotifyRepository {
  List<Track> recommendationsToReturn = [];
  int getRecommendationsCallCount = 0;

  @override
  Stream<CacheResult<List<Track>>> watchRecommendations({
    String? seedArtistId, 
    String? seedTrackId, 
    String? seedGenres, 
    int limit = 20
  }) async* {
    getRecommendationsCallCount++;
    yield CacheResult(
      data: recommendationsToReturn,
      source: CacheSource.network,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() {
    return SettingsState(
      selectedCountry: 'US',
      autoplayEnabled: true,
      isLoaded: true,
    );
  }
}

void main() {
  late ProviderContainer container;
  late FakePlaybackController playbackController;
  late FakePlaybackService playbackService;
  late FakeSpotifyRepository spotifyRepository;

  setUp(() {
    playbackController = FakePlaybackController();
    playbackService = FakePlaybackService();
    spotifyRepository = FakeSpotifyRepository();

    container = ProviderContainer(
      overrides: [
        playbackControllerProvider.overrideWithValue(playbackController),
        playbackServiceProvider.overrideWithValue(playbackService),
        spotifyRepositoryProvider.overrideWithValue(spotifyRepository),
        settingsProvider.overrideWith(FakeSettingsNotifier.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Track _createTrack(String id, {QueueItemOrigin origin = QueueItemOrigin.context}) {
    return Track(
      spotifyId: id,
      name: 'Track $id',
      artistId: 'art_$id',
      artistName: 'Artist $id',
      queueOrigin: origin,
    );
  }

  test('Autoplay fetches recommendations when approaching end of queue', () async {
    final notifier = container.read(playerProvider.notifier);
    
    final t1 = _createTrack('1');
    final t2 = _createTrack('2');
    final t3 = _createTrack('3');

    spotifyRepository.recommendationsToReturn = [
      _createTrack('4'),
      _createTrack('5'),
    ];

    // Start playback (queue size = 3, index = 0, remaining = 2)
    // Threshold is <= 15, so it should fetch immediately
    await notifier.playTrack(t1, queue: [t1, t2, t3]);

    // Give microtasks time to run
    await Future.delayed(Duration.zero);

    expect(spotifyRepository.getRecommendationsCallCount, 1);
    
    final finalQueue = container.read(playerProvider).playbackQueue.tracks;
    expect(finalQueue.length, 5); // 3 original + 2 recommendations
    expect(finalQueue[3].spotifyId, '4');
    expect(finalQueue[3].queueOrigin, QueueItemOrigin.autoplay);
  });

  test('Autoplay deduplicates tracks already in queue or seen in session', () async {
    final notifier = container.read(playerProvider.notifier);
    
    final t1 = _createTrack('1');

    spotifyRepository.recommendationsToReturn = [
      _createTrack('1'), // duplicate with current queue
      _createTrack('2'), // new
    ];

    await notifier.playTrack(t1);
    await Future.delayed(Duration.zero);

    expect(spotifyRepository.getRecommendationsCallCount, 1);
    
    final queue = container.read(playerProvider).playbackQueue.tracks;
    expect(queue.length, 2); 
    expect(queue[1].spotifyId, '2');

    // Skip to track 2, this advances index and should trigger another fetch
    // But since remaining <= 15 still holds, it fetches again
    spotifyRepository.recommendationsToReturn = [
      _createTrack('2'), // seen in session / currently in queue
      _createTrack('3'), // new
    ];

    notifier.skipNext();
    await Future.delayed(Duration.zero);
    
    expect(spotifyRepository.getRecommendationsCallCount, 2);
    final queue2 = container.read(playerProvider).playbackQueue.tracks;
    expect(queue2.length, 3);
    expect(queue2.last.spotifyId, '3');
  });

  test('User tracks are placed before autoplay tracks when adding to queue', () async {
    final notifier = container.read(playerProvider.notifier);
    
    final t1 = _createTrack('1');
    spotifyRepository.recommendationsToReturn = [
      _createTrack('A1'),
      _createTrack('A2'),
    ];

    await notifier.playTrack(t1);
    await Future.delayed(Duration.zero);
    
    // Queue is [1, A1, A2]
    expect(container.read(playerProvider).playbackQueue.tracks.length, 3);
    
    // User explicitly adds a track
    final u1 = _createTrack('U1');
    notifier.addToQueue(u1);
    
    final queue = container.read(playerProvider).playbackQueue.tracks;
    // Expected: [1, U1, A1, A2]
    expect(queue.length, 4);
    expect(queue[0].spotifyId, '1');
    expect(queue[1].spotifyId, 'U1');
    expect(queue[2].spotifyId, 'A1');
    expect(queue[3].spotifyId, 'A2');
  });

  test('Does not autoplay if Repeat Mode is not none', () async {
    final notifier = container.read(playerProvider.notifier);
    
    // Cycle repeat mode to RepeatMode.all
    await notifier.cycleRepeat();
    
    final t1 = _createTrack('1');
    spotifyRepository.recommendationsToReturn = [_createTrack('2')];

    await notifier.playTrack(t1);
    await Future.delayed(Duration.zero);
    
    expect(spotifyRepository.getRecommendationsCallCount, 0);
    expect(container.read(playerProvider).playbackQueue.tracks.length, 1);
  });
}
