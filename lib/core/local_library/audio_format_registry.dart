// lib/core/local_library/audio_format_registry.dart

/// Central registry for recognized audio formats and codec families.
/// Distinguishes between recognized import candidates and verified playback capabilities.
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
    '.wv',  // WavPack
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
  static const List<String> _trackerFormats = [
    '.mod', '.xm', '.it', '.s3m',
  ];

  /// Special formats like MIDI that are known but explicitly excluded from general
  /// pickers. MIDI remains completely unverified (not exercised by tests) and is kept unavailable.
  static const List<String> _specialFormats = [
    '.mid', '.midi',
  ];

  /// Formats in the original request that are intentionally omitted as standalone extensions
  /// because they are either typically found inside other containers (e.g. .mov, .mkv)
  /// or are obsolete legacy Mac formats without standard standalone audio extensions:
  /// - DV Audio
  /// - QDM2/QDMC
  /// - MACE (Macintosh Audio Compression/Expansion)
  /// ALAC, LPCM, ADPCM, A-law, and mu-law are supported via their standard 
  /// container extensions (.m4a, .wav, .aiff).

  /// Formats that we want to allow in file pickers and directory scanning.
  /// Note: MIDI is intentionally excluded from auto-scanning until a valid
  /// synthesis path is confirmed available.
  static List<String> get importCandidates => [
    ..._standardFormats,
    ..._trackerFormats,
  ];

  /// Checks whether the given extension is a recognized import candidate.
  /// Does NOT guarantee that the file will successfully decode at runtime.
  static bool isRecognizedImportCandidate(String extension) {
    final ext = extension.toLowerCase();
    return _standardFormats.contains(ext) || _trackerFormats.contains(ext);
  }

  /// Special formats like MIDI that are known but explicitly excluded from general
  /// pickers due to missing native soundbank/synthesis capabilities.
  static bool isSpecialFormatRequiringCapability(String extension) {
    final ext = extension.toLowerCase();
    return _specialFormats.contains(ext);
  }
}
