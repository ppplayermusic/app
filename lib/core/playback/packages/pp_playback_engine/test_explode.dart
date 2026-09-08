import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest('g8sX6wZHhD0');
  final streamInfo = manifest.audioOnly.withHighestBitrate();
  print('Audio URL: ${streamInfo.url}');
  yt.close();
}
