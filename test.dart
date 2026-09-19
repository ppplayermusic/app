import 'package:media_kit/media_kit.dart';
void main() {
  MediaKit.ensureInitialized();
  final player = Player();
  print('Player created.');
  // wait 5 seconds then exit
  Future.delayed(Duration(seconds: 5), () {
    print('Exiting.');
  });
}
