class ResolvedVideoCandidate {
  final String videoId;
  final String title;
  final String channel;
  final int? durationMs;
  final double confidenceScore;

  const ResolvedVideoCandidate({
    required this.videoId,
    required this.title,
    required this.channel,
    this.durationMs,
    required this.confidenceScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'channel': channel,
      'durationMs': durationMs,
      'confidenceScore': confidenceScore,
    };
  }

  factory ResolvedVideoCandidate.fromJson(Map<String, dynamic> json) {
    return ResolvedVideoCandidate(
      videoId: json['videoId'],
      title: json['title'],
      channel: json['channel'],
      durationMs: json['durationMs'],
      confidenceScore: json['confidenceScore']?.toDouble() ?? 0.0,
    );
  }
}
