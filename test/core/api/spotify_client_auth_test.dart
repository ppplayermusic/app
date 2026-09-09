import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import 'package:ppplayer/core/api/spotify_auth.dart';

class MockDio extends Mock implements Dio {}
class FakeSpotifyAuthHandler implements SpotifyAuthHandler {
  @override
  Future<String> getAccessToken() async {
    throw SpotifyAuthException('Failed to acquire token', Exception('Token failure'));
  }

  @override
  void invalidate() {}
}

void main() {
  group('SpotifyClient Auth Classification', () {
    late Dio dio;
    late FakeSpotifyAuthHandler fakeAuthHandler;
    late SpotifyClient client;
    
    setUp(() {
      dio = Dio();
      fakeAuthHandler = FakeSpotifyAuthHandler();
      client = SpotifyClient(dio, fakeAuthHandler, market: 'US');
    });

    test('Token endpoint failure throws SpotifyAuthException and does not return empty array', () async {
      // Attempt a call that has fallbacks, like popular tracks
      expect(
        () => client.getPopularTracks(),
        throwsA(isA<SpotifyAuthException>()),
      );
    });
  });
}
