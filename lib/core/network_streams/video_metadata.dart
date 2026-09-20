enum VideoPlatform {
  autoDetect,
  youtube,
  vimeo,
  dailymotion,
  custom,
}

extension VideoPlatformExtension on VideoPlatform {
  String get displayName {
    switch (this) {
      case VideoPlatform.autoDetect:
        return 'Auto-detect';
      case VideoPlatform.youtube:
        return 'YouTube';
      case VideoPlatform.vimeo:
        return 'Vimeo';
      case VideoPlatform.dailymotion:
        return 'Dailymotion';
      case VideoPlatform.custom:
        return 'Custom / IPTV';
    }
  }

  String get dbSourceKind {
    switch (this) {
      case VideoPlatform.youtube:
        return 'youtube_video';
      case VideoPlatform.vimeo:
        return 'vimeo_video';
      case VideoPlatform.dailymotion:
        return 'dailymotion_video';
      case VideoPlatform.custom:
      case VideoPlatform.autoDetect:
        return 'url';
    }
  }
}

class VideoMetadata {
  final String title;
  final String? thumbnailUrl;
  final VideoPlatform platform;

  const VideoMetadata({
    required this.title,
    this.thumbnailUrl,
    required this.platform,
  });
}
