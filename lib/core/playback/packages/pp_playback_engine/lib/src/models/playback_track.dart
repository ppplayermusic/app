/// Discriminates local vs online sources in the engine layer.
/// Persisted in the queue JSON through Track.sourceType.
enum PlaybackSourceType { online, local }

class PlaybackTrack {
  final String id;
  final String title;
  final String? artist;
  final String? album;
  final String? artworkUrl;
  final Duration? duration;
  final PlaybackSourceType sourceType;
  /// For local tracks: the URI string to pass to media_kit Media().
  /// Built via Uri.file(path).toString() or passed as content:// URI opaquely.
  final String? localMediaUri;

  const PlaybackTrack({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    this.artworkUrl,
    this.duration,
    this.sourceType = PlaybackSourceType.online,
    this.localMediaUri,
  });

  bool get isLocal => sourceType == PlaybackSourceType.local;

  @override
  String toString() => 'PlaybackTrack(id: $id, title: $title, source: ${sourceType.name})';
}
