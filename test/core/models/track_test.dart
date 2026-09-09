import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/models/track.dart';

void main() {
  group('Track Serialization / Cache Resources', () {
    test('Track serializes and deserializes correctly', () {
      final track = Track(
        spotifyId: '123',
        name: 'Test Track',
        artistId: 'art1',
        artistName: 'Artist 1',
        albumName: 'Test Album',
        albumId: '456',
        durationMs: 200000,
        albumImage: 'https://example.com/image.jpg',
        isFavorite: false,
      );

      final json = track.toJson();
      final decoded = Track.fromJson(json);

      expect(decoded.spotifyId, '123');
      expect(decoded.name, 'Test Track');
      expect(decoded.artistName, 'Artist 1');
      expect(decoded.albumName, 'Test Album');
      expect(decoded.albumId, '456');
      expect(decoded.durationMs, 200000);
      expect(decoded.albumImage, 'https://example.com/image.jpg');
      expect(decoded.isFavorite, false);
    });
  });
}
