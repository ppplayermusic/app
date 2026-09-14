// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title، $subtitle';
  }

  @override
  String get albums => 'ألبومات';

  @override
  String get api => 'API';

  @override
  String get artists => 'فنانين';

  @override
  String get artwork => 'صورة الغلاف';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get artist => 'فنان';

  @override
  String get artistsYouFollow => 'فنانون تتابعهم';

  @override
  String get autoplay => 'تشغيل تلقائي';

  @override
  String get becauseYouListenedTo => 'لأنك استمعت إلى';

  @override
  String get browseAll => 'تصفح الكل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get clearAppCache => 'هل تريد مسح ذاكرة التخزين المؤقت للتطبيق؟';

  @override
  String get clearCache => 'مسح ذاكرة التخزين المؤقت';

  @override
  String get clearHistory => 'هل تريد مسح السجل؟';

  @override
  String get clearRecentlyPlayed => 'مسح المشغلة مؤخرًا';

  @override
  String get contentMarket => 'سوق المحتوى';

  @override
  String get continueListening => 'متابعة الاستماع';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'متابعة تشغيل الفيديو في نافذة صغيرة';

  @override
  String get create => 'إنشاء';

  @override
  String get createAPlaylistToGetStarted => 'أنشئ قائمة تشغيل للبدء';

  @override
  String currentSelectedcountry(Object country) {
    return 'الحالي: $country';
  }

  @override
  String get deletePlaylist => 'حذف قائمة التشغيل';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String errorLoadingMarkets(Object err) {
    return 'خطأ في تحميل الأسواق: $err';
  }

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String explore(Object genre) {
    return 'استكشف $genre';
  }

  @override
  String get fansAlsoLike => 'المعجبون يحبون أيضًا';

  @override
  String featuringTouppercase(Object artist) {
    return 'بمشاركة $artist';
  }

  @override
  String get featuredPlaylists => 'قوائم التشغيل المميزة';

  @override
  String get followArtistsToSeeThemHere => 'تابع الفنانين لرؤيتهم هنا';

  @override
  String get followStationsToSeeThemHere => 'تابع المحطات لرؤيتها هنا';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'فرض تشغيل الصوت فقط لتوفير البيانات';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'يوفر المساحة ويفرض تنزيل بيانات جديدة عند التحميل التالي';

  @override
  String get fromYourFavorites => 'من مفضلاتك';

  @override
  String get goBack => 'رجوع';

  @override
  String inspiredByName(Object name) {
    return 'مستوحى من $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'الاستمرار في تشغيل مقاطع مشابهة عند انتهاء قائمة الانتظار';

  @override
  String get library => 'المكتبة';

  @override
  String get likeAlbumsToSeeThemHere => 'أعجب بالألبومات لرؤيتها هنا';

  @override
  String get likedSongs => 'الأغاني التي أعجبتك';

  @override
  String get lowDataMode => 'وضع توفير البيانات';

  @override
  String get madeForYou => 'مخصص لك';

  @override
  String moreLikeName(Object name) {
    return 'المزيد مثل $name';
  }

  @override
  String get moreOptions => 'خيارات إضافية';

  @override
  String get nameYourMasterpiece => 'أعطِ اسمًا لتحفتك...';

  @override
  String get newPlaylist => 'قائمة تشغيل جديدة';

  @override
  String get newReleases => 'إصدارات جديدة';

  @override
  String get next => 'التالي';

  @override
  String get noAlbumsFound => 'لم يتم العثور على ألبومات';

  @override
  String get noArtistsFollowed => 'لم تتم متابعة أي فنان';

  @override
  String get noArtistsFound => 'لم يتم العثور على فنانين';

  @override
  String get noLikedAlbums => 'لا توجد ألبومات معجب بها';

  @override
  String get noPlaylistsFound => 'لم يتم العثور على قوائم تشغيل';

  @override
  String get noPlaylistsYet => 'لا توجد قوائم تشغيل بعد';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noStationsFollowed => 'لم تتم متابعة أي محطة';

  @override
  String get noTrackPlaying => 'لا يوجد مقطع قيد التشغيل';

  @override
  String get noTracksFound => 'لم يتم العثور على مقاطع';

  @override
  String get playlists => 'قوائم التشغيل';

  @override
  String get popular => 'شائع';

  @override
  String get permanentlyRemoveListeningHistory => 'حذف سجل الاستماع نهائيًا';

  @override
  String get pictureinpicturePip => 'صورة داخل صورة (PiP)';

  @override
  String get popularAlbums => 'ألبومات شائعة';

  @override
  String get popularArtists => 'فنانون شائعون';

  @override
  String get popularGenres => 'أنواع الموسيقى الشائعة';

  @override
  String get popularSongs => 'أغاني شائعة';

  @override
  String get popularTracks => 'مقاطع شائعة';

  @override
  String get popularHitsRightNow => 'أغاني ضاربة الآن';

  @override
  String get previous => 'السابق';

  @override
  String get queue => 'قائمة الانتظار';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get recommendedForYou => 'موصى به لك';

  @override
  String get scraping => 'جاري الاستخراج';

  @override
  String get search => 'بحث';

  @override
  String get searchInAlbum => 'ابحث في الألبوم...';

  @override
  String get searchInLibrary => 'ابحث في المكتبة...';

  @override
  String get searchInPlaylist => 'ابحث في قائمة التشغيل';

  @override
  String get searchLikedSongs => 'ابحث في الأغاني التي أعجبتك...';

  @override
  String get searchPopularSongs => 'ابحث عن الأغاني الشائعة...';

  @override
  String get selectMarket => 'اختر السوق';

  @override
  String get settings => 'الإعدادات';

  @override
  String get showVideoPlayer => 'إظهار مشغل الفيديو';

  @override
  String get shuffle => 'تشغيل عشوائي';

  @override
  String get spotifyCredentials => 'بيانات اعتماد Spotify';

  @override
  String get suggestedStations => 'محطات مقترحة';

  @override
  String get tracks => 'مقاطع';

  @override
  String get trending => 'رائج';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get tryADifferentSearchTerm => 'جرب مصطلح بحث مختلف';

  @override
  String get useYoutubePlayerWhenAvailable => 'استخدم مشغل YouTube عند توفره';

  @override
  String get video => 'فيديو';

  @override
  String get whatDoYouWantToListenTo => 'ماذا تريد أن تستمع إليه؟';

  @override
  String get youtubeCredentials => 'بيانات اعتماد YouTube';

  @override
  String get yourLibrary => 'مكتبتك';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'أضف إلى قائمة التشغيل';

  @override
  String get addToQueue => 'أضف إلى قائمة الانتظار';

  @override
  String get copyId => 'نسخ المعرف';

  @override
  String get copyLink => 'نسخ الرابط';

  @override
  String get discover => 'اكتشف';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get favorites => 'المفضلة';

  @override
  String get goToAlbum => 'انتقل إلى الألبوم';

  @override
  String get goToArtist => 'انتقل إلى الفنان';

  @override
  String get goToArtistRadio => 'انتقل إلى راديو الفنان';

  @override
  String get goToPlaylist => 'انتقل إلى قائمة التشغيل';

  @override
  String get goToSongRadio => 'انتقل إلى راديو الأغنية';

  @override
  String get home => 'الرئيسية';

  @override
  String get myAwesomePlaylist => 'قائمة تشغيل رائعة الخاصة بي';

  @override
  String get myPlaylist => 'قائمتي';

  @override
  String get newPlaylist1 => 'قائمة تشغيل جديدة';

  @override
  String get play => 'تشغيل';

  @override
  String get playStation => 'تشغيل المحطة';

  @override
  String get playNext => 'تشغيل التالي';

  @override
  String get playlist => 'قائمة تشغيل';

  @override
  String get playlistName => 'اسم قائمة التشغيل';

  @override
  String get playlists1 => 'قوائم التشغيل';

  @override
  String get queue1 => 'قائمة الانتظار';

  @override
  String get recentlyPlayed => 'تم تشغيلها مؤخرًا';

  @override
  String get removeFromQueue => 'إزالة من قائمة الانتظار';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get searchMusicArtistsAlbums =>
      'البحث عن الموسيقى، الفنانين، الألبومات...';

  @override
  String get share => 'مشاركة';

  @override
  String featuringArtist(String artistName) {
    return 'بمشاركة $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'الحالي: $country';
  }

  @override
  String get queueTooltip => 'قائمة الانتظار';

  @override
  String get searchHint => 'البحث عن الموسيقى والفنانين والألبومات...';

  @override
  String get language => 'اللغة';

  @override
  String get systemDefault => 'الافتراضي للنظام';

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
  String get aboutDescription => 'مشغل موسيقى مجاني ومفتوح المصدر.';

  @override
  String versionInfo(Object version, Object build) {
    return 'الإصدار $version (النسخة $build)';
  }

  @override
  String get createdBy => 'تم الإنشاء بواسطة Lucas Coelho';

  @override
  String get website => 'الموقع الإلكتروني';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'ملاحظات الإصدار';

  @override
  String get support => 'الدعم';

  @override
  String get license => 'الترخيص';

  @override
  String get acknowledgments => 'شكر وتقدير';

  @override
  String get close => 'إغلاق';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
  }
}
