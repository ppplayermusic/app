import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest('g8sX6wZHhD0');
  
  try {
    final muxedInfo = manifest.muxed.withHighestBitrate();
    print('Muxed URL: ${muxedInfo.url}');
  } catch (e) {
    print('Muxed error: $e');
  }
  
  try {
    final audioInfo = manifest.audioOnly.withHighestBitrate();
    print('Audio URL: ${audioInfo.url}');
  } catch (e) {
    print('Audio error: $e');
  }
  
  yt.close();
}
