import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../db/app_database.dart';
import 'm3u_parser.dart';

import 'package:http/http.dart' as http;

final networkStreamServiceProvider = Provider<NetworkStreamService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return NetworkStreamService(db);
});

class NetworkStreamService {
  final AppDatabase _db;


  NetworkStreamService(this._db);

  /// Analyzes a URL to see if it's a playlist or a direct stream.
  /// If it's a playlist, parses it and returns the list of channels.
  /// If it's a direct stream or HLS manifest, returns a single channel item representing the stream itself.
  Future<List<M3uChannel>> analyzeAndParseUrl(String url, {http.Client? client}) async {
    final normalizedUrl = M3uParser.normalizeUrl(url);

    try {
      final result = await M3uParser.fetchAndParse(normalizedUrl, client: client);
      
      switch (result.type) {
        case M3uType.channelList:
          return result.channels;
        case M3uType.hlsManifest:
        case M3uType.unknown:
          // Treat as a direct stream
          return [
            M3uChannel(
              title: 'Network Stream',
              url: normalizedUrl,
            )
          ];
      }
    } catch (e) {
      // If parsing fails (e.g., because it's a raw video file and bounded bytes didn't fail it), 
      // treat as a direct stream.
      return [
        M3uChannel(
          title: 'Network Stream',
          url: normalizedUrl,
        )
      ];
    }
  }

  /// Saves a parsed playlist into the database, clearing old channels for the same playlist.
  Future<int> savePlaylist(String title, String sourceUrl, List<M3uChannel> channels) async {
    return await _db.transaction(() async {
      // Check if playlist already exists by URI
      final existingPlaylists = await (_db.select(_db.streamPlaylists)
            ..where((t) => t.sourceUri.equals(sourceUrl)))
          .get();

      int playlistId;
      if (existingPlaylists.isNotEmpty) {
        playlistId = existingPlaylists.first.id;
        
        // Update playlist metadata
        await (_db.update(_db.streamPlaylists)
              ..where((t) => t.id.equals(playlistId)))
            .write(StreamPlaylistsCompanion(
              lastRefreshed: drift.Value(DateTime.now()),
            ));
      } else {
        playlistId = await _db.into(_db.streamPlaylists).insert(
              StreamPlaylistsCompanion.insert(
                title: title,
                sourceKind: 'url',
                sourceUri: sourceUrl,
                lastRefreshed: drift.Value(DateTime.now()),
              ),
            );
      }

      // Fetch existing channels to preserve IDs
      final existingChannels = await (_db.select(_db.streamChannels)
            ..where((t) => t.playlistId.equals(playlistId)))
          .get();

      final existingByUrl = {for (var c in existingChannels) c.streamUrl: c};
      final urlsToKeep = <String>{};

      var index = 0;
      final inserts = <StreamChannelsCompanion>[];

      for (final c in channels) {
        urlsToKeep.add(c.url);
        final existing = existingByUrl[c.url];

        if (existing != null) {
          // Update existing channel
          await (_db.update(_db.streamChannels)..where((t) => t.id.equals(existing.id))).write(
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
          inserts.add(StreamChannelsCompanion.insert(
            playlistId: playlistId,
            title: c.title,
            streamUrl: c.url,
            tvgId: drift.Value(c.tvgId),
            logo: drift.Value(c.tvgLogo),
            groupTitle: drift.Value(c.groupTitle),
            position: index,
          ));
        }
        index++;
      }

      // Delete removed channels
      for (final old in existingChannels) {
        if (!urlsToKeep.contains(old.streamUrl)) {
          await (_db.delete(_db.streamChannels)..where((t) => t.id.equals(old.id))).go();
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
    return (_db.select(_db.streamChannels)
          ..where((t) => t.playlistId.equals(playlistId)))
        .watch();
  }

  Future<void> deletePlaylist(int playlistId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.streamChannels)
            ..where((t) => t.playlistId.equals(playlistId)))
          .go();
      await (_db.delete(_db.streamPlaylists)
            ..where((t) => t.id.equals(playlistId)))
          .go();
    });
  }
}
