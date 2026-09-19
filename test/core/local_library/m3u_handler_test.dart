import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/local_library/m3u_handler.dart';
import 'package:ppplayer/core/models/track.dart';

void main() {
  group('M3uHandler', () {
    test('parses basic paths correctly', () async {
      final content = '''
#EXTM3U
#EXTINF:233,Artist - Song
/absolute/path/to/song.mp3
relative/path/to/song2.mp3
''';

      final entries = await M3uHandler.parse(
        utf8.encode(content),
        sourceLocation: '/my/music/playlist.m3u',
      );

      expect(entries.length, 2);
      expect(entries[0].pathOrUri, '/absolute/path/to/song.mp3');
      expect(entries[0].title, 'Artist - Song');
      expect(entries[0].durationSeconds, 233);

      expect(entries[1].pathOrUri, '/my/music/relative/path/to/song2.mp3');
      expect(entries[1].title, isNull);
    });

    test('handles BOM and different line endings', () async {
      // simulate BOM + CRLF
      final content = '\uFEFF#EXTM3U\r\n#EXTINF:-1,Unknown\r\nfile.mp3\r\n';

      final entries = await M3uHandler.parse(
        utf8.encode(content),
        sourceLocation: '/dir/playlist.m3u',
      );

      expect(entries.length, 1);
      expect(entries[0].pathOrUri, '/dir/file.mp3');
      expect(entries[0].title, 'Unknown');
    });

    test('skips remote and HLS links', () async {
      final content = '''
#EXTM3U
http://example.com/stream.mp3
https://example.com/playlist.m3u8
file.mp3
''';

      final entries = await M3uHandler.parse(
        utf8.encode(content),
        sourceLocation: '/dir/playlist.m3u',
      );

      expect(entries.length, 1);
      expect(entries[0].pathOrUri, '/dir/file.mp3');
    });

    test('generates valid M3U8 content', () {
      final List<Track> queue = [
        Track(
          spotifyId: '1',
          name: 'Song 1',
          artistId: '',
          artistName: '',
          localFilePath: '/my/music/song1.mp3',
          durationMs: 120000,
        ),
        Track(
          spotifyId: '2',
          name: 'Song 2',
          artistId: '',
          artistName: '',
          localFilePath: '/my/music/folder/song2.mp3',
        ),
        Track(
          spotifyId: '3',
          name: 'Song 3',
          artistId: '',
          artistName: '',
          localFilePath: '/other/path/song3.mp3',
        ),
      ];

      final output = M3uHandler.generate(
        queue,
        exportDestinationDir: '/my/music',
      );

      expect(output.content, contains('#EXTM3U'));
      expect(output.content, contains('#EXTINF:120, - Song 1'));
      expect(output.content, contains('song1.mp3'));
      expect(output.content, contains('folder/song2.mp3'));
      expect(
        output.content,
        contains('/other/path/song3.mp3'),
      ); // Falls back to absolute
      expect(output.skippedCount, 0);
    });
  });
}
