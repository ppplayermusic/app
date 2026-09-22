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
  String get playerscreenviewswitch => 'تغییر_نمای_صفحه_پخش‌کننده';

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
  String get playlist => 'پلی‌لیست';

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
  String get songsTab => 'آهنگ‌ها';

  @override
  String get foldersTab => 'پوشه‌ها';

  @override
  String get artistsTab => 'هنرمندان';

  @override
  String get albumsTab => 'آلبوم‌ها';

  @override
  String get genresTab => 'ژانرها';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'سرعت پخش';

  @override
  String get addMusic => 'افزودن موسیقی';

  @override
  String get addFiles => 'افزودن فایل‌ها';

  @override
  String get addFolder => 'افزودن پوشه';

  @override
  String get rescanLibrary => 'اسکن مجدد کتابخانه';

  @override
  String get sortTitle => 'مرتب‌سازی بر اساس عنوان';

  @override
  String get sortArtist => 'مرتب‌سازی بر اساس هنرمند';

  @override
  String get sortAlbum => 'مرتب‌سازی بر اساس آلبوم';

  @override
  String get sortDuration => 'مرتب‌سازی بر اساس مدت زمان';

  @override
  String get sortDateAdded => 'مرتب‌سازی بر اساس تاریخ افزودن';

  @override
  String get sortBy => 'مرتب‌سازی بر اساس';

  @override
  String get trackInformation => 'اطلاعات آهنگ';

  @override
  String get removeFromLibrary => 'حذف از کتابخانه';

  @override
  String get showInFolder => 'نمایش در پوشه';

  @override
  String get unknownArtist => 'هنرمند ناشناس';

  @override
  String get unknownAlbum => 'آلبوم ناشناس';

  @override
  String get importedFiles => 'فایل‌های وارد شده';

  @override
  String get playFolder => 'پخش پوشه';

  @override
  String get shuffleFolder => 'پخش تصادفی پوشه';

  @override
  String get playAll => 'پخش همه';

  @override
  String get includeSubfolders => 'شامل زیرپوشه‌ها';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '1 قطعه',
      zero: '0 قطعه',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'هیچ آهنگ محلی یافت نشد';

  @override
  String get searchLocalMusic => 'جستجوی موسیقی محلی...';

  @override
  String get viewAsList => 'نمایش به صورت لیست';

  @override
  String get viewAsGrid => 'نمایش به صورت شبکه';

  @override
  String get trackInfoPath => 'مسیر';

  @override
  String get trackInfoFormat => 'فرمت';

  @override
  String get trackInfoDuration => 'مدت زمان';

  @override
  String get aboutDescription => 'یک پخش کننده رسانه منبع باز و رایگان.';

  @override
  String get aboutApp => 'درباره PPPlayer';

  @override
  String get appTagline => 'موسیقی شما. به روش شما.';

  @override
  String get exploreApp => 'گشت و گذار در PPPlayer';

  @override
  String get viewSource => 'مشاهده منبع';

  @override
  String get seeWhatsNew => 'موارد جدید';

  @override
  String get getHelp => 'دریافت کمک';

  @override
  String versionInfo(Object version, Object build) {
    return 'نسخه $version (ساخت $build)';
  }

  @override
  String get createdBy => 'ایجاد شده توسط Lucas Coelho';

  @override
  String get website => 'وب‌سایت';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'یادداشت‌های انتشار';

  @override
  String get support => 'پشتیبانی';

  @override
  String get license => 'مجوز';

  @override
  String get acknowledgments => 'تقدیرنامه‌ها';

  @override
  String get close => 'بستن';

  @override
  String copyright(Object year) {
    return '© $year مشارکت‌کنندگان PPPlayer';
  }

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'ظهر بخیر';

  @override
  String get goodEvening => 'عصر بخیر';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'موسیقی شما منتظر است.';

  @override
  String dailyMix(Object number) {
    return 'میکس روزانه $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'علاقه‌مندی‌های شما\nو کشفیات جدید';

  @override
  String get discoverWeekly => 'کشف هفتگی';

  @override
  String get releaseRadar => 'رادار انتشار';

  @override
  String get newMusicJustForYou => 'موسیقی جدید\nفقط برای شما';

  @override
  String get chillMix => 'میکس آرامش';

  @override
  String get relaxAndUnwind => 'آرامش و استراحت';

  @override
  String get focusMix => 'میکس تمرکز';

  @override
  String get deepFocusAndProductivity => 'تمرکز عمیق\nو بهره‌وری';

  @override
  String artistRadio(Object artist) {
    return 'رادیو $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'رادیو $genre';
  }

  @override
  String get filterAll => 'همه';

  @override
  String get filterPlaylists => 'پلی‌لیست‌ها';

  @override
  String get filterArtists => 'هنرمندان';

  @override
  String get filterAlbums => 'آلبوم‌ها';

  @override
  String get filterStations => 'ایستگاه‌ها';

  @override
  String get filterStreams => 'جریان‌ها';

  @override
  String get localMusicCard => 'موسیقی محلی';

  @override
  String get createPlaylistButton => 'ایجاد پلی‌لیست';

  @override
  String get radioStations => 'ایستگاه‌های رادیویی';

  @override
  String get discoverMusic => 'کشف موسیقی';

  @override
  String get importLocalMusic => 'وارد کردن موسیقی محلی';

  @override
  String get importAudioFiles => 'وارد کردن فایل‌های صوتی';

  @override
  String get importFolder => 'وارد کردن پوشه';

  @override
  String get importFolderSubtitle => 'پوشه‌ای حاوی فایل‌های صوتی انتخاب کنید';

  @override
  String get importPlaylist => 'وارد کردن لیست پخش';

  @override
  String get importPlaylistSubtitle => 'وارد کردن فایل .m3u یا .m3u8';

  @override
  String get exportPlaylist => 'خروجی گرفتن لیست پخش';

  @override
  String get playbackErrorUnsupportedFormat =>
      'فرمت پشتیبانی نشده یا فایل خراب است';

  @override
  String get playbackErrorFileInaccessible =>
      'فایل غیرقابل دسترسی است یا پیدا نشد';

  @override
  String get localVideosCard => 'ویدیوهای محلی';

  @override
  String get noLocalVideos => 'هیچ ویدیویی یافت نشد';

  @override
  String get searchLocalVideos => 'جستجوی ویدیوهای محلی';

  @override
  String get addVideos => 'افزودن ویدیوها';

  @override
  String get subtitles => 'زیرنویس‌ها';

  @override
  String get audioTracks => 'ترک‌های صوتی';

  @override
  String get loadSubtitleFile => 'بارگیری فایل زیرنویس...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'خطا در بارگیری زیرنویس: $error';
  }

  @override
  String get off => 'خاموش';
}
