// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title، $subtitle';
  }

  @override
  String get albums => 'آلبوم‌ها';

  @override
  String get api => 'API';

  @override
  String get artists => 'هنرمندان';

  @override
  String get artwork => 'کاور';

  @override
  String get appVersion => 'نسخه برنامه';

  @override
  String get artist => 'هنرمند';

  @override
  String get artistsYouFollow => 'هنرمندانی که دنبال می‌کنید';

  @override
  String get autoplay => 'پخش خودکار';

  @override
  String get becauseYouListenedTo => 'چون گوش دادید به';

  @override
  String get browseAll => 'مرور همه';

  @override
  String get cancel => 'لغو';

  @override
  String get clearAppCache => 'پاک کردن حافظه پنهان برنامه؟';

  @override
  String get clearCache => 'پاک کردن حافظه پنهان';

  @override
  String get clearHistory => 'پاک کردن تاریخچه؟';

  @override
  String get clearRecentlyPlayed => 'پاک کردن پخش‌های اخیر';

  @override
  String get contentMarket => 'بازار محتوا';

  @override
  String get continueListening => 'ادامه گوش دادن';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'ادامه پخش ویدیو در پنجره کوچک';

  @override
  String get create => 'ایجاد';

  @override
  String get createAPlaylistToGetStarted => 'برای شروع یک لیست پخش ایجاد کنید';

  @override
  String currentSelectedcountry(Object country) {
    return 'فعلی: $country';
  }

  @override
  String get deletePlaylist => 'حذف لیست پخش';

  @override
  String get editProfile => 'ویرایش پروفایل';

  @override
  String errorLoadingMarkets(Object err) {
    return 'خطا در بارگیری بازارها: $err';
  }

  @override
  String error(Object error) {
    return 'خطا: $error';
  }

  @override
  String explore(Object genre) {
    return 'کاوش $genre';
  }

  @override
  String get fansAlsoLike => 'طرفداران همچنین دوست دارند';

  @override
  String featuringTouppercase(Object artist) {
    return 'با حضور $artist';
  }

  @override
  String get featuredPlaylists => 'لیست‌های پخش ویژه';

  @override
  String get followArtistsToSeeThemHere =>
      'هنرمندان را دنبال کنید تا اینجا ببینید';

  @override
  String get followStationsToSeeThemHere =>
      'ایستگاه‌ها را دنبال کنید تا اینجا ببینید';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'اجبار به پخش فقط صوتی برای ذخیره داده';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'فضا را آزاد می‌کند و داده‌های جدید دریافت می‌کند';

  @override
  String get fromYourFavorites => 'از موارد دلخواه شما';

  @override
  String get goBack => 'بازگشت';

  @override
  String inspiredByName(Object name) {
    return 'الهام گرفته از $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'ادامه پخش آهنگ‌های مشابه پس از پایان صف';

  @override
  String get library => 'کتابخانه';

  @override
  String get likeAlbumsToSeeThemHere => 'آلبوم‌ها را لایک کنید تا اینجا ببینید';

  @override
  String get likedSongs => 'آهنگ‌های پسندیده شده';

  @override
  String get lowDataMode => 'حالت داده کم';

  @override
  String get madeForYou => 'ساخته شده برای شما';

  @override
  String moreLikeName(Object name) {
    return 'بیشتر شبیه $name';
  }

  @override
  String get moreOptions => 'گزینه‌های بیشتر';

  @override
  String get nameYourMasterpiece => 'شاهکار خود را نام‌گذاری کنید...';

  @override
  String get newPlaylist => 'لیست پخش جدید';

  @override
  String get newReleases => 'انتشارهای جدید';

  @override
  String get next => 'بعدی';

  @override
  String get noAlbumsFound => 'هیچ آلبومی یافت نشد';

  @override
  String get noArtistsFollowed => 'هیچ هنرمندی دنبال نمی‌شود';

  @override
  String get noArtistsFound => 'هیچ هنرمندی یافت نشد';

  @override
  String get noLikedAlbums => 'هیچ آلبومی لایک نشده';

  @override
  String get noPlaylistsFound => 'هیچ لیست پخشی یافت نشد';

  @override
  String get noPlaylistsYet => 'هنوز لیست پخشی وجود ندارد';

  @override
  String get noResultsFound => 'هیچ نتیجه‌ای یافت نشد';

  @override
  String get noStationsFollowed => 'هیچ ایستگاهی دنبال نمی‌شود';

  @override
  String get noTrackPlaying => 'هیچ آهنگی در حال پخش نیست';

  @override
  String get noTracksFound => 'هیچ آهنگی یافت نشد';

  @override
  String get playlists => 'لیست‌های پخش';

  @override
  String get popular => 'محبوب';

  @override
  String get permanentlyRemoveListeningHistory => 'حذف دائمی تاریخچه گوش دادن';

  @override
  String get pictureinpicturePip => 'تصویر در تصویر (PiP)';

  @override
  String get popularAlbums => 'آلبوم‌های محبوب';

  @override
  String get popularArtists => 'هنرمندان محبوب';

  @override
  String get popularGenres => 'ژانرهای محبوب';

  @override
  String get popularSongs => 'آهنگ‌های محبوب';

  @override
  String get popularTracks => 'آهنگ‌های محبوب';

  @override
  String get popularHitsRightNow => 'هیت‌های محبوب در حال حاضر';

  @override
  String get previous => 'قبلی';

  @override
  String get queue => 'صف';

  @override
  String get recentSearches => 'جستجوهای اخیر';

  @override
  String get recommendedForYou => 'توصیه شده برای شما';

  @override
  String get scraping => 'استخراج داده‌ها';

  @override
  String get search => 'جستجو';

  @override
  String get searchInAlbum => 'جستجو در آلبوم...';

  @override
  String get searchInLibrary => 'جستجو در کتابخانه...';

  @override
  String get searchInPlaylist => 'جستجو در لیست پخش';

  @override
  String get searchLikedSongs => 'جستجوی آهنگ‌های پسندیده شده...';

  @override
  String get searchPopularSongs => 'جستجوی آهنگ‌های محبوب...';

  @override
  String get selectMarket => 'انتخاب بازار';

  @override
  String get settings => 'تنظیمات';

  @override
  String get showVideoPlayer => 'نمایش پخش‌کننده ویدیو';

  @override
  String get shuffle => 'پخش تصادفی';

  @override
  String get spotifyCredentials => 'اعتبارنامه‌های Spotify';

  @override
  String get suggestedStations => 'ایستگاه‌های پیشنهادی';

  @override
  String get tracks => 'آهنگ‌ها';

  @override
  String get trending => 'در حال ترند';

  @override
  String get tryAgain => 'تلاش مجدد';

  @override
  String get tryADifferentSearchTerm => 'یک عبارت جستجوی متفاوت را امتحان کنید';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'استفاده از پخش‌کننده یوتیوب در صورت امکان';

  @override
  String get video => 'ویدیو';

  @override
  String get whatDoYouWantToListenTo => 'به چه چیزی می‌خواهید گوش دهید؟';

  @override
  String get youtubeCredentials => 'اعتبارنامه‌های YouTube';

  @override
  String get yourLibrary => 'کتابخانه شما';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'افزودن به لیست پخش';

  @override
  String get addToQueue => 'افزودن به صف';

  @override
  String get copyId => 'کپی شناسه';

  @override
  String get copyLink => 'کپی لینک';

  @override
  String get discover => 'کشف';

  @override
  String get enterYourName => 'نام خود را وارد کنید';

  @override
  String get favorites => 'موارد دلخواه';

  @override
  String get goToAlbum => 'رفتن به آلبوم';

  @override
  String get goToArtist => 'رفتن به هنرمند';

  @override
  String get goToArtistRadio => 'رفتن به رادیو هنرمند';

  @override
  String get goToPlaylist => 'رفتن به لیست پخش';

  @override
  String get goToSongRadio => 'رفتن به رادیو آهنگ';

  @override
  String get home => 'خانه';

  @override
  String get myAwesomePlaylist => 'لیست پخش عالی من';

  @override
  String get myPlaylist => 'لیست پخش من';

  @override
  String get newPlaylist1 => 'لیست پخش جدید';

  @override
  String get play => 'پخش';

  @override
  String get playStation => 'پخش ایستگاه';

  @override
  String get playNext => 'پخش بعدی';

  @override
  String get playlist => 'لیست پخش';

  @override
  String get playlistName => 'نام لیست پخش';

  @override
  String get playlists1 => 'لیست‌های پخش';

  @override
  String get queue1 => 'صف';

  @override
  String get recentlyPlayed => 'اخیراً پخش شده';

  @override
  String get removeFromQueue => 'حذف از صف';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get searchMusicArtistsAlbums => 'جستجوی موسیقی، هنرمندان، آلبوم‌ها...';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String featuringArtist(String artistName) {
    return 'با حضور $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'فعلی: $country';
  }

  @override
  String get queueTooltip => 'صف';

  @override
  String get searchHint => 'جستجوی موسیقی، هنرمندان، آلبوم‌ها...';

  @override
  String get language => 'زبان';

  @override
  String get systemDefault => 'پیش‌فرض سیستم';

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
}
