import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import 'package:ppplayer/core/api/spotify_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:drift/native.dart';
import 'persistence_test.mocks.dart';

@GenerateMocks([SpotifyClient])
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Fresh repository/container + reopened DB persistence verification', () async {
    final mockSpotify = MockSpotifyClient();
    
    // Setup first instance
    final container1 = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        spotifyClientProvider.overrideWithValue(mockSpotify),
      ],
    );

    when(mockSpotify.getArtist('test_artist_1'))
        .thenAnswer((_) async => {'id': 'test_artist_1', 'name': 'Mock Artist'});

    final repo1 = container1.read(spotifyRepositoryProvider);
    
    // Populate cache
    final data1 = await repo1.watchArtist('test_artist_1').firstWhere((r) => r.data.isNotEmpty);
    expect(data1.data['name'], 'Mock Artist');
    
    // Verify network call was made
    verify(mockSpotify.getArtist('test_artist_1')).called(1);

    // Dispose first instance (simulates memory clearing)
    container1.dispose();

    // Setup second instance with SAME database
    final container2 = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db), // Same DB instance (simulates persistent storage)
        spotifyClientProvider.overrideWithValue(mockSpotify),
      ],
    );

    final repo2 = container2.read(spotifyRepositoryProvider);

    // Fetch same resource
    final data2 = await repo2.watchArtist('test_artist_1').firstWhere((r) => r.data.isNotEmpty);
    
    // Verify it was returned
    expect(data2.data['name'], 'Mock Artist');

    // Verify NO additional network call was made! (L2 Hit)
    verifyNever(mockSpotify.getArtist('test_artist_1'));
    
    container2.dispose();
  });
}
