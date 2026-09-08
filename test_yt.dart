import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  var yt = YoutubeExplode();
  try {
    // Try to force iOS or Web client if possible
    var manifest = await yt.videos.streamsClient.getManifest('SsKT0s5J8ko'); 
    var audio = manifest.audioOnly;
    print('Codec: ${audio.first.audioCodec}, URL: ${audio.first.url}');
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
