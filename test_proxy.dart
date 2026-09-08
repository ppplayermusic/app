import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  var yt = YoutubeExplode();
  var server = await HttpServer.bind('127.0.0.1', 8080);
  print('Server running on port 8080');

  // Let's simulate media_kit asking for the stream
  Future.delayed(Duration(seconds: 1), () async {
    print('Client connecting...');
    var client = HttpClient();
    var req = await client.getUrl(Uri.parse('http://127.0.0.1:8080/stream?id=SsKT0s5J8ko'));
    var res = await req.close();
    print('Client received status: ${res.statusCode}');
    int bytes = 0;
    await for (var chunk in res) {
      bytes += chunk.length;
      if (bytes > 100000) {
        print('Client received 100KB, breaking');
        break;
      }
    }
    client.close();
    exit(0);
  });

  await for (HttpRequest request in server) {
    if (request.uri.path == '/stream') {
      var id = request.uri.queryParameters['id']!;
      print('Proxy fetching stream for $id');
      try {
        var manifest = await yt.videos.streamsClient.getManifest(id);
        var audioStreamInfo = manifest.audioOnly.first;
        request.response.headers.contentType = ContentType.parse('audio/mp4');
        request.response.headers.add('Accept-Ranges', 'bytes');
        var stream = yt.videos.streamsClient.get(audioStreamInfo);
        await stream.pipe(request.response);
      } catch (e) {
        print('Proxy error: $e');
        request.response.statusCode = 500;
        request.response.close();
      }
    } else {
      request.response.statusCode = 404;
      request.response.close();
    }
  }
}
