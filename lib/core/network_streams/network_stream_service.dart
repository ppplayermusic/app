import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../db/app_database.dart';
import 'playlist_parser.dart';
import '../services/secure_credentials_service.dart';

import 'package:http/http.dart' as http;

class YoutubeApiKeyMissingException implements Exception {
  final String message;
  YoutubeApiKeyMissingException([this.message = 'YouTube API Key is missing']);
  @override
  String toString() => message;
}

final networkStreamServiceProvider = Provider<NetworkStreamService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final secureCredentialsService = ref.watch(secureCredentialsProvider);
  return NetworkStreamService(db, secureCredentialsService);
});

class NetworkStreamService {
  final AppDatabase _db;
  final SecureCredentialsService _secureCredentialsService;

  NetworkStreamService(this._db, this._secureCredentialsService);

  /// Analyzes a URL to see if it's a playlist or a direct stream.
  /// If it's a playlist, parses it and returns the list of channels.
  /// If it's a direct stream or HLS manifest, returns a single channel item representing the stream itself.
  Future<List<PlaylistItem>> analyzeAndParseUrl(
    String url, {
    http.Client? client,
  }) async {
    final normalizedUrl = PlaylistParser.normalizeUrl(url);
    
    // Check if it's a YouTube playlist URL
    final uri = Uri.tryParse(normalizedUrl);
    if (uri != null && 
        (uri.host == 'youtube.com' || uri.host == 'www.youtube.com' || uri.host == 'm.youtube.com' || uri.host == 'music.youtube.com' || uri.host == 'youtu.be')) {
      // It can be /playlist?list=... or /watch?v=...&list=...
      if (uri.queryParameters.containsKey('list')) {
        final playlistId = uri.queryParameters['list']!;
        return _fetchYoutubePlaylist(playlistId, client: client);
      }
    }

    try {
      final result = await PlaylistParser.fetchAndParse(
        normalizedUrl,
        client: client,
      );

      switch (result.type) {
        case PlaylistType.channelList:
          return result.channels;
        case PlaylistType.hlsManifest:
        case PlaylistType.unknown:
          // Treat as a direct stream
          return [PlaylistItem(title: 'Stream 1', url: normalizedUrl)];
      }
    } catch (e) {
      // If parsing fails (e.g., because it's a raw video file and bounded bytes didn't fail it),
      // treat as a direct stream.
      return [PlaylistItem(title: 'Stream 1', url: normalizedUrl)];
    }
  }

  Future<List<PlaylistItem>> _fetchYoutubePlaylist(String playlistId, {http.Client? client}) async {
    final apiKey = await _secureCredentialsService.readYoutubeApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw YoutubeApiKeyMissingException('A custom YouTube API Key is required to import playlists. Please add it in Settings.');
    }

    final localClient = client ?? http.Client();
    try {
      final List<PlaylistItem> channels = [];
      String? pageToken;
      
      do {
        final uri = Uri.https('www.googleapis.com', '/youtube/v3/playlistItems', {
          'part': 'snippet',
          'playlistId': playlistId,
          'maxResults': '50',
          if (pageToken != null) 'pageToken': pageToken,
          'key': apiKey,
        });

        final response = await localClient.get(uri);
        
        if (response.statusCode == 403) {
          throw Exception('YouTube API Quota exceeded or invalid API Key.');
        } else if (response.statusCode == 404) {
          throw Exception('YouTube Playlist not found. It might be private.');
        } else if (response.statusCode != 200) {
          throw Exception('YouTube API error: ${response.statusCode}');
        }

        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];

        for (final item in items) {
          final snippet = item['snippet'];
          if (snippet == null) continue;
          
          final title = snippet['title'] as String?;
          // Skip deleted or private videos (title is usually "Private video" or "Deleted video")
          if (title == null || title == 'Private video' || title == 'Deleted video') continue;
          
          final resourceId = snippet['resourceId'];
          if (resourceId == null || resourceId['kind'] != 'youtube#video') continue;
          
          final videoId = resourceId['videoId'] as String?;
          if (videoId == null) continue;
          
          final thumbnails = snippet['thumbnails'];
          String? logoUrl;
          if (thumbnails != null) {
             logoUrl = thumbnails['maxres']?['url'] ?? thumbnails['high']?['url'] ?? thumbnails['medium']?['url'] ?? thumbnails['default']?['url'];
          }

          channels.add(PlaylistItem(
            title: title,
            url: 'https://youtube.com/watch?v=$videoId',
            tvgLogo: logoUrl,
            groupTitle: snippet['channelTitle'] as String?,
          ));
        }

        pageToken = data['nextPageToken'] as String?;
      } while (pageToken != null);

      if (channels.isEmpty) {
        throw Exception('No accessible videos found in this YouTube playlist.');
      }

      return channels;
    } finally {
      if (client == null) {
        localClient.close();
      }
    }
  }

  /// Saves a parsed playlist into the database, clearing old channels for the same playlist.
  Future<int> savePlaylist(
    String title,
    String sourceUrl,
    List<PlaylistItem> channels,
  ) async {
    return await _db.transaction(() async {
      // Check if playlist already exists by URI
      final existingPlaylists = await (_db.select(
        _db.streamPlaylists,
      )..where((t) => t.sourceUri.equals(sourceUrl))).get();

      int playlistId;
      if (existingPlaylists.isNotEmpty) {
        playlistId = existingPlaylists.first.id;

        // Update playlist metadata
        await (_db.update(
          _db.streamPlaylists,
        )..where((t) => t.id.equals(playlistId))).write(
          StreamPlaylistsCompanion(lastRefreshed: drift.Value(DateTime.now())),
        );
      } else {
        playlistId = await _db
            .into(_db.streamPlaylists)
            .insert(
              StreamPlaylistsCompanion.insert(
                title: title,
                sourceKind: 'url',
                sourceUri: sourceUrl,
                lastRefreshed: drift.Value(DateTime.now()),
              ),
            );
      }

      // Fetch existing channels to preserve IDs
      final existingChannels = await (_db.select(
        _db.streamChannels,
      )..where((t) => t.playlistId.equals(playlistId))).get();

      final existingByUrl = {for (var c in existingChannels) c.streamUrl: c};
      final urlsToKeep = <String>{};

      var index = 0;
      final inserts = <StreamChannelsCompanion>[];

      for (final c in channels) {
        urlsToKeep.add(c.url);
        final existing = existingByUrl[c.url];

        if (existing != null) {
          // Update existing channel
          await (_db.update(
            _db.streamChannels,
          )..where((t) => t.id.equals(existing.id))).write(
            StreamChannelsCompanion(
              title: drift.Value(c.title),
              tvgId: drift.Value(c.tvgId),
              logo: drift.Value(c.tvgLogo),
              groupTitle: drift.Value(c.groupTitle),
              position: drift.Value(index),
            ),
          );
        } else {
          // Insert new channel
          inserts.add(
            StreamChannelsCompanion.insert(
              playlistId: playlistId,
              title: c.title,
              streamUrl: c.url,
              tvgId: drift.Value(c.tvgId),
              logo: drift.Value(c.tvgLogo),
              groupTitle: drift.Value(c.groupTitle),
              position: index,
            ),
          );
        }
        index++;
      }

      // Delete removed channels
      for (final old in existingChannels) {
        if (!urlsToKeep.contains(old.streamUrl)) {
          await (_db.delete(
            _db.streamChannels,
          )..where((t) => t.id.equals(old.id))).go();
        }
      }

      if (inserts.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(_db.streamChannels, inserts);
        });
      }

      return playlistId;
    });
  }

  Stream<List<StreamPlaylist>> watchPlaylists() {
    return _db.select(_db.streamPlaylists).watch();
  }

  Stream<List<StreamChannel>> watchChannelsForPlaylist(int playlistId) {
    return (_db.select(
      _db.streamChannels,
    )..where((t) => t.playlistId.equals(playlistId))).watch();
  }

  Future<void> deletePlaylist(int playlistId) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.streamChannels,
      )..where((t) => t.playlistId.equals(playlistId))).go();
      await (_db.delete(
        _db.streamPlaylists,
      )..where((t) => t.id.equals(playlistId))).go();
    });
  }

  Stream<StreamPlaylist> watchPlaylist(int playlistId) {
    return (_db.select(_db.streamPlaylists)..where((t) => t.id.equals(playlistId))).watchSingle();
  }

  Future<void> updatePlaylist(int playlistId, String newTitle) async {
    await (_db.update(_db.streamPlaylists)..where((t) => t.id.equals(playlistId))).write(
      StreamPlaylistsCompanion(title: drift.Value(newTitle)),
    );
  }

  Future<void> updateChannel(int channelId, String newTitle, String newUrl) async {
    await (_db.update(_db.streamChannels)..where((t) => t.id.equals(channelId))).write(
      StreamChannelsCompanion(
        title: drift.Value(newTitle),
        streamUrl: drift.Value(newUrl),
      ),
    );
  }

  Future<void> deleteChannel(int channelId) async {
    await (_db.delete(_db.streamChannels)..where((t) => t.id.equals(channelId))).go();
  }
}
