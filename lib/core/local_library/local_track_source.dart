// lib/core/local_library/local_track_source.dart
//
// Explicit, serializable representation of how a local audio file is accessed.
// Persisted in the local_files Drift table independently from Track identity.

/// Discriminates the access mechanism per platform.
enum TrackSourceType {
  /// macOS / Windows / Linux: absolute filesystem path.
  absolutePath,

  /// Android: content:// URI from document picker.
  /// Must be opened via ContentResolver, NOT File() or Directory.list().
  androidContentUri,

  /// iOS: security-scoped bookmark data (base64) from UIDocumentPicker.
  iOsSecurityBookmark,

  /// iOS / macOS / Android: file copied into the app's own sandbox.
  managedCopy,
}

/// Whether a track's file is currently reachable.
enum TrackAvailabilityStatus {
  available,
  missing,
  permissionRevoked,
  decodingError,
}

/// Durable locator for one local audio file.
class LocalTrackSource {
  /// Stable library ID: 'local:`<uuid>`'. Used as spotifyId (PK) in Tracks.
  final String libraryId;

  final TrackSourceType mechanism;

  /// The durable locator:
  /// - absolutePath / managedCopy: absolute path string
  /// - androidContentUri: 'content://...' URI string
  /// - iOsSecurityBookmark: base64-encoded NSData bookmark
  final String locator;

  /// Display path for UI only — never used for file access.
  final String displayPath;

  /// sha256 hex of the canonical locator bytes. Used for deduplication.
  final String deduplicationKey;

  final DateTime lastScannedAt;
  final TrackAvailabilityStatus availabilityStatus;

  /// The root locator that was scanned to discover this file, if any.
  final String? importRootLocator;

  const LocalTrackSource({
    required this.libraryId,
    required this.mechanism,
    required this.locator,
    required this.displayPath,
    required this.deduplicationKey,
    required this.lastScannedAt,
    required this.availabilityStatus,
    this.importRootLocator,
  });

  bool get isAvailable =>
      availabilityStatus == TrackAvailabilityStatus.available;

  LocalTrackSource copyWith({
    TrackAvailabilityStatus? availabilityStatus,
    DateTime? lastScannedAt,
    String? locator,
    String? displayPath,
  }) {
    return LocalTrackSource(
      libraryId: libraryId,
      mechanism: mechanism,
      locator: locator ?? this.locator,
      displayPath: displayPath ?? this.displayPath,
      deduplicationKey: deduplicationKey,
      lastScannedAt: lastScannedAt ?? this.lastScannedAt,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      importRootLocator: importRootLocator,
    );
  }

  Map<String, dynamic> toJson() => {
    'libraryId': libraryId,
    'mechanism': mechanism.name,
    'locator': locator,
    'displayPath': displayPath,
    'deduplicationKey': deduplicationKey,
    'lastScannedAt': lastScannedAt.toIso8601String(),
    'availabilityStatus': availabilityStatus.name,
    if (importRootLocator != null) 'importRootLocator': importRootLocator,
  };

  factory LocalTrackSource.fromJson(Map<String, dynamic> json) {
    return LocalTrackSource(
      libraryId: json['libraryId'] as String,
      mechanism: TrackSourceType.values.firstWhere(
        (e) => e.name == json['mechanism'],
        orElse: () => TrackSourceType.absolutePath,
      ),
      locator: json['locator'] as String,
      displayPath: json['displayPath'] as String,
      deduplicationKey: json['deduplicationKey'] as String,
      lastScannedAt: DateTime.parse(json['lastScannedAt'] as String),
      availabilityStatus: TrackAvailabilityStatus.values.firstWhere(
        (e) => e.name == json['availabilityStatus'],
        orElse: () => TrackAvailabilityStatus.missing,
      ),
      importRootLocator: json['importRootLocator'] as String?,
    );
  }

  @override
  String toString() =>
      'LocalTrackSource(id=$libraryId, mechanism=${mechanism.name}, '
      'status=${availabilityStatus.name})';
}

/// Tracked import root — persisted so rescan can discover new files.
class ImportRoot {
  final String id;
  final TrackSourceType mechanism;
  final String rootLocator;
  final String displayPath;
  final DateTime addedAt;

  const ImportRoot({
    required this.id,
    required this.mechanism,
    required this.rootLocator,
    required this.displayPath,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'mechanism': mechanism.name,
    'rootLocator': rootLocator,
    'displayPath': displayPath,
    'addedAt': addedAt.toIso8601String(),
  };

  factory ImportRoot.fromJson(Map<String, dynamic> json) {
    return ImportRoot(
      id: json['id'] as String,
      mechanism: TrackSourceType.values.firstWhere(
        (e) => e.name == json['mechanism'],
        orElse: () => TrackSourceType.absolutePath,
      ),
      rootLocator: json['rootLocator'] as String,
      displayPath: json['displayPath'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}
