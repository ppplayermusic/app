enum PlaybackResolutionError {
  searchFailure,
  noCandidates,
  candidateUnavailable,
  candidateRejected,
  timeout,
  networkFailure,
  allCandidatesExhausted
}

extension PlaybackResolutionErrorExtension on PlaybackResolutionError {
  String get message {
    switch (this) {
      case PlaybackResolutionError.searchFailure:
        return 'Search failure';
      case PlaybackResolutionError.noCandidates:
        return 'No candidates found';
      case PlaybackResolutionError.candidateUnavailable:
        return 'Candidate unavailable';
      case PlaybackResolutionError.candidateRejected:
        return 'Candidate rejected by player';
      case PlaybackResolutionError.timeout:
        return 'Timeout';
      case PlaybackResolutionError.networkFailure:
        return 'Network failure';
      case PlaybackResolutionError.allCandidatesExhausted:
        return 'All candidates exhausted';
    }
  }
}
