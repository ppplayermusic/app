// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title، $subtitle';
  }

  @override
  String get albums => 'البمز';

  @override
  String get api => 'API';

  @override
  String get artists => 'فنکار';

  @override
  String get artwork => 'آرٹ ورک';

  @override
  String get appVersion => 'ایپ کا ورژن';

  @override
  String get artist => 'فنکار';

  @override
  String get artistsYouFollow => 'فنکار جنہیں آپ فالو کرتے ہیں';

  @override
  String get autoplay => 'خودکار پلے';

  @override
  String get becauseYouListenedTo => 'کیونکہ آپ نے سنا ہے';

  @override
  String get browseAll => 'سبھی براؤز کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get clearAppCache => 'کیا ایپ کیشے صاف کریں؟';

  @override
  String get clearCache => 'کیشے صاف کریں';

  @override
  String get clearHistory => 'کیا ہسٹری صاف کریں؟';

  @override
  String get clearRecentlyPlayed => 'حال ہی میں چلائی گئی ہسٹری صاف کریں';

  @override
  String get contentMarket => 'مواد کی مارکیٹ';

  @override
  String get continueListening => 'سننا جاری رکھیں';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'چھوٹی ونڈو میں ویڈیو پلے بیک جاری رکھیں';

  @override
  String get create => 'بنائیں';

  @override
  String get createAPlaylistToGetStarted =>
      'شروع کرنے کے لیے ایک پلے لسٹ بنائیں';

  @override
  String currentSelectedcountry(Object country) {
    return 'موجودہ: $country';
  }

  @override
  String get deletePlaylist => 'پلے لسٹ حذف کریں';

  @override
  String get editProfile => 'پروفائل میں ترمیم کریں';

  @override
  String errorLoadingMarkets(Object err) {
    return 'مارکیٹس لوڈ کرنے میں خامی: $err';
  }

  @override
  String error(Object error) {
    return 'خامی: $error';
  }

  @override
  String explore(Object genre) {
    return 'دریافت کریں $genre';
  }

  @override
  String get fansAlsoLike => 'شائقین یہ بھی پسند کرتے ہیں';

  @override
  String featuringTouppercase(Object artist) {
    return '$artist کی پیشکش';
  }

  @override
  String get featuredPlaylists => 'نمایاں پلے لسٹس';

  @override
  String get followArtistsToSeeThemHere =>
      'یہاں دیکھنے کے لیے فنکاروں کو فالو کریں';

  @override
  String get followStationsToSeeThemHere =>
      'یہاں دیکھنے کے لیے اسٹیشنز کو فالو کریں';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'ڈیٹا بچانے کے لیے صرف آڈیو اسٹریمز کو مجبور کریں';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'جگہ خالی کرتا ہے اور اگلی لوڈنگ پر تازہ ڈیٹا مجبور کرتا ہے';

  @override
  String get fromYourFavorites => 'آپ کی پسندیدہ فہرست سے';

  @override
  String get goBack => 'واپس جائیں';

  @override
  String inspiredByName(Object name) {
    return '$name سے متاثر ہو کر';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'جب قطار ختم ہو تو اسی طرح کے ٹریکس چلانا جاری رکھیں';

  @override
  String get library => 'لائبریری';

  @override
  String get likeAlbumsToSeeThemHere => 'البمز کو یہاں دیکھنے کے لیے پسند کریں';

  @override
  String get likedSongs => 'پسندیدہ گانے';

  @override
  String get lowDataMode => 'کم ڈیٹا موڈ';

  @override
  String get madeForYou => 'آپ کے لیے بنایا گیا';

  @override
  String moreLikeName(Object name) {
    return 'مزید $name کی طرح';
  }

  @override
  String get moreOptions => 'مزید اختیارات';

  @override
  String get nameYourMasterpiece => 'اپنے شاہکار کا نام رکھیں...';

  @override
  String get newPlaylist => 'نئی پلے لسٹ';

  @override
  String get newReleases => 'نئی ریلیز';

  @override
  String get next => 'اگلا';

  @override
  String get noAlbumsFound => 'کوئی البمز نہیں ملے';

  @override
  String get noArtistsFollowed => 'کسی فنکار کو فالو نہیں کیا گیا';

  @override
  String get noArtistsFound => 'کوئی فنکار نہیں ملے';

  @override
  String get noLikedAlbums => 'کوئی پسندیدہ البمز نہیں ہیں';

  @override
  String get noPlaylistsFound => 'کوئی پلے لسٹس نہیں ملیں';

  @override
  String get noPlaylistsYet => 'ابھی تک کوئی پلے لسٹس نہیں ہیں';

  @override
  String get noResultsFound => 'کوئی نتائج نہیں ملے';

  @override
  String get noStationsFollowed => 'کسی اسٹیشن کو فالو نہیں کیا گیا';

  @override
  String get noTrackPlaying => 'کوئی ٹریک نہیں چل رہا ہے';

  @override
  String get noTracksFound => 'کوئی ٹریکس نہیں ملے';

  @override
  String get playlists => 'پلے لسٹس';

  @override
  String get popular => 'مقبول';

  @override
  String get permanentlyRemoveListeningHistory =>
      'سننے کی ہسٹری کو مستقل طور پر ہٹائیں';

  @override
  String get pictureinpicturePip => 'تصویر میں تصویر (PiP)';

  @override
  String get popularAlbums => 'مقبول البمز';

  @override
  String get popularArtists => 'مقبول فنکار';

  @override
  String get popularGenres => 'مقبول انواع';

  @override
  String get popularSongs => 'مقبول گانے';

  @override
  String get popularTracks => 'مقبول ٹریکس';

  @override
  String get popularHitsRightNow => 'اس وقت کے مقبول ہٹس';

  @override
  String get previous => 'پچھلا';

  @override
  String get queue => 'قطار';

  @override
  String get recentSearches => 'حالیہ تلاشیں';

  @override
  String get recommendedForYou => 'آپ کے لیے تجویز کردہ';

  @override
  String get scraping => 'سکریپنگ جاری ہے';

  @override
  String get search => 'تلاش کریں';

  @override
  String get searchInAlbum => 'البم میں تلاش کریں...';

  @override
  String get searchInLibrary => 'لائبریری میں تلاش کریں...';

  @override
  String get searchInPlaylist => 'پلے لسٹ میں تلاش کریں';

  @override
  String get searchLikedSongs => 'پسندیدہ گانے تلاش کریں...';

  @override
  String get searchPopularSongs => 'مقبول گانے تلاش کریں...';

  @override
  String get selectMarket => 'مارکیٹ منتخب کریں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get showVideoPlayer => 'ویڈیو پلیئر دکھائیں';

  @override
  String get shuffle => 'شفل';

  @override
  String get spotifyCredentials => 'Spotify کی اسناد';

  @override
  String get suggestedStations => 'تجویز کردہ اسٹیشنز';

  @override
  String get tracks => 'ٹریکس';

  @override
  String get trending => 'ٹرینڈنگ';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get tryADifferentSearchTerm => 'ایک مختلف تلاش کی اصطلاح آزمائیں';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'دستیاب ہونے پر یوٹیوب پلیئر کا استعمال کریں';

  @override
  String get video => 'ویڈیو';

  @override
  String get whatDoYouWantToListenTo => 'آپ کیا سننا چاہتے ہیں؟';

  @override
  String get youtubeCredentials => 'یوٹیوب کی اسناد';

  @override
  String get yourLibrary => 'آپ کی لائبریری';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'پلے لسٹ میں شامل کریں';

  @override
  String get addToQueue => 'قطار میں شامل کریں';

  @override
  String get copyId => 'آئی ڈی کاپی کریں';

  @override
  String get copyLink => 'لنک کاپی کریں';

  @override
  String get discover => 'دریافت کریں';

  @override
  String get enterYourName => 'اپنا نام درج کریں';

  @override
  String get favorites => 'پسندیدہ';

  @override
  String get goToAlbum => 'البم پر جائیں';

  @override
  String get goToArtist => 'فنکار پر جائیں';

  @override
  String get goToArtistRadio => 'فنکار کے ریڈیو پر جائیں';

  @override
  String get goToPlaylist => 'پلے لسٹ پر جائیں';

  @override
  String get goToSongRadio => 'گانے کے ریڈیو پر جائیں';

  @override
  String get home => 'ہوم';

  @override
  String get myAwesomePlaylist => 'میری شاندار پلے لسٹ';

  @override
  String get myPlaylist => 'میری پلے لسٹ';

  @override
  String get newPlaylist1 => 'نئی پلے لسٹ';

  @override
  String get play => 'چلائیں';

  @override
  String get playStation => 'اسٹیشن چلائیں';

  @override
  String get playNext => 'اگلا چلائیں';

  @override
  String get playlist => 'پلے لسٹ';

  @override
  String get playlistName => 'پلے لسٹ کا نام';

  @override
  String get playlists1 => 'پلے لسٹس';

  @override
  String get queue1 => 'قطار';

  @override
  String get recentlyPlayed => 'حال ہی میں چلایا گیا';

  @override
  String get removeFromQueue => 'قطار سے ہٹائیں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get searchMusicArtistsAlbums =>
      'موسیقی، فنکاروں، البمز کو تلاش کریں...';

  @override
  String get share => 'شیئر کریں';

  @override
  String featuringArtist(String artistName) {
    return '$artistName کی پیشکش';
  }

  @override
  String currentCountry(String country) {
    return 'موجودہ: $country';
  }

  @override
  String get queueTooltip => 'قطار';

  @override
  String get searchHint => 'موسیقی، فنکاروں، البمز کو تلاش کریں...';

  @override
  String get language => 'زبان';

  @override
  String get systemDefault => 'سسٹم ڈیفالٹ';

  @override
  String get songsTab => 'گانے';

  @override
  String get foldersTab => 'فولڈرز';

  @override
  String get artistsTab => 'فنکار';

  @override
  String get albumsTab => 'البمز';

  @override
  String get genresTab => 'انواع';

  @override
  String get noLocalGenres => 'کوئی انواع نہیں ملیں';

  @override
  String get playbackSpeed => 'پلے بیک کی رفتار';

  @override
  String get addMusic => 'موسیقی شامل کریں';

  @override
  String get addFiles => 'فائلیں شامل کریں';

  @override
  String get addFolder => 'فولڈر شامل کریں';

  @override
  String get rescanLibrary => 'لائبریری کو دوبارہ اسکین کریں';

  @override
  String get sortTitle => 'عنوان';

  @override
  String get sortArtist => 'فنکار';

  @override
  String get sortAlbum => 'البم';

  @override
  String get sortDuration => 'دورانیہ';

  @override
  String get sortDateAdded => 'شامل کرنے کی تاریخ';

  @override
  String get sortBy => 'اس کے لحاظ سے ترتیب دیں';

  @override
  String get trackInformation => 'ٹریک کی معلومات';

  @override
  String get removeFromLibrary => 'لائبریری سے ہٹائیں';

  @override
  String get showInFolder => 'فولڈر میں دکھائیں';

  @override
  String get unknownArtist => 'نامعلوم فنکار';

  @override
  String get unknownAlbum => 'نامعلوم البم';

  @override
  String get importedFiles => 'درآمد شدہ فائلیں';

  @override
  String get playFolder => 'فولڈر چلائیں';

  @override
  String get shuffleFolder => 'فولڈر کو شفل کریں';

  @override
  String get playAll => 'سب چلائیں';

  @override
  String get includeSubfolders => 'ذیلی فولڈرز شامل کریں';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ٹریکس',
      one: '1 ٹریک',
      zero: '0 ٹریکس',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'کوئی مقامی گانے درآمد نہیں کیے گئے';

  @override
  String get searchLocalMusic => 'مقامی موسیقی تلاش کریں';

  @override
  String get viewAsList => 'فہرست کے طور پر دیکھیں';

  @override
  String get viewAsGrid => 'گرڈ کے طور پر دیکھیں';

  @override
  String get trackInfoPath => 'پاتھ';

  @override
  String get trackInfoFormat => 'فارمیٹ';

  @override
  String get trackInfoDuration => 'دورانیہ';

  @override
  String get aboutDescription => 'ایک مفت، اوپن سورس میڈیا پلیئر۔';

  @override
  String get aboutApp => 'PPPlayer کے بارے میں';

  @override
  String get appTagline => 'آپ کی موسیقی۔ آپ کا طریقہ۔';

  @override
  String get exploreApp => 'PPPlayer دریافت کریں';

  @override
  String get viewSource => 'سورس دیکھیں';

  @override
  String get seeWhatsNew => 'دیکھیں نیا کیا ہے';

  @override
  String get getHelp => 'مدد حاصل کریں';

  @override
  String versionInfo(Object version, Object build) {
    return 'ورژن $version (بلڈ $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho نے بنایا';

  @override
  String get website => 'ویب سائٹ';

  @override
  String get github => 'گٹ ہب';

  @override
  String get releaseNotes => 'ریلیز نوٹس';

  @override
  String get support => 'سپورٹ';

  @override
  String get license => 'لائسنس';

  @override
  String get acknowledgments => 'اعترافات';

  @override
  String get close => 'بند کریں';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer کے معاونین';
  }

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'دوپہر بخیر';

  @override
  String get goodEvening => 'شام بخیر';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting، $name';
  }

  @override
  String get yourMusicIsWaiting => 'آپ کی موسیقی منتظر ہے۔';

  @override
  String dailyMix(Object number) {
    return 'ڈیلی مکس $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'آپ کی پسندیدہ\nاور نئی دریافتیں';

  @override
  String get discoverWeekly => 'ہفتہ وار دریافت کریں';

  @override
  String get releaseRadar => 'ریلیز ریڈار';

  @override
  String get newMusicJustForYou => 'نئی موسیقی\nصرف آپ کے لیے';

  @override
  String get chillMix => 'چِل مکس';

  @override
  String get relaxAndUnwind => 'آرام کریں اور سکون پائیں';

  @override
  String get focusMix => 'فوکس مکس';

  @override
  String get deepFocusAndProductivity => 'گہرا فوکس\nاور پیداواریت';

  @override
  String artistRadio(Object artist) {
    return '$artist کا ریڈیو';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre کا ریڈیو';
  }

  @override
  String get filterAll => 'سبھی';

  @override
  String get filterPlaylists => 'پلے لسٹس';

  @override
  String get filterArtists => 'فنکار';

  @override
  String get filterAlbums => 'البمز';

  @override
  String get filterStations => 'اسٹیشنز';

  @override
  String get filterStreams => 'اسٹریمز';

  @override
  String get localMusicCard => 'مقامی موسیقی';

  @override
  String get createPlaylistButton => 'پلے لسٹ بنائیں';

  @override
  String get radioStations => 'ریڈیو اسٹیشنز';

  @override
  String get discoverMusic => 'موسیقی دریافت کریں';

  @override
  String get importLocalMusic => 'مقامی موسیقی درآمد کریں';

  @override
  String get importAudioFiles => 'آڈیو فائلیں درآمد کریں';

  @override
  String get importFolder => 'فولڈر درآمد کریں';

  @override
  String get importFolderSubtitle =>
      'نوٹ: آڈیو فائلیں فولڈر چننے والے میں چھپی ہوئی ہیں۔ یہ معمول کی بات ہے۔';

  @override
  String get importPlaylist => 'پلے لسٹ درآمد کریں';

  @override
  String get importPlaylistSubtitle => '.m3u یا .m3u8 فائلیں درآمد کریں';

  @override
  String get exportPlaylist => 'پلے لسٹ برآمد کریں';

  @override
  String get playbackErrorUnsupportedFormat =>
      'غیر تعاون یافتہ فارمیٹ یا خراب فائل';

  @override
  String get playbackErrorFileInaccessible =>
      'فائل تک رسائی ممکن نہیں یا نہیں ملی';

  @override
  String get localVideosCard => 'مقامی ویڈیوز';

  @override
  String get noLocalVideos => 'کوئی ویڈیوز نہیں ملیں';

  @override
  String get searchLocalVideos => 'مقامی ویڈیوز تلاش کریں';

  @override
  String get addVideos => 'ویڈیوز شامل کریں';

  @override
  String get subtitles => 'سب ٹائٹلز';

  @override
  String get audioTracks => 'آڈیو ٹریکس';

  @override
  String get loadSubtitleFile => 'سب ٹائٹل فائل لوڈ کریں...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'سب ٹائٹل لوڈ کرنے میں خامی: $error';
  }

  @override
  String get off => 'بند';
}
