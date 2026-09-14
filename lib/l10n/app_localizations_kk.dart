// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'АЛЬБОМДАР';

  @override
  String get api => 'API';

  @override
  String get artists => 'ӘРТІСТЕР';

  @override
  String get artwork => 'МҰҚАБА';

  @override
  String get appVersion => 'Қолданба нұсқасы';

  @override
  String get artist => 'Әртіс';

  @override
  String get artistsYouFollow => 'Сіз жазылған әртістер';

  @override
  String get autoplay => 'Автоматты түрде ойнату';

  @override
  String get becauseYouListenedTo => 'Сіз тыңдағандықтан';

  @override
  String get browseAll => 'Барлығын шолу';

  @override
  String get cancel => 'Бас тарту';

  @override
  String get clearAppCache => 'Қолданба кэшін тазалау керек пе?';

  @override
  String get clearCache => 'Кэшті тазалау';

  @override
  String get clearHistory => 'Тарихты тазалау керек пе?';

  @override
  String get clearRecentlyPlayed => 'Жақында ойнатылғандарды тазалау';

  @override
  String get contentMarket => 'Мазмұн нарығы';

  @override
  String get continueListening => 'Тыңдауды жалғастыру';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Шағын терезеде бейне ойнатуды жалғастыру';

  @override
  String get create => 'Жасау';

  @override
  String get createAPlaylistToGetStarted =>
      'Бастау үшін ойнату тізімін жасаңыз';

  @override
  String currentSelectedcountry(Object country) {
    return 'Ағымдағы: $country';
  }

  @override
  String get deletePlaylist => 'Ойнату тізімін жою';

  @override
  String get editProfile => 'Профильді өңдеу';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Нарықтарды жүктеу қатесі: $err';
  }

  @override
  String error(Object error) {
    return 'Қате: $error';
  }

  @override
  String explore(Object genre) {
    return '$genre жанрын зерттеу';
  }

  @override
  String get fansAlsoLike => 'ЖАНКҮЙЕРЛЕРГЕ ДЕ ҰНАЙДЫ';

  @override
  String featuringTouppercase(Object artist) {
    return '$artist ҚАТЫСУЫМЕН';
  }

  @override
  String get featuredPlaylists => 'Таңдаулы ойнату тізімдері';

  @override
  String get followArtistsToSeeThemHere =>
      'Оларды осында көру үшін әртістерге жазылыңыз';

  @override
  String get followStationsToSeeThemHere =>
      'Оларды осында көру үшін станцияларға жазылыңыз';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Деректерді үнемдеу үшін тек аудио ағындарды мәжбүрлеу';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Орынды босатады және келесі жүктеу кезінде жаңа деректерді мәжбүрлейді';

  @override
  String get fromYourFavorites => 'Таңдаулыларыңыздан';

  @override
  String get goBack => 'Артқа қайту';

  @override
  String inspiredByName(Object name) {
    return '$name шабыттандырған';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Кезек аяқталған кезде ұқсас тректерді ойнатуды жалғастыру';

  @override
  String get library => 'Кітапхана';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Оларды осында көру үшін альбомдарға ұнату қойыңыз';

  @override
  String get likedSongs => 'Ұнаған өлеңдер';

  @override
  String get lowDataMode => 'Төмен деректер режимі';

  @override
  String get madeForYou => 'Сіз үшін жасалған';

  @override
  String moreLikeName(Object name) {
    return '$name сияқты көбірек';
  }

  @override
  String get moreOptions => 'Қосымша опциялар';

  @override
  String get nameYourMasterpiece => 'Жауһарыңызды атаңыз...';

  @override
  String get newPlaylist => 'Жаңа ойнату тізімі';

  @override
  String get newReleases => 'Жаңа шығарылымдар';

  @override
  String get next => 'Келесі';

  @override
  String get noAlbumsFound => 'Альбомдар табылмады';

  @override
  String get noArtistsFollowed => 'Жазылған әртістер жоқ';

  @override
  String get noArtistsFound => 'Әртістер табылмады';

  @override
  String get noLikedAlbums => 'Ұнаған альбомдар жоқ';

  @override
  String get noPlaylistsFound => 'Ойнату тізімдері табылмады';

  @override
  String get noPlaylistsYet => 'Әзірге ойнату тізімдері жоқ';

  @override
  String get noResultsFound => 'Нәтижелер табылмады';

  @override
  String get noStationsFollowed => 'Жазылған станциялар жоқ';

  @override
  String get noTrackPlaying => 'Ешқандай трек ойнатылып тұрған жоқ';

  @override
  String get noTracksFound => 'Тректер табылмады';

  @override
  String get playlists => 'ОЙНАТУ ТІЗІМДЕРІ';

  @override
  String get popular => 'ТАНЫМАЛ';

  @override
  String get permanentlyRemoveListeningHistory => 'Тыңдау тарихын біржола жою';

  @override
  String get pictureinpicturePip => 'Сурет ішіндегі сурет (PiP)';

  @override
  String get popularAlbums => 'Танымал альбомдар';

  @override
  String get popularArtists => 'Танымал әртістер';

  @override
  String get popularGenres => 'Танымал жанрлар';

  @override
  String get popularSongs => 'Танымал өлеңдер';

  @override
  String get popularTracks => 'Танымал тректер';

  @override
  String get popularHitsRightNow => 'Қазіргі танымал хиттер';

  @override
  String get previous => 'Алдыңғы';

  @override
  String get queue => 'КЕЗЕК';

  @override
  String get recentSearches => 'Соңғы іздеулер';

  @override
  String get recommendedForYou => 'Сізге ұсынылған';

  @override
  String get scraping => 'Қырнау';

  @override
  String get search => 'Іздеу';

  @override
  String get searchInAlbum => 'Альбомнан іздеу...';

  @override
  String get searchInLibrary => 'Кітапханадан іздеу...';

  @override
  String get searchInPlaylist => 'Ойнату тізімінен іздеу';

  @override
  String get searchLikedSongs => 'Ұнаған өлеңдерден іздеу...';

  @override
  String get searchPopularSongs => 'Танымал өлеңдерден іздеу...';

  @override
  String get selectMarket => 'Нарықты таңдау';

  @override
  String get settings => 'Параметрлер';

  @override
  String get showVideoPlayer => 'Бейне ойнатқышты көрсету';

  @override
  String get shuffle => 'Араластыру';

  @override
  String get spotifyCredentials => 'Spotify тіркелгі деректері';

  @override
  String get suggestedStations => 'Ұсынылған станциялар';

  @override
  String get tracks => 'ТРЕКТЕР';

  @override
  String get trending => 'Трендте';

  @override
  String get tryAgain => 'Қайта көріңіз';

  @override
  String get tryADifferentSearchTerm => 'Басқа іздеу терминін байқап көріңіз';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Қолжетімді болған кезде YouTube ойнатқышын пайдалану';

  @override
  String get video => 'БЕЙНЕ';

  @override
  String get whatDoYouWantToListenTo => 'Не тыңдағыңыз келеді?';

  @override
  String get youtubeCredentials => 'YouTube тіркелгі деректері';

  @override
  String get yourLibrary => 'Сіздің кітапханаңыз';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Ойнату тізіміне қосу';

  @override
  String get addToQueue => 'Кезекке қосу';

  @override
  String get copyId => 'ID көшіру';

  @override
  String get copyLink => 'Сілтемені көшіру';

  @override
  String get discover => 'Ашу';

  @override
  String get enterYourName => 'Атыңызды енгізіңіз';

  @override
  String get favorites => 'Таңдаулылар';

  @override
  String get goToAlbum => 'Альбомға өту';

  @override
  String get goToArtist => 'Әртіске өту';

  @override
  String get goToArtistRadio => 'Әртіс радиосына өту';

  @override
  String get goToPlaylist => 'Ойнату тізіміне өту';

  @override
  String get goToSongRadio => 'Өлең радиосына өту';

  @override
  String get home => 'Басты бет';

  @override
  String get myAwesomePlaylist => 'Менің керемет ойнату тізімім';

  @override
  String get myPlaylist => 'Менің ойнату тізімім';

  @override
  String get newPlaylist1 => 'Жаңа ойнату тізімі';

  @override
  String get play => 'Ойнату';

  @override
  String get playStation => 'Станцияны ойнату';

  @override
  String get playNext => 'Келесіні ойнату';

  @override
  String get playlist => 'Ойнату тізімі';

  @override
  String get playlistName => 'Ойнату тізімінің атауы';

  @override
  String get playlists1 => 'Ойнату тізімдері';

  @override
  String get queue1 => 'Кезек';

  @override
  String get recentlyPlayed => 'Жақында ойнатылған';

  @override
  String get removeFromQueue => 'Кезектен өшіру';

  @override
  String get retry => 'Қайталау';

  @override
  String get searchMusicArtistsAlbums => 'Музыка, әртістер, альбомдар іздеу...';

  @override
  String get share => 'Бөлісу';

  @override
  String featuringArtist(String artistName) {
    return '$artistName ҚАТЫСУЫМЕН';
  }

  @override
  String currentCountry(String country) {
    return 'Ағымдағы: $country';
  }

  @override
  String get queueTooltip => 'Кезек';

  @override
  String get searchHint => 'Музыка, әртістер, альбомдар іздеу...';

  @override
  String get language => 'Тіл';

  @override
  String get systemDefault => 'Жүйелік әдепкі';

  @override
  String get songsTab => 'Songs';

  @override
  String get foldersTab => 'Folders';

  @override
  String get artistsTab => 'Artists';

  @override
  String get albumsTab => 'Albums';

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
  String get aboutDescription =>
      'Тегін және ашық бастапқы кодты музыкалық ойнатқыш.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Нұсқасы $version (Құрастыру $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho жасаған';

  @override
  String get website => 'Веб-сайт';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Шығарылым жазбалары';

  @override
  String get support => 'Қолдау';

  @override
  String get license => 'Лицензия';

  @override
  String get acknowledgments => 'Алғыстар';

  @override
  String get close => 'Жабу';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
  }
}
