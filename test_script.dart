import 'package:media_kit/media_kit.dart';
void main() async {
  MediaKit.ensureInitialized();
  final player = Player();
  await player.open(Media('https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8'));
  await Future.delayed(Duration(seconds: 5));
  print('Playing: ${player.state.playing}');
  print('Position: ${player.state.position}');
  print('Video Tracks: ${player.state.tracks.video.length}');
  print('Width: ${player.state.width}');
}
