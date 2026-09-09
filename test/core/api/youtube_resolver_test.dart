import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/api/youtube_resolver.dart';

void main() {
  group('YoutubeResolver unit tests', () {
    test('normalizeString removes diacritics and punctuation', () {
      expect(YoutubeResolver.normalizeString('De Graça Ou Pagando'), 'de graca ou pagando');
      expect(YoutubeResolver.normalizeString('Café & Croissant!'), 'cafe croissant');
      expect(YoutubeResolver.normalizeString('Música: "É isso aí"'), 'musica e isso ai');
      expect(YoutubeResolver.normalizeString('  Extra   spaces  '), 'extra spaces');
      expect(YoutubeResolver.normalizeString('Beyoncé'), 'beyonce');
    });

    test('calculateConfidence scores exact title match highly', () {
      final score = YoutubeResolver.calculateConfidence(
        'De Graça Ou Pagando (Official Audio)',
        'Artist Channel',
        180000, // 3 mins
        'Artist',
        'De Graça Ou Pagando',
        180000,
      );
      
      // Base: 1.0
      // Title contains: +0.5
      // Artist match: +0.5
      // Official Audio: +0.3
      // Duration exact: +0.3
      // Total should be around 2.6
      expect(score, greaterThan(2.0));
    });

    test('calculateConfidence penalizes mismatched versions (remix, live)', () {
      final liveScore = YoutubeResolver.calculateConfidence(
        'Song Name (Live Version)',
        'Some Channel',
        200000,
        'Artist',
        'Song Name',
        180000,
      );
      
      final originalScore = YoutubeResolver.calculateConfidence(
        'Song Name',
        'Some Channel',
        180000,
        'Artist',
        'Song Name',
        180000,
      );

      expect(liveScore, lessThan(originalScore));
    });

    test('calculateConfidence rewards topic channels', () {
      final score = YoutubeResolver.calculateConfidence(
        'Song Name',
        'Artist - Topic',
        180000,
        'Artist',
        'Song Name',
        180000,
      );
      
      // Base: 1.0
      // Title match: +0.5
      // Artist match: +0.5
      // Topic channel: +0.4
      // Duration match: +0.3
      // Total ~ 2.7
      expect(score, greaterThan(2.5));
    });
    
    test('calculateConfidence heavily penalizes different duration', () {
      final badDurationScore = YoutubeResolver.calculateConfidence(
        'Song Name',
        'Artist',
        600000, // 10 mins
        'Artist',
        'Song Name',
        180000, // 3 mins
      );
      
      final goodDurationScore = YoutubeResolver.calculateConfidence(
        'Song Name',
        'Artist',
        181000, // 3m 1s
        'Artist',
        'Song Name',
        180000, // 3 mins
      );
      
      expect(badDurationScore, lessThan(goodDurationScore));
    });
  });
}
