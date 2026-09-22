// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'MGA ALBUM';

  @override
  String get api => 'API';

  @override
  String get artists => 'MGA ARTISTA';

  @override
  String get artwork => 'SINING';

  @override
  String get appVersion => 'Bersyon ng app';

  @override
  String get artist => 'Artista';

  @override
  String get artistsYouFollow => 'Mga artistang sinusundan mo';

  @override
  String get autoplay => 'Awtomatikong mag-play';

  @override
  String get becauseYouListenedTo => 'Dahil nakikinig ka sa';

  @override
  String get browseAll => 'Tingnan lahat';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get clearAppCache => 'I-clear ang App Cache?';

  @override
  String get clearCache => 'I-clear ang Cache';

  @override
  String get clearHistory => 'I-clear ang Kasaysayan?';

  @override
  String get clearRecentlyPlayed => 'I-clear ang Kamakailan lang na Na-play';

  @override
  String get contentMarket => 'Market ng Nilalaman';

  @override
  String get continueListening => 'Ituloy ang pakikinig';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Ituloy ang video sa maliit na window';

  @override
  String get create => 'Lumikha';

  @override
  String get createAPlaylistToGetStarted => 'Gumawa ng playlist para magsimula';

  @override
  String currentSelectedcountry(Object country) {
    return 'Kasalukuyan: $country';
  }

  @override
  String get deletePlaylist => 'Burahin ang Playlist';

  @override
  String get editProfile => 'I-edit ang Profile';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Error sa pag-load ng mga market: $err';
  }

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String explore(Object genre) {
    return 'I-explore ang $genre';
  }

  @override
  String get fansAlsoLike => 'GUSTO RIN NG MGA FAN';

  @override
  String featuringTouppercase(Object artist) {
    return 'KASAMA SI $artist';
  }

  @override
  String get featuredPlaylists => 'Mga Featured na Playlist';

  @override
  String get followArtistsToSeeThemHere =>
      'Sundan ang mga artista para makita sila dito';

  @override
  String get followStationsToSeeThemHere =>
      'Sundan ang mga istasyon para makita sila dito';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Piliting mag-stream ng audio lamang para makatipid ng data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Nagpapalaya ng espasyo at nagfo-force ng bagong data sa susunod na load';

  @override
  String get fromYourFavorites => 'Mula sa iyong mga paborito';

  @override
  String get goBack => 'Bumalik';

  @override
  String inspiredByName(Object name) {
    return 'Inspirado ni $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Patuloy na mag-play ng katulad na mga kanta kapag natapos ang queue';

  @override
  String get library => 'Aklatan';

  @override
  String get likeAlbumsToSeeThemHere => 'I-like ang mga album para makita dito';

  @override
  String get likedSongs => 'Mga Liked na Kanta';

  @override
  String get lowDataMode => 'Mode ng Mababang Data';

  @override
  String get madeForYou => 'Para sa Iyo';

  @override
  String moreLikeName(Object name) {
    return 'Higit pang tulad ni $name';
  }

  @override
  String get moreOptions => 'Higit pang mga pagpipilian';

  @override
  String get nameYourMasterpiece => 'Pangalanan ang iyong obra maestra...';

  @override
  String get newPlaylist => 'Bagong Playlist';

  @override
  String get newReleases => 'Mga Bagong Labas';

  @override
  String get next => 'Susunod';

  @override
  String get noAlbumsFound => 'Walang nahanap na album';

  @override
  String get noArtistsFollowed => 'Walang sinundan na artista';

  @override
  String get noArtistsFound => 'Walang nahanap na artista';

  @override
  String get noLikedAlbums => 'Walang liked na album';

  @override
  String get noPlaylistsFound => 'Walang nahanap na playlist';

  @override
  String get noPlaylistsYet => 'Wala pang playlist';

  @override
  String get noResultsFound => 'Walang nahanap na resulta';

  @override
  String get noStationsFollowed => 'Walang sinundan na istasyon';

  @override
  String get noTrackPlaying => 'Walang kanta na nagpe-play';

  @override
  String get noTracksFound => 'Walang nahanap na kanta';

  @override
  String get playlists => 'MGA PLAYLIST';

  @override
  String get popular => 'SIKAT';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Permanenteng alisin ang kasaysayan ng pakikinig';

  @override
  String get pictureinpicturePip => 'Picture-in-Picture (PiP)';

  @override
  String get popularAlbums => 'Mga Sikat na Album';

  @override
  String get popularArtists => 'Mga Sikat na Artista';

  @override
  String get popularGenres => 'Mga Sikat na Genre';

  @override
  String get popularSongs => 'Mga Sikat na Kanta';

  @override
  String get popularTracks => 'Mga Sikat na Track';

  @override
  String get popularHitsRightNow => 'Mga sikat na hit ngayon';

  @override
  String get previous => 'Nakaraan';

  @override
  String get queue => 'PILA';

  @override
  String get recentSearches => 'Mga kamakailang paghahanap';

  @override
  String get recommendedForYou => 'Inirerekomenda para sa Iyo';

  @override
  String get scraping => 'Nangongolekta ng data';

  @override
  String get search => 'Maghanap';

  @override
  String get searchInAlbum => 'Maghanap sa album...';

  @override
  String get searchInLibrary => 'Maghanap sa library...';

  @override
  String get searchInPlaylist => 'Maghanap sa playlist';

  @override
  String get searchLikedSongs => 'Maghanap ng mga liked na kanta...';

  @override
  String get searchPopularSongs => 'Maghanap ng mga sikat na kanta...';

  @override
  String get selectMarket => 'Pumili ng Market';

  @override
  String get settings => 'Mga Setting';

  @override
  String get showVideoPlayer => 'Ipakita ang Video Player';

  @override
  String get shuffle => 'I-shuffle';

  @override
  String get spotifyCredentials => 'Mga Kredensyal ng Spotify';

  @override
  String get suggestedStations => 'Mga Mungkahing Istasyon';

  @override
  String get tracks => 'MGA TRACK';

  @override
  String get trending => 'Trending';

  @override
  String get tryAgain => 'Subukang muli';

  @override
  String get tryADifferentSearchTerm => 'Subukan ang ibang salitang panghanap';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Gamitin ang YouTube player kung available';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Ano ang gusto mong pakinggan?';

  @override
  String get youtubeCredentials => 'Mga Kredensyal ng YouTube';

  @override
  String get yourLibrary => 'Iyong Library';

  @override
  String get playerscreenviewswitch => 'pagpalit_tingin_screen_manlalaro';

  @override
  String get addToPlaylist => 'Idagdag sa playlist';

  @override
  String get addToQueue => 'Idagdag sa queue';

  @override
  String get copyId => 'Kopyahin ang ID';

  @override
  String get copyLink => 'Kopyahin ang link';

  @override
  String get discover => 'Tuklasin';

  @override
  String get enterYourName => 'Ilagay ang iyong pangalan';

  @override
  String get favorites => 'Mga Paborito';

  @override
  String get goToAlbum => 'Pumunta sa album';

  @override
  String get goToArtist => 'Pumunta sa artista';

  @override
  String get goToArtistRadio => 'Pumunta sa artist radio';

  @override
  String get goToPlaylist => 'Pumunta sa playlist';

  @override
  String get goToSongRadio => 'Pumunta sa song radio';

  @override
  String get home => 'Home';

  @override
  String get myAwesomePlaylist => 'Aking Magandang Playlist';

  @override
  String get myPlaylist => 'Aking Playlist';

  @override
  String get newPlaylist1 => 'Bagong playlist';

  @override
  String get play => 'I-play';

  @override
  String get playStation => 'I-play ang Istasyon';

  @override
  String get playNext => 'I-play susunod';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Pangalan ng Playlist';

  @override
  String get playlists1 => 'Mga Playlist';

  @override
  String get queue1 => 'Pila';

  @override
  String get recentlyPlayed => 'Kamakailan lang na Na-play';

  @override
  String get removeFromQueue => 'Alisin sa queue';

  @override
  String get retry => 'Subukang muli';

  @override
  String get searchMusicArtistsAlbums =>
      'Maghanap ng musika, artista, album...';

  @override
  String get share => 'Ibahagi';

  @override
  String featuringArtist(String artistName) {
    return 'KASAMA SI $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Kasalukuyan: $country';
  }

  @override
  String get queueTooltip => 'Pila';

  @override
  String get searchHint => 'Maghanap ng musika, artista, album...';

  @override
  String get language => 'Wika';

  @override
  String get systemDefault => 'Default ng System';

  @override
  String get songsTab => 'Mga Kanta';

  @override
  String get foldersTab => 'Mga Folder';

  @override
  String get artistsTab => 'Mga Artista';

  @override
  String get albumsTab => 'Mga Album';

  @override
  String get genresTab => 'Mga Genre';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'Bilis ng pag-playback';

  @override
  String get addMusic => 'Magdagdag ng Musika';

  @override
  String get addFiles => 'Magdagdag ng mga File';

  @override
  String get addFolder => 'Magdagdag ng Folder';

  @override
  String get rescanLibrary => 'I-scan Muli ang Library';

  @override
  String get sortTitle => 'Pagbukud-bukurin ayon sa Pamagat';

  @override
  String get sortArtist => 'Pagbukud-bukurin ayon sa Artista';

  @override
  String get sortAlbum => 'Pagbukud-bukurin ayon sa Album';

  @override
  String get sortDuration => 'Pagbukud-bukurin ayon sa Tagal';

  @override
  String get sortDateAdded => 'Pagbukud-bukurin ayon sa Petsa';

  @override
  String get sortBy => 'Pagbukud-bukurin';

  @override
  String get trackInformation => 'Impormasyon ng Track';

  @override
  String get removeFromLibrary => 'Alisin mula sa Library';

  @override
  String get showInFolder => 'Ipakita sa Folder';

  @override
  String get unknownArtist => 'Hindi Kilalang Artista';

  @override
  String get unknownAlbum => 'Hindi Kilalang Album';

  @override
  String get importedFiles => 'Mga Na-import na File';

  @override
  String get playFolder => 'I-play ang Folder';

  @override
  String get shuffleFolder => 'I-shuffle ang Folder';

  @override
  String get playAll => 'I-play Lahat';

  @override
  String get includeSubfolders => 'Isama ang mga Subfolder';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count track',
      one: '1 track',
      zero: '0 track',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Walang nahanap na mga lokal na kanta';

  @override
  String get searchLocalMusic => 'Maghanap ng lokal na musika...';

  @override
  String get viewAsList => 'Tingnan bilang Listahan';

  @override
  String get viewAsGrid => 'Tingnan bilang Grid';

  @override
  String get trackInfoPath => 'Landas';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Tagal';

  @override
  String get aboutDescription => 'Isang libre at open-source na media player.';

  @override
  String get aboutApp => 'Tungkol sa PPPlayer';

  @override
  String get appTagline => 'Iyong musika. Iyong paraan.';

  @override
  String get exploreApp => 'Tuklasin ang PPPlayer';

  @override
  String get viewSource => 'Tingnan ang source';

  @override
  String get seeWhatsNew => 'Tingnan ang bago';

  @override
  String get getHelp => 'Kumuha ng tulong';

  @override
  String versionInfo(Object version, Object build) {
    return 'Bersyon $version (Build $build)';
  }

  @override
  String get createdBy => 'Ginawa ni Lucas Coelho';

  @override
  String get website => 'Website';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Mga tala sa paglabas';

  @override
  String get support => 'Suporta';

  @override
  String get license => 'Lisensya';

  @override
  String get acknowledgments => 'Mga Pagkilala';

  @override
  String get close => 'Isara';

  @override
  String copyright(Object year) {
    return '© $year Mga nag-ambag sa PPPlayer';
  }

  @override
  String get goodMorning => 'Magandang umaga';

  @override
  String get goodAfternoon => 'Magandang hapon';

  @override
  String get goodEvening => 'Magandang gabi';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Naghihintay ang musika mo.';

  @override
  String dailyMix(Object number) {
    return 'Araw-araw na Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Mga paborito mo\nat bagong nadiskubre';

  @override
  String get discoverWeekly => 'Tuklasin Linggo-linggo';

  @override
  String get releaseRadar => 'Radar ng Relis';

  @override
  String get newMusicJustForYou => 'Bagong musika\npara sa iyo';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Mag-relax at magpahinga';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity =>
      'Matinding pokus\nat pagiging produktibo';

  @override
  String artistRadio(Object artist) {
    return '$artist Radyo';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radyo';
  }

  @override
  String get filterAll => 'Lahat';

  @override
  String get filterPlaylists => 'Mga Playlist';

  @override
  String get filterArtists => 'Mga Artista';

  @override
  String get filterAlbums => 'Mga Album';

  @override
  String get filterStations => 'Mga Istasyon';

  @override
  String get filterStreams => 'Mga stream';

  @override
  String get localMusicCard => 'Lokal na Musika';

  @override
  String get createPlaylistButton => 'Gumawa ng Playlist';

  @override
  String get radioStations => 'Mga Istasyon ng Radyo';

  @override
  String get discoverMusic => 'Tuklasin ang Musika';

  @override
  String get importLocalMusic => 'I-import ang Lokal na Musika';

  @override
  String get importAudioFiles => 'I-import ang Mga Audio File';

  @override
  String get importFolder => 'I-import ang Folder';

  @override
  String get importFolderSubtitle =>
      'Pumili ng folder na naglalaman ng mga audio file';

  @override
  String get importPlaylist => 'Mag-import ng playlist';

  @override
  String get importPlaylistSubtitle => 'Mag-import ng .m3u o .m3u8 file';

  @override
  String get exportPlaylist => 'I-export ang playlist';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Hindi suportadong format o sira ang file';

  @override
  String get playbackErrorFileInaccessible =>
      'Hindi ma-access o hindi mahanap ang file';

  @override
  String get localVideosCard => 'Mga Lokal na Video';

  @override
  String get noLocalVideos => 'Walang nahanap na mga video';

  @override
  String get searchLocalVideos => 'Maghanap ng mga lokal na video';

  @override
  String get addVideos => 'Magdagdag ng mga video';

  @override
  String get subtitles => 'Mga Subtitle';

  @override
  String get audioTracks => 'Mga Audio Track';

  @override
  String get loadSubtitleFile => 'Mag-load ng file ng subtitle...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Error sa pag-load ng subtitle: $error';
  }

  @override
  String get off => 'Naka-off';
}
