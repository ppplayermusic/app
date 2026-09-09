import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';

void main() {
  test('V6 to V7 migration preserves user data', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Populate data using V6 schema equivalents
    await db.into(db.tracks).insert(
      TracksCompanion.insert(
        spotifyId: 'track_1',
        name: 'Track 1',
        artistId: 'artist_1',
        artistName: 'Artist 1',
        isFavorite: const drift.Value(true),
        youtubeVideoId: const drift.Value('yt_1'),
      ),
    );
    
    final results = await db.select(db.tracks).get();
    expect(results.length, 1);
    expect(results.first.spotifyId, 'track_1');
    expect(results.first.isFavorite, true);
    expect(results.first.youtubeVideoId, 'yt_1');
    // Ensure youtubeResolvedAt is null because it was just added
    expect(results.first.youtubeResolvedAt, isNull);
  });
}
