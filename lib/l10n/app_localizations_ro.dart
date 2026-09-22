// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUME';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTIȘTI';

  @override
  String get artwork => 'COPERTĂ';

  @override
  String get appVersion => 'Versiunea aplicației';

  @override
  String get artist => 'Artist';

  @override
  String get artistsYouFollow => 'Artiști pe care îi urmărești';

  @override
  String get autoplay => 'Redare automată';

  @override
  String get becauseYouListenedTo => 'Pentru că ai ascultat';

  @override
  String get browseAll => 'Răsfoiește tot';

  @override
  String get cancel => 'Anulează';

  @override
  String get clearAppCache => 'Golești memoria cache a aplicației?';

  @override
  String get clearCache => 'Golește memoria cache';

  @override
  String get clearHistory => 'Ștergi istoricul?';

  @override
  String get clearRecentlyPlayed => 'Șterge ascultate recent';

  @override
  String get contentMarket => 'Piața de conținut';

  @override
  String get continueListening => 'Continuă ascultarea';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continuă redarea video într-o fereastră mică';

  @override
  String get create => 'Creează';

  @override
  String get createAPlaylistToGetStarted =>
      'Creează un playlist pentru a începe';

  @override
  String currentSelectedcountry(Object country) {
    return 'Curent: $country';
  }

  @override
  String get deletePlaylist => 'Șterge playlistul';

  @override
  String get editProfile => 'Editează profilul';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Eroare la încărcarea piețelor: $err';
  }

  @override
  String error(Object error) {
    return 'Eroare: $error';
  }

  @override
  String explore(Object genre) {
    return 'Explorează $genre';
  }

  @override
  String get fansAlsoLike => 'FANILOR LE MAI PLACE';

  @override
  String featuringTouppercase(Object artist) {
    return 'ÎMPREUNĂ CU $artist';
  }

  @override
  String get featuredPlaylists => 'Playlisturi recomandate';

  @override
  String get followArtistsToSeeThemHere =>
      'Urmărește artiști pentru a-i vedea aici';

  @override
  String get followStationsToSeeThemHere =>
      'Urmărește stații pentru a le vedea aici';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forțează redarea doar audio pentru a economisi date';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Eliberează spațiu și forțează date noi la următoarea încărcare';

  @override
  String get fromYourFavorites => 'Din favoritele tale';

  @override
  String get goBack => 'Înapoi';

  @override
  String inspiredByName(Object name) {
    return 'Inspirat de $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Continuă redarea pieselor similare când coada se termină';

  @override
  String get library => 'Bibliotecă';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Apreciază albume pentru a le vedea aici';

  @override
  String get likedSongs => 'Melodii apreciate';

  @override
  String get lowDataMode => 'Mod de economisire a datelor';

  @override
  String get madeForYou => 'Creat pentru tine';

  @override
  String moreLikeName(Object name) {
    return 'Mai mult ca $name';
  }

  @override
  String get moreOptions => 'Mai multe opțiuni';

  @override
  String get nameYourMasterpiece => 'Dă un nume capodoperei tale...';

  @override
  String get newPlaylist => 'Playlist nou';

  @override
  String get newReleases => 'Lansări noi';

  @override
  String get next => 'Următorul';

  @override
  String get noAlbumsFound => 'Niciun album găsit';

  @override
  String get noArtistsFollowed => 'Niciun artist urmărit';

  @override
  String get noArtistsFound => 'Niciun artist găsit';

  @override
  String get noLikedAlbums => 'Niciun album apreciat';

  @override
  String get noPlaylistsFound => 'Niciun playlist găsit';

  @override
  String get noPlaylistsYet => 'Niciun playlist momentan';

  @override
  String get noResultsFound => 'Niciun rezultat găsit';

  @override
  String get noStationsFollowed => 'Nicio stație urmărită';

  @override
  String get noTrackPlaying => 'Nicio melodie în redare';

  @override
  String get noTracksFound => 'Nicio melodie găsită';

  @override
  String get playlists => 'PLAYLISTURI';

  @override
  String get popular => 'POPULAR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Șterge definitiv istoricul de ascultare';

  @override
  String get pictureinpicturePip => 'Imagine în imagine (PiP)';

  @override
  String get popularAlbums => 'Albume populare';

  @override
  String get popularArtists => 'Artiști populari';

  @override
  String get popularGenres => 'Genuri populare';

  @override
  String get popularSongs => 'Melodii populare';

  @override
  String get popularTracks => 'Piese populare';

  @override
  String get popularHitsRightNow => 'Hituri populare acum';

  @override
  String get previous => 'Anterior';

  @override
  String get queue => 'COADĂ';

  @override
  String get recentSearches => 'Căutări recente';

  @override
  String get recommendedForYou => 'Recomandat pentru tine';

  @override
  String get scraping => 'Se preiau date';

  @override
  String get search => 'Caută';

  @override
  String get searchInAlbum => 'Caută în album...';

  @override
  String get searchInLibrary => 'Caută în bibliotecă...';

  @override
  String get searchInPlaylist => 'Caută în playlist';

  @override
  String get searchLikedSongs => 'Caută melodii apreciate...';

  @override
  String get searchPopularSongs => 'Caută melodii populare...';

  @override
  String get selectMarket => 'Selectează piața';

  @override
  String get settings => 'Setări';

  @override
  String get showVideoPlayer => 'Arată playerul video';

  @override
  String get shuffle => 'Amestecă';

  @override
  String get spotifyCredentials => 'Date de conectare Spotify';

  @override
  String get suggestedStations => 'Stații sugerate';

  @override
  String get tracks => 'PIESE';

  @override
  String get trending => 'În tendințe';

  @override
  String get tryAgain => 'Încearcă din nou';

  @override
  String get tryADifferentSearchTerm => 'Încearcă un alt termen de căutare';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Folosește playerul YouTube când este disponibil';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Ce vrei să asculți?';

  @override
  String get youtubeCredentials => 'Date de conectare YouTube';

  @override
  String get yourLibrary => 'Biblioteca ta';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Adaugă în playlist';

  @override
  String get addToQueue => 'Adaugă în coadă';

  @override
  String get copyId => 'Copiază ID-ul';

  @override
  String get copyLink => 'Copiază linkul';

  @override
  String get discover => 'Descoperă';

  @override
  String get enterYourName => 'Introdu numele tău';

  @override
  String get favorites => 'Favorite';

  @override
  String get goToAlbum => 'Mergi la album';

  @override
  String get goToArtist => 'Mergi la artist';

  @override
  String get goToArtistRadio => 'Mergi la radioul artistului';

  @override
  String get goToPlaylist => 'Mergi la playlist';

  @override
  String get goToSongRadio => 'Mergi la radioul piesei';

  @override
  String get home => 'Acasă';

  @override
  String get myAwesomePlaylist => 'Playlistul meu grozav';

  @override
  String get myPlaylist => 'Playlistul meu';

  @override
  String get newPlaylist1 => 'Playlist nou';

  @override
  String get play => 'Redă';

  @override
  String get playStation => 'Redă stația';

  @override
  String get playNext => 'Redă următorul';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Numele playlistului';

  @override
  String get playlists1 => 'Playlisturi';

  @override
  String get queue1 => 'Coadă';

  @override
  String get recentlyPlayed => 'Ascultate recent';

  @override
  String get removeFromQueue => 'Elimină din coadă';

  @override
  String get retry => 'Încearcă din nou';

  @override
  String get searchMusicArtistsAlbums => 'Caută muzică, artiști, albume...';

  @override
  String get share => 'Distribuie';

  @override
  String featuringArtist(String artistName) {
    return 'ÎMPREUNĂ CU $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Curent: $country';
  }

  @override
  String get queueTooltip => 'Coadă';

  @override
  String get searchHint => 'Caută muzică, artiști, albume...';

  @override
  String get language => 'Limbă';

  @override
  String get systemDefault => 'Setarea sistemului';

  @override
  String get songsTab => 'Melodii';

  @override
  String get foldersTab => 'Dosare';

  @override
  String get artistsTab => 'Artiști';

  @override
  String get albumsTab => 'Albume';

  @override
  String get genresTab => 'Genuri';

  @override
  String get noLocalGenres => 'Niciun gen găsit';

  @override
  String get playbackSpeed => 'Viteza de redare';

  @override
  String get addMusic => 'Adaugă muzică';

  @override
  String get addFiles => 'Adaugă fișiere';

  @override
  String get addFolder => 'Adaugă un dosar';

  @override
  String get rescanLibrary => 'Rescanează biblioteca';

  @override
  String get sortTitle => 'Titlu';

  @override
  String get sortArtist => 'Artist';

  @override
  String get sortAlbum => 'Album';

  @override
  String get sortDuration => 'Durată';

  @override
  String get sortDateAdded => 'Data adăugării';

  @override
  String get sortBy => 'Sortează după';

  @override
  String get trackInformation => 'Informații despre piesă';

  @override
  String get removeFromLibrary => 'Elimină din bibliotecă';

  @override
  String get showInFolder => 'Arată în dosar';

  @override
  String get unknownArtist => 'Artist necunoscut';

  @override
  String get unknownAlbum => 'Album necunoscut';

  @override
  String get importedFiles => 'Fișiere importate';

  @override
  String get playFolder => 'Redă dosarul';

  @override
  String get shuffleFolder => 'Amestecă dosarul';

  @override
  String get playAll => 'Redă tot';

  @override
  String get includeSubfolders => 'Include subdosarele';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de piese',
      few: '$count piese',
      one: '1 piesă',
      zero: '0 piese',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Nu ai importat muzică locală';

  @override
  String get searchLocalMusic => 'Caută muzică locală';

  @override
  String get viewAsList => 'Vezi ca listă';

  @override
  String get viewAsGrid => 'Vezi ca grilă';

  @override
  String get trackInfoPath => 'Cale';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Durată';

  @override
  String get aboutDescription => 'Un media player gratuit, open-source.';

  @override
  String get aboutApp => 'Despre PPPlayer';

  @override
  String get appTagline => 'Muzica ta. În felul tău.';

  @override
  String get exploreApp => 'Explorează PPPlayer';

  @override
  String get viewSource => 'Vezi codul sursă';

  @override
  String get seeWhatsNew => 'Vezi noutățile';

  @override
  String get getHelp => 'Obține ajutor';

  @override
  String versionInfo(Object version, Object build) {
    return 'Versiunea $version (Build $build)';
  }

  @override
  String get createdBy => 'Creat de Lucas Coelho';

  @override
  String get website => 'Site web';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Note de lansare';

  @override
  String get support => 'Asistență';

  @override
  String get license => 'Licență';

  @override
  String get acknowledgments => 'Mulțumiri';

  @override
  String get close => 'Închide';

  @override
  String copyright(Object year) {
    return '© $year Contribuitorii PPPlayer';
  }

  @override
  String get goodMorning => 'Bună dimineața';

  @override
  String get goodAfternoon => 'Bună ziua';

  @override
  String get goodEvening => 'Bună seara';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Muzica te așteaptă.';

  @override
  String dailyMix(Object number) {
    return 'Mixul tău zilnic $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Favoritele tale\nși noi descoperiri';

  @override
  String get discoverWeekly => 'Descoperiri săptămânale';

  @override
  String get releaseRadar => 'Radar de lansări';

  @override
  String get newMusicJustForYou => 'Muzică nouă\ndoar pentru tine';

  @override
  String get chillMix => 'Mix de relaxare';

  @override
  String get relaxAndUnwind => 'Relaxează-te și destinde-te';

  @override
  String get focusMix => 'Mix pentru concentrare';

  @override
  String get deepFocusAndProductivity =>
      'Concentrare profundă\nși productivitate';

  @override
  String artistRadio(Object artist) {
    return 'Radio $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'Radio $genre';
  }

  @override
  String get filterAll => 'Toate';

  @override
  String get filterPlaylists => 'Playlisturi';

  @override
  String get filterArtists => 'Artiști';

  @override
  String get filterAlbums => 'Albume';

  @override
  String get filterStations => 'Stații';

  @override
  String get filterStreams => 'Redări';

  @override
  String get localMusicCard => 'Muzică locală';

  @override
  String get createPlaylistButton => 'Creează playlist';

  @override
  String get radioStations => 'Posturi de radio';

  @override
  String get discoverMusic => 'Descoperă muzică';

  @override
  String get importLocalMusic => 'Importă muzică locală';

  @override
  String get importAudioFiles => 'Importă fișiere audio';

  @override
  String get importFolder => 'Importă dosar';

  @override
  String get importFolderSubtitle =>
      'Notă: Fișierele audio sunt ascunse în selectorul de dosare. Este un lucru normal.';

  @override
  String get importPlaylist => 'Importă playlist';

  @override
  String get importPlaylistSubtitle => 'Importă fișiere .m3u sau .m3u8';

  @override
  String get exportPlaylist => 'Exportă playlist';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Format neacceptat sau fișier corupt';

  @override
  String get playbackErrorFileInaccessible => 'Fișier inaccesibil sau lipsă';

  @override
  String get localVideosCard => 'Videoclipuri locale';

  @override
  String get noLocalVideos => 'Niciun videoclip găsit';

  @override
  String get searchLocalVideos => 'Caută videoclipuri locale';

  @override
  String get addVideos => 'Adaugă videoclipuri';

  @override
  String get subtitles => 'Subtitrări';

  @override
  String get audioTracks => 'Piese audio';

  @override
  String get loadSubtitleFile => 'Încarcă fișier de subtitrare...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Eroare la încărcarea subtitrării: $error';
  }

  @override
  String get off => 'Oprit';
}
