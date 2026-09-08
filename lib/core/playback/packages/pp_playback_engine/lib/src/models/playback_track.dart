class PlaybackTrack {
  final String id;
  final String title;
  final String? artist;
  final String? album;
  final String? artworkUrl;
  final Duration? duration;

  const PlaybackTrack({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    this.artworkUrl,
    this.duration,
  });

  @override
  String toString() => 'PlaybackTrack(id: $id, title: $title)';
}
