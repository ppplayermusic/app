import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import 'package:ppplayer/core/api/spotify_auth.dart';

class MockSpotifyAuthHandler implements SpotifyAuthHandler {
  @override
  Future<String> getAccessToken() async => 'mock_token';

  @override
  void invalidate() {}
}

void main() {
  group('SpotifyClient Discovery Tests', () {
    late Dio dio;
    late SpotifyClient client;
    late List<RequestOptions> requests;
    late Map<String, dynamic> Function(RequestOptions) mockResponse;

    setUp(() {
      requests = [];
      dio = Dio();
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          try {
            final data = mockResponse(options);
            return handler.resolve(Response(requestOptions: options, data: data, statusCode: 200));
          } on DioException catch (e) {
            return handler.reject(e);
          } catch (e) {
            return handler.reject(DioException(requestOptions: options, error: e));
          }
        },
      ));
      client = SpotifyClient(dio, MockSpotifyAuthHandler(), market: 'US');
    });

    test('getPopularTracks handles 502, deduplicates, and limits', () async {
      int requestCount = 0;
      mockResponse = (options) {
        requestCount++;
        if (requestCount == 1) {
          throw DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 502),
          );
        }
        return {
          'tracks': {
            'items': [
              {'id': '1', 'name': 'Track 1'},
              {'id': '2', 'name': 'Track 2'},
              {'id': '1', 'name': 'Track 1 Duplicate'},
            ]
          }
        };
      };

      final tracks = await client.getPopularTracks(limit: 2);
      expect(tracks.length, 2);
      final ids = tracks.map((t) => t.spotifyId).toList();
      expect(ids.contains('1'), isTrue);
      expect(ids.contains('2'), isTrue);

      final hasTop50 = requests.any((r) => r.path.contains('37i9dQZEVXbMDoHDw22t9N'));
      expect(hasTop50, isFalse, reason: 'No hardcoded playlist should be used.');
    });

    test('getPopularTracks throws if all fail', () async {
      mockResponse = (options) {
        throw DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 404),
        );
      };

      expect(() => client.getPopularTracks(), throwsException);
    });

    test('getPopularTracks returns empty list legitimately', () async {
      mockResponse = (options) {
        return {
          'tracks': {'items': []}
        };
      };

      // Since all search queries return empty, it means none failed, so it shouldn't throw.
      final tracks = await client.getPopularTracks();
      expect(tracks, isEmpty);
    });

    test('searchTracks paginates requests above limit 10', () async {
      mockResponse = (options) {
        final offset = int.parse(options.queryParameters['offset']?.toString() ?? '0');
        final limit = int.parse(options.queryParameters['limit']?.toString() ?? '10');
        return {
          'tracks': {
            'items': List.generate(limit, (i) => {'id': '${offset + i}', 'name': 'T'})
          }
        };
      };

      final tracks = await client.searchTracks('query', limit: 15);
      expect(tracks.length, 15);
      expect(requests.length, 2);
      expect(requests[0].queryParameters['limit'], 10);
      expect(requests[0].queryParameters['offset'], 0);
      expect(requests[1].queryParameters['limit'], 5);
      expect(requests[1].queryParameters['offset'], 10);
    });

    test('getRecommendations never calls /recommendations or /top-tracks', () async {
      mockResponse = (options) {
        if (options.path.contains('artists/a1')) {
          return {'name': 'Artist One'};
        }
        return {
          'tracks': {
            'items': [{'id': '1', 'name': 'T1'}]
          }
        };
      };

      await client.getRecommendations(seedArtistId: 'a1', limit: 1);
      
      final urls = requests.map((r) => r.path).toList();
      expect(urls.any((url) => url.contains('recommendations')), isFalse);
      expect(urls.any((url) => url.contains('top-tracks')), isFalse);
      expect(urls.any((url) => url.contains('search')), isTrue);
    });

    test('getNewReleases uses search and avoids /browse/new-releases', () async {
      mockResponse = (options) {
        return {
          'albums': {
            'items': [{'id': 'a1', 'release_date': '2026-01-01'}]
          }
        };
      };

      await client.getNewReleases(limit: 5);
      
      final urls = requests.map((r) => r.path).toList();
      expect(urls.any((url) => url.contains('browse/new-releases')), isFalse);
      expect(urls.any((url) => url.contains('search')), isTrue);
    });

    test('getBrowseCategories returns PPPlayer defined categories without API calls', () async {
      final categories = await client.getBrowseCategories();
      expect(categories.isNotEmpty, isTrue);
      expect(requests, isEmpty);
    });

    test('getCategoryPlaylists maps local ID to search query without /browse', () async {
      mockResponse = (options) {
        return {
          'playlists': {
            'items': [{'id': 'p1', 'name': 'Playlist 1'}]
          }
        };
      };

      final playlists = await client.getCategoryPlaylists('pop', limit: 2);
      expect(playlists.length, 1); // 1 mock item returned per query.

      final urls = requests.map((r) => r.path).toList();
      expect(urls.any((url) => url.contains('browse/categories')), isFalse);
      expect(urls.any((url) => url.contains('search')), isTrue);
    });
    group('Error Classification', () {
      test('401 throws SpotifyAuthException immediately', () async {
        mockResponse = (options) {
          throw DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
          );
        };
        expect(() => client.searchTracks('test'), throwsA(isA<SpotifyAuthException>()));
      });

      test('403 does not become SpotifyAuthException', () async {
        mockResponse = (options) {
          throw DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 403),
          );
        };
        expect(() => client.searchTracks('test'), throwsA(isA<DioException>()));
      });

      test('429 retries within bound', () async {
        int calls = 0;
        mockResponse = (options) {
          calls++;
          if (calls == 1) {
            throw DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options, 
                statusCode: 429,
                headers: Headers.fromMap({'retry-after': ['1']}),
              ),
            );
          }
          return {
            'tracks': {'items': []}
          };
        };
        await client.searchTracks('test');
        expect(calls, 2);
      });

      test('429 twice terminates', () async {
        int calls = 0;
        mockResponse = (options) {
          calls++;
          throw DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options, 
              statusCode: 429,
              headers: Headers.fromMap({'retry-after': ['1']}),
            ),
          );
        };
        await expectLater(() => client.searchTracks('test'), throwsA(isA<DioException>()));
        expect(calls, 2);
      });

      test('502 exactly one retry', () async {
        int calls = 0;
        mockResponse = (options) {
          calls++;
          if (calls == 1) {
            throw DioException(
              requestOptions: options,
              response: Response(requestOptions: options, statusCode: 502),
            );
          }
          return {
            'tracks': {'items': []}
          };
        };
        await client.searchTracks('test');
        expect(calls, 2);
      });

      test('502 twice fails', () async {
        int calls = 0;
        mockResponse = (options) {
          calls++;
          throw DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 502),
          );
        };
        await expectLater(() => client.searchTracks('test'), throwsA(isA<DioException>()));
        expect(calls, 2);
      });
      
      test('200 [] valid empty', () async {
        mockResponse = (options) {
          return {
            'tracks': {'items': []}
          };
        };
        final res = await client.searchTracks('test');
        expect(res, isEmpty);
      });
    });
  });
}
