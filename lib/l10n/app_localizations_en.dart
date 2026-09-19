// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMS';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTS';

  @override
  String get artwork => 'ARTWORK';

  @override
  String get appVersion => 'App version';

  @override
  String get artist => 'Artist';

  @override
  String get artistsYouFollow => 'Artists you follow';

  @override
  String get autoplay => 'Autoplay';

  @override
  String get becauseYouListenedTo => 'Because you listened to';

  @override
  String get browseAll => 'Browse all';

  @override
  String get cancel => 'Cancel';

  @override
  String get clearAppCache => 'Clear App Cache?';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearHistory => 'Clear History?';

  @override
  String get clearRecentlyPlayed => 'Clear Recently Played';

  @override
  String get contentMarket => 'Content Market';

  @override
  String get continueListening => 'Continue Listening';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continue video playback in a small window';

  @override
  String get create => 'Create';

  @override
  String get createAPlaylistToGetStarted => 'Create a playlist to get started';

  @override
  String currentSelectedcountry(Object country) {
    return 'Current: $country';
  }

  @override
  String get deletePlaylist => 'Delete Playlist';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Error loading markets: $err';
  }

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String explore(Object genre) {
    return 'Explore $genre';
  }

  @override
  String get fansAlsoLike => 'FANS ALSO LIKE';

  @override
  String featuringTouppercase(Object artist) {
    return 'FEATURING $artist';
  }

  @override
  String get featuredPlaylists => 'Featured Playlists';

  @override
  String get followArtistsToSeeThemHere => 'Follow artists to see them here';

  @override
  String get followStationsToSeeThemHere => 'Follow stations to see them here';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Force audio-only streams to save data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Frees up space and forces fresh data on next load';

  @override
  String get fromYourFavorites => 'From your favorites';

  @override
  String get goBack => 'Go Back';

  @override
  String inspiredByName(Object name) {
    return 'Inspired by $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Keep playing similar tracks when queue ends';

  @override
  String get library => 'Library';

  @override
  String get likeAlbumsToSeeThemHere => 'Like albums to see them here';

  @override
  String get likedSongs => 'Liked Songs';

  @override
  String get lowDataMode => 'Low Data Mode';

  @override
  String get madeForYou => 'Made for you';

  @override
  String moreLikeName(Object name) {
    return 'More like $name';
  }

  @override
  String get moreOptions => 'More options';

  @override
  String get nameYourMasterpiece => 'Name your masterpiece...';

  @override
  String get newPlaylist => 'New Playlist';

  @override
  String get newReleases => 'New Releases';

  @override
  String get next => 'Next';

  @override
  String get noAlbumsFound => 'No albums found';

  @override
  String get noArtistsFollowed => 'No artists followed';

  @override
  String get noArtistsFound => 'No artists found';

  @override
  String get noLikedAlbums => 'No liked albums';

  @override
  String get noPlaylistsFound => 'No playlists found';

  @override
  String get noPlaylistsYet => 'No playlists yet';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noStationsFollowed => 'No stations followed';

  @override
  String get noTrackPlaying => 'No track playing';

  @override
  String get noTracksFound => 'No tracks found';

  @override
  String get playlists => 'PLAYLISTS';

  @override
  String get popular => 'POPULAR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Permanently remove listening history';

  @override
  String get pictureinpicturePip => 'Picture-in-Picture (PiP)';

  @override
  String get popularAlbums => 'Popular Albums';

  @override
  String get popularArtists => 'Popular Artists';

  @override
  String get popularGenres => 'Popular Genres';

  @override
  String get popularSongs => 'Popular Songs';

  @override
  String get popularTracks => 'Popular Tracks';

  @override
  String get popularHitsRightNow => 'Popular hits right now';

  @override
  String get previous => 'Previous';

  @override
  String get queue => 'QUEUE';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get recommendedForYou => 'Recommended for You';

  @override
  String get scraping => 'Scraping';

  @override
  String get search => 'Search';

  @override
  String get searchInAlbum => 'Search in album...';

  @override
  String get searchInLibrary => 'Search in library...';

  @override
  String get searchInPlaylist => 'Search in playlist';

  @override
  String get searchLikedSongs => 'Search liked songs...';

  @override
  String get searchPopularSongs => 'Search popular songs...';

  @override
  String get selectMarket => 'Select Market';

  @override
  String get settings => 'Settings';

  @override
  String get showVideoPlayer => 'Show Video Player';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get spotifyCredentials => 'Spotify Credentials';

  @override
  String get suggestedStations => 'Suggested Stations';

  @override
  String get tracks => 'TRACKS';

  @override
  String get trending => 'Trending';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get tryADifferentSearchTerm => 'Try a different search term';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Use YouTube player when available';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'What do you want to listen to?';

  @override
  String get youtubeCredentials => 'YouTube Credentials';

  @override
  String get yourLibrary => 'Your Library';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String get addToQueue => 'Add to queue';

  @override
  String get copyId => 'Copy ID';

  @override
  String get copyLink => 'Copy link';

  @override
  String get discover => 'Discover';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get favorites => 'Favorites';

  @override
  String get goToAlbum => 'Go to album';

  @override
  String get goToArtist => 'Go to artist';

  @override
  String get goToArtistRadio => 'Go to artist radio';

  @override
  String get goToPlaylist => 'Go to playlist';

  @override
  String get goToSongRadio => 'Go to song radio';

  @override
  String get home => 'Home';

  @override
  String get myAwesomePlaylist => 'My Awesome Playlist';

  @override
  String get myPlaylist => 'My Playlist';

  @override
  String get newPlaylist1 => 'New playlist';

  @override
  String get play => 'Play';

  @override
  String get playStation => 'Play Station';

  @override
  String get playNext => 'Play next';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Playlist Name';

  @override
  String get playlists1 => 'Playlists';

  @override
  String get queue1 => 'Queue';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get removeFromQueue => 'Remove from queue';

  @override
  String get retry => 'Retry';

  @override
  String get searchMusicArtistsAlbums => 'Search music, artists, albums...';

  @override
  String get share => 'Share';

  @override
  String featuringArtist(String artistName) {
    return 'FEATURING $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Current: $country';
  }

  @override
  String get queueTooltip => 'Queue';

  @override
  String get searchHint => 'Search music, artists, albums...';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get songsTab => 'Songs';

  @override
  String get foldersTab => 'Folders';

  @override
  String get artistsTab => 'Artists';

  @override
  String get albumsTab => 'Albums';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'No genres found';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get addMusic => 'Add music';

  @override
  String get addFiles => 'Add files';

  @override
  String get addFolder => 'Add folder';

  @override
  String get rescanLibrary => 'Rescan library';

  @override
  String get sortTitle => 'Title';

  @override
  String get sortArtist => 'Artist';

  @override
  String get sortAlbum => 'Album';

  @override
  String get sortDuration => 'Duration';

  @override
  String get sortDateAdded => 'Date Added';

  @override
  String get sortBy => 'Sort by';

  @override
  String get trackInformation => 'Track Information';

  @override
  String get removeFromLibrary => 'Remove from library';

  @override
  String get showInFolder => 'Show in folder';

  @override
  String get unknownArtist => 'Unknown Artist';

  @override
  String get unknownAlbum => 'Unknown Album';

  @override
  String get importedFiles => 'Imported Files';

  @override
  String get playFolder => 'Play folder';

  @override
  String get shuffleFolder => 'Shuffle folder';

  @override
  String get playAll => 'Play all';

  @override
  String get includeSubfolders => 'Include subfolders';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '1 track',
      zero: '0 tracks',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'No local songs imported';

  @override
  String get searchLocalMusic => 'Search local music';

  @override
  String get viewAsList => 'View as list';

  @override
  String get viewAsGrid => 'View as grid';

  @override
  String get trackInfoPath => 'Path';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Duration';

  @override
  String get aboutDescription => 'A free, open-source music player.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get createdBy => 'Created by Lucas Coelho';

  @override
  String get website => 'Website';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get support => 'Support';

  @override
  String get license => 'License';

  @override
  String get acknowledgments => 'Acknowledgments';

  @override
  String get close => 'Close';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Your music is waiting.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Your favorites\nand new discoveries';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'New music\njust for you';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Relax and unwind';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Deep focus\nand productivity';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterPlaylists => 'Playlists';

  @override
  String get filterArtists => 'Artists';

  @override
  String get filterAlbums => 'Albums';

  @override
  String get filterStations => 'Stations';

  @override
  String get filterStreams => 'Streams';

  @override
  String get localMusicCard => 'Local Music';

  @override
  String get createPlaylistButton => 'Create Playlist';

  @override
  String get radioStations => 'Radio Stations';

  @override
  String get discoverMusic => 'Discover Music';

  @override
  String get importLocalMusic => 'Import Local Music';

  @override
  String get importAudioFiles => 'Import Audio Files';

  @override
  String get importFolder => 'Import Folder';

  @override
  String get importFolderSubtitle =>
      'Note: Audio files are hidden in the folder picker. This is normal.';

  @override
  String get importPlaylist => 'Import Playlist';

  @override
  String get importPlaylistSubtitle => 'Import .m3u or .m3u8 files';

  @override
  String get exportPlaylist => 'Export Playlist';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Unsupported format or corrupted file';

  @override
  String get playbackErrorFileInaccessible => 'File inaccessible or not found';

  @override
  String get localVideosCard => 'Local Videos';

  @override
  String get noLocalVideos => 'No videos found';

  @override
  String get searchLocalVideos => 'Search local videos';

  @override
  String get addVideos => 'Add Videos';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get audioTracks => 'Audio Tracks';

  @override
  String get loadSubtitleFile => 'Load subtitle file...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Error loading subtitle: $error';
  }

  @override
  String get off => 'Off';
}
