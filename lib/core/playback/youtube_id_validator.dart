class YoutubeIdValidator {
  static final RegExp _validCharsRegex = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  /// Validates a potential YouTube ID.
  /// Returns true if it looks strictly like a YouTube ID.
  static bool isValid(String? id, {String? spotifyId}) {
    if (id == null) return false;
    if (id.length != 11) return false;
    if (id == spotifyId) return false; // Must not be the spotify fallback
    if (id.contains('http://') || id.contains('https://'))
      return false; // Must not be a URL
    if (!_validCharsRegex.hasMatch(id))
      return false; // Must contain valid chars only

    return true;
  }
}
