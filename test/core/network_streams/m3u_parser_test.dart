import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ppplayer/core/network_streams/m3u_parser.dart';

class MockClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest request) handler;

  MockClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) => handler(request);
}

void main() {
  group('M3uParser', () {
    test('Early media classification returns unknown stream', () async {
      final client = MockClient((request) async {
        return http.StreamedResponse(
          Stream.value([1, 2, 3]),
          200,
          headers: {'content-type': 'video/mp2t'},
        );
      });

      final result = await M3uParser.fetchAndParse('http://example.com/stream.ts', client: client);
      
      expect(result.type, M3uType.unknown);
    });

    test('Playlist parsing correctly decodes UTF-8', () async {
      final utf8Payload = '#EXTM3U\n#EXTINF:-1,📺 My Channel (Café)\nhttp://example.com/stream.m3u8';
      
      final client = MockClient((request) async {
        return http.StreamedResponse(
          Stream.value(utf8.encode(utf8Payload)),
          200,
          headers: {'content-type': 'application/vnd.apple.mpegurl'},
        );
      });

      final result = await M3uParser.fetchAndParse('http://example.com/playlist.m3u8', client: client);
      
      expect(result.type, M3uType.channelList);
      expect(result.channels.length, 1);
      expect(result.channels.first.title, '📺 My Channel (Café)');
    });
  });
}
