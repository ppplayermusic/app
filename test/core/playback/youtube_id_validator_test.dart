import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/playback/youtube_id_validator.dart';

void main() {
  group('YoutubeIdValidator', () {
    test('accepts valid 11-char IDs', () {
      expect(YoutubeIdValidator.isValid('nUsrYVxrDwI'), isTrue);
      expect(YoutubeIdValidator.isValid('1234567890_'), isTrue);
      expect(YoutubeIdValidator.isValid('abcdefghij-'), isTrue);
    });

    test('rejects null or empty', () {
      expect(YoutubeIdValidator.isValid(null), isFalse);
      expect(YoutubeIdValidator.isValid(''), isFalse);
    });

    test('rejects lengths other than 11', () {
      expect(YoutubeIdValidator.isValid('1234567890'), isFalse); // 10
      expect(YoutubeIdValidator.isValid('123456789012'), isFalse); // 12
    });

    test('rejects IDs with invalid characters', () {
      expect(YoutubeIdValidator.isValid('nUsrYVxrDw!'), isFalse);
      expect(YoutubeIdValidator.isValid('nUsrYVxrDw '), isFalse);
      expect(YoutubeIdValidator.isValid('nUsrYVxrDw/'), isFalse);
    });

    test('rejects URLs', () {
      expect(YoutubeIdValidator.isValid('http://youtu'), isFalse);
      expect(YoutubeIdValidator.isValid('https://yout'), isFalse);
    });

    test('rejects if ID matches spotify fallback', () {
      expect(
        YoutubeIdValidator.isValid('nUsrYVxrDwI', spotifyId: 'nUsrYVxrDwI'),
        isFalse,
      );
      // Valid if it doesn't match
      expect(
        YoutubeIdValidator.isValid('nUsrYVxrDwI', spotifyId: 'someSpotifyId'),
        isTrue,
      );
    });
  });
}
