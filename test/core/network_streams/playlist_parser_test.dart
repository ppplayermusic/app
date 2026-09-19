import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ppplayer/core/network_streams/playlist_parser.dart';

class MockClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest request) handler;

  MockClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) => handler(request);
}

void main() {
  group('PlaylistParser', () {
    test('Early media classification returns unknown stream and cancels early', () async {
      bool streamCancelled = false;
      final controller = StreamController<List<int>>(
        onCancel: () {
          streamCancelled = true;
        },
      );
      
      final client = MockClient((request) async {
        return http.StreamedResponse(
          controller.stream,
          200,
          headers: {'content-type': 'video/mp4'},
        );
      });

      final futureResult = PlaylistParser.fetchAndParse('http://example.com/stream.mp4', client: client);
      
      // Send some bytes
      controller.add([1, 2, 3]);
      
      final result = await futureResult;
      
      expect(result.type, PlaylistType.unknown);
      expect(streamCancelled, true);
    });

    test('M3U parsing correctly decodes split-chunk UTF-8', () async {
      final utf8Payload = '#EXTM3U\n#EXTINF:-1,📺 My Channel (Café)\nhttp://example.com/stream.m3u8';
      final encoded = utf8.encode(utf8Payload);
      
      final client = MockClient((request) async {
        return http.StreamedResponse(
          // Split right in the middle of a multi-byte character
          Stream.fromIterable([
            encoded.sublist(0, 30),
            encoded.sublist(30),
          ]),
          200,
          headers: {'content-type': 'application/vnd.apple.mpegurl'},
        );
      });

      final result = await PlaylistParser.fetchAndParse('http://example.com/playlist.m3u8', client: client);
      
      expect(result.type, PlaylistType.channelList);
      expect(result.channels.length, 1);
      expect(result.channels.first.title, '📺 My Channel (Café)');
    });

    test('PLS parsing handles missing fields and non-consecutive indexes', () {
      final content = '''
[playlist]
File2=http://example.com/stream2
Title2=Stream Two
File5=http://example.com/stream5
Length5=-1
File7=http://example.com/stream7
Title7=Stream Seven
      ''';
      final result = PlaylistParser.parseString(content, 'http://example.com');
      
      expect(result.type, PlaylistType.channelList);
      expect(result.channels.length, 3);
      expect(result.channels[0].title, 'Stream Two');
      expect(result.channels[0].url, 'http://example.com/stream2');
      expect(result.channels[1].title, 'Stream 5'); // Fallback title
      expect(result.channels[1].url, 'http://example.com/stream5');
      expect(result.channels[2].title, 'Stream Seven');
    });

    test('XSPF parsing handles namespaces and alternative locations', () {
      final content = '''<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
  <trackList>
    <track>
      <title>My XSPF Stream</title>
      <location>http://example.com/1</location>
      <location>http://example.com/backup</location>
    </track>
  </trackList>
</playlist>''';
      
      final result = PlaylistParser.parseString(content, 'http://example.com');
      
      expect(result.type, PlaylistType.channelList);
      expect(result.channels.length, 1);
      expect(result.channels[0].title, 'My XSPF Stream');
      expect(result.channels[0].url, 'http://example.com/1'); // Only picks first
    });

    test('ASX parsing handles case-insensitivity', () {
      final content = '''<AsX>
  <EnTrY>
    <tItLe>My ASX Stream</tItLe>
    <rEf HrEf="http://example.com/asx" />
  </EnTrY>
</AsX>''';
      
      final result = PlaylistParser.parseString(content, 'http://example.com');
      
      expect(result.type, PlaylistType.channelList);
      expect(result.channels.length, 1);
      expect(result.channels[0].title, 'My ASX Stream');
      expect(result.channels[0].url, 'http://example.com/asx');
    });

    test('Parses encoding properly from headers and enforces UTF-8 for M3U8', () async {
      final latin1Payload = '\#EXTM3U\n\#EXTINF:-1,* My Channel (Caf\xE9)\nhttp://example.com/stream.m3u8';
      final encoded = latin1.encode(latin1Payload);

      final client = MockClient((request) async {
        return http.StreamedResponse(
          Stream.fromIterable([encoded]),
          200,
          headers: {'content-type': 'application/vnd.apple.mpegurl'},
          request: request,
        );
      });

      // Should fail because M3U8 must be UTF-8 and we gave it latin-1, so utf8.decode throws FormatException
      expect(
        () => PlaylistParser.fetchAndParse('http://example.com/playlist.m3u8', client: client),
        throwsA(isA<FormatException>())
      );
    });

    test('Handles redirects and resolves relative URLs against final URL', () async {
      final utf8Payload = '#EXTM3U\n#EXTINF:-1,Test\nstream.m3u8';
      final encoded = utf8.encode(utf8Payload);

      final client = MockClient((request) async {
        // Return a response where the final request URL was modified by redirect
        final finalRequest = http.Request('GET', Uri.parse('http://example.com/redirected/folder/playlist.m3u8'));
        return http.StreamedResponse(
          Stream.fromIterable([encoded]),
          200,
          headers: {'content-type': 'application/vnd.apple.mpegurl'},
          request: finalRequest, // Mocks the redirect
        );
      });

      final result = await PlaylistParser.fetchAndParse('http://example.com/original.m3u8', client: client);
      expect(result.channels.first.url, 'http://example.com/redirected/folder/stream.m3u8');
    });
  });
}
