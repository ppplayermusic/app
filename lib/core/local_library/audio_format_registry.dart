// lib/core/local_library/audio_format_registry.dart

/// Persisted media scope for an import root: audio only, video only, or both.
/// Stored by name in the ImportRoots table so restarts preserve the original
/// scope and rescans do not silently change which media types are included.
enum ImportMediaScope {
  audio,
  video,
  both;

  bool get includesAudio => this == audio || this == both;
  bool get includesVideo => this == video || this == both;
}

/// Central registry for recognized audio and video formats.
/// Extensions identify *candidate* files for import; they do not prove a
/// video stream exists.  Use [VideoProbeService] to confirm a video stream
/// after import.
class AudioFormatRegistry {
  /// Well-supported standard, lossless, and lossy formats natively handled by FFmpeg/libmpv.
  static const List<String> _standardFormats = [
    '.mp1', '.mp2', '.mp3',
    '.aac', '.m4a', // M4A commonly contains AAC or ALAC
    '.ogg', '.oga', // Ogg container (Vorbis, Opus, FLAC)
    '.opus',
    '.flac',
    '.wav', // LPCM, ADPCM, A-law, mu-law
    '.aiff', '.aif',
    '.wma', // WMA variants
    '.ac3', '.eac3',
    '.dts',
    '.mlp', // MLP / TrueHD
    '.mka', // Matroska audio
    '.ape', // Monkey's Audio
    '.wv', // WavPack
    '.mpc', // Musepack
    '.tta', // TrueAudio
    '.rm', '.ra', // RealAudio (ambiguous, probed at import if needed)
    '.amr', '.awb', // AMR
    '.spx', // Speex
    '.qcp', // QCELP
    '.oma', '.aa3', // ATRAC3
  ];

  /// Tracker formats.
  /// - MOD, XM, and S3M failed decoding on the tested macOS build.
  /// - IT remains completely unverified (not exercised by tests).
  /// Kept explicitly unverified and unavailable until their status is understood.
  static const List<String> _trackerFormats = ['.mod', '.xm', '.it', '.s3m'];

  /// Special formats like MIDI that are known but explicitly excluded from general
  /// pickers. MIDI remains completely unverified (not exercised by tests) and is kept unavailable.
  static const List<String> _specialFormats = ['.mid', '.midi'];

  /// Formats in the original request that are intentionally omitted as standalone extensions
  /// because they are either typically found inside other containers (e.g. .mov, .mkv)
  /// or are obsolete legacy Mac formats without standard standalone audio extensions:
  /// - DV Audio
  /// - QDM2/QDMC
  /// - MACE (Macintosh Audio Compression/Expansion)
  /// ALAC, LPCM, ADPCM, A-law, and mu-law are supported via their standard
  /// container extensions (.m4a, .wav, .aiff).

  /// Video container formats accepted by libmpv/FFmpeg.  Files matching these
  /// extensions are *candidate* video files; actual video-stream presence is
  /// confirmed by [VideoProbeService] after import.
  ///
  /// Audio-only MP4/MKV files selected through the video import path will be
  /// imported without [LocalFile.isVideo] set, and will not appear in the
  /// Videos library.  They will only appear in the music library if the user
  /// also imports them through an audio import action or "Open File".
  static const List<String> _videoFormats = [
    '.mp4',
    '.m4v',
    '.mkv',
    '.mov',
    '.avi',
    '.wmv',
    '.flv',
    '.webm',
    '.ts',
    '.m2ts',
    '.mts',
    '.3gp',
    '.3g2',
    '.ogv',
    '.divx',
    '.rmvb',
    '.vob',
    '.f4v',
  ];

  /// All extensions accepted by a video file or folder picker.
  static List<String> get videoImportCandidates =>
      List.unmodifiable(_videoFormats);

  /// Extensions accepted by "Open File" which routes each file to the
  /// appropriate import path (audio vs video) based on its extension.
  static List<String> get openFileCandidates => [
    ..._standardFormats,
    ..._trackerFormats,
    ..._videoFormats,
  ];

  /// Formats that we want to allow in audio file pickers and directory scanning.
  /// Note: MIDI is intentionally excluded from auto-scanning until a valid
  /// synthesis path is confirmed available.
  /// Note: video formats are intentionally excluded — use [videoImportCandidates]
  /// for the video import path.
  static List<String> get importCandidates => [
    ..._standardFormats,
    ..._trackerFormats,
  ];

  /// Checks whether the given extension is a recognized audio import candidate.
  /// Does NOT guarantee that the file will successfully decode at runtime.
  static bool isRecognizedImportCandidate(String extension) {
    final ext = extension.toLowerCase();
    return _standardFormats.contains(ext) || _trackerFormats.contains(ext);
  }

  /// Returns true when the file extension belongs to the video candidate list.
  /// This is a necessary but not sufficient condition for a file containing a
  /// video stream — use [VideoProbeService] to confirm.
  static bool isVideoFormatCandidate(String extension) {
    return _videoFormats.contains(extension.toLowerCase());
  }

  /// Returns the lowercased extension (including the leading dot) of a path or
  /// filename.  Returns an empty string when there is no extension.
  static String extensionOf(String pathOrName) {
    final dot = pathOrName.lastIndexOf('.');
    if (dot < 0 || dot >= pathOrName.length - 1) return '';
    return pathOrName.substring(dot).toLowerCase();
  }

  /// Special formats like MIDI that are known but explicitly excluded from general
  /// pickers due to missing native soundbank/synthesis capabilities.
  static bool isSpecialFormatRequiringCapability(String extension) {
    final ext = extension.toLowerCase();
    return _specialFormats.contains(ext);
  }
}
