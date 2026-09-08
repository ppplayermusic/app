import 'dart:io';
import 'package:media_kit/media_kit.dart';

void main() async {
  MediaKit.ensureInitialized();
  var player = Player();

  var server = await HttpServer.bind('127.0.0.1', 8080);
  print('Server running on port 8080');

  server.listen((HttpRequest request) async {
    print('Client connected: ${request.method} ${request.uri}');
    print('Headers:');
    request.headers.forEach((k, v) => print('  $k: $v'));
    
    request.response.headers.contentType = ContentType.parse('audio/mp4');
    request.response.headers.add('Accept-Ranges', 'none');
    request.response.headers.add('Content-Length', '1000000');
    
    if (request.method == 'HEAD') {
      await request.response.close();
      return;
    }
    
    // send dummy bytes slowly
    for (int i=0; i<10; i++) {
      request.response.add(List.filled(10000, 0));
      await Future.delayed(Duration(milliseconds: 100));
    }
    await request.response.close();
  });

  player.stream.error.listen((e) => print('Player error: $e'));
  player.stream.playing.listen((p) => print('Player playing: $p'));

  print('Opening media...');
  await player.open(Media('http://127.0.0.1:8080/stream?id=test'));
  await player.play();
  
  await Future.delayed(Duration(seconds: 3));
  player.dispose();
  server.close(force: true);
  exit(0);
}
