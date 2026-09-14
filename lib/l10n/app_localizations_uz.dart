// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBOMLAR';

  @override
  String get api => 'API';

  @override
  String get artists => 'IJROCHILAR';

  @override
  String get artwork => 'MUQOVA';

  @override
  String get appVersion => 'Ilova versiyasi';

  @override
  String get artist => 'Ijrochi';

  @override
  String get artistsYouFollow => 'Kuzatayotgan ijrochilaringiz';

  @override
  String get autoplay => 'Avtomatik ijro';

  @override
  String get becauseYouListenedTo => 'Chunki siz tingladingiz';

  @override
  String get browseAll => 'Hammasini ko\'rish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get clearAppCache => 'Ilova keshini tozalash?';

  @override
  String get clearCache => 'Keshni tozalash';

  @override
  String get clearHistory => 'Tarixni tozalash?';

  @override
  String get clearRecentlyPlayed => 'Yaqinda ijro etilganlarni tozalash';

  @override
  String get contentMarket => 'Kontent bozori';

  @override
  String get continueListening => 'Tinglashni davom ettirish';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Videoni kichik oynada davom ettirish';

  @override
  String get create => 'Yaratish';

  @override
  String get createAPlaylistToGetStarted => 'Boshlash uchun pleylist yarating';

  @override
  String currentSelectedcountry(Object country) {
    return 'Joriy: $country';
  }

  @override
  String get deletePlaylist => 'Pleylistni o\'chirish';

  @override
  String get editProfile => 'Profilni tahrirlash';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Bozorlarni yuklashda xato: $err';
  }

  @override
  String error(Object error) {
    return 'Xato: $error';
  }

  @override
  String explore(Object genre) {
    return '${genre}ni kashf etish';
  }

  @override
  String get fansAlsoLike => 'MUXLISLAR HAM YOQTIRADI';

  @override
  String featuringTouppercase(Object artist) {
    return 'ISHTIROKIDA $artist';
  }

  @override
  String get featuredPlaylists => 'Tanlangan pleylistlar';

  @override
  String get followArtistsToSeeThemHere =>
      'Ijrochilarni kuzating, ular bu yerda ko\'rinadi';

  @override
  String get followStationsToSeeThemHere =>
      'Stansiyalarni kuzating, ular bu yerda ko\'rinadi';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Trafik tejash uchun faqat audio oqimlarini majburlash';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Joyni bo\'shatadi va keyingi yuklashda yangi ma\'lumotlarni majburlaydi';

  @override
  String get fromYourFavorites => 'Sevimlilaringizdan';

  @override
  String get goBack => 'Orqaga';

  @override
  String inspiredByName(Object name) {
    return '$name bilan ilhomlangan';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Navbat tugaganda o\'xshash qo\'shiqlarni ijro etishni davom ettirish';

  @override
  String get library => 'Kutubxona';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Albomlarni yoqtiring, ular bu yerda ko\'rinadi';

  @override
  String get likedSongs => 'Yoqtirgan qo\'shiqlar';

  @override
  String get lowDataMode => 'Kam trafik rejimi';

  @override
  String get madeForYou => 'Siz uchun tayyorlangan';

  @override
  String moreLikeName(Object name) {
    return '$name singari ko\'proq';
  }

  @override
  String get moreOptions => 'Ko\'proq imkoniyatlar';

  @override
  String get nameYourMasterpiece => 'Asaringizga nom bering...';

  @override
  String get newPlaylist => 'Yangi pleylist';

  @override
  String get newReleases => 'Yangi chiqarilganlar';

  @override
  String get next => 'Keyingisi';

  @override
  String get noAlbumsFound => 'Albomlar topilmadi';

  @override
  String get noArtistsFollowed => 'Kuzatilayotgan ijrochilar yo\'q';

  @override
  String get noArtistsFound => 'Ijrochilar topilmadi';

  @override
  String get noLikedAlbums => 'Yoqtirilgan albomlar yo\'q';

  @override
  String get noPlaylistsFound => 'Pleylistlar topilmadi';

  @override
  String get noPlaylistsYet => 'Hali pleylistlar yo\'q';

  @override
  String get noResultsFound => 'Natijalar topilmadi';

  @override
  String get noStationsFollowed => 'Kuzatilayotgan stansiyalar yo\'q';

  @override
  String get noTrackPlaying => 'Hech qanday qo\'shiq ijro etilmayapti';

  @override
  String get noTracksFound => 'Qo\'shiqlar topilmadi';

  @override
  String get playlists => 'PLEYLISTLAR';

  @override
  String get popular => 'MASHHUR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Tinglash tarixini butunlay o\'chirish';

  @override
  String get pictureinpicturePip => 'Rasm ichida rasm (PiP)';

  @override
  String get popularAlbums => 'Mashhur albomlar';

  @override
  String get popularArtists => 'Mashhur ijrochilar';

  @override
  String get popularGenres => 'Mashhur janrlar';

  @override
  String get popularSongs => 'Mashhur qo\'shiqlar';

  @override
  String get popularTracks => 'Mashhur treklarlar';

  @override
  String get popularHitsRightNow => 'Hozirgi mashhur hitlar';

  @override
  String get previous => 'Oldingisi';

  @override
  String get queue => 'NAVBAT';

  @override
  String get recentSearches => 'So\'nggi qidiruvlar';

  @override
  String get recommendedForYou => 'Siz uchun tavsiya etilgan';

  @override
  String get scraping => 'Ma\'lumot olinmoqda';

  @override
  String get search => 'Qidirish';

  @override
  String get searchInAlbum => 'Albomda qidirish...';

  @override
  String get searchInLibrary => 'Kutubxonada qidirish...';

  @override
  String get searchInPlaylist => 'Pleylistda qidirish';

  @override
  String get searchLikedSongs => 'Yoqtirgan qo\'shiqlarni qidirish...';

  @override
  String get searchPopularSongs => 'Mashhur qo\'shiqlarni qidirish...';

  @override
  String get selectMarket => 'Bozorni tanlash';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get showVideoPlayer => 'Video pleyerni ko\'rsatish';

  @override
  String get shuffle => 'Tasodifiy';

  @override
  String get spotifyCredentials => 'Spotify hisob ma\'lumotlari';

  @override
  String get suggestedStations => 'Tavsiya etilgan stansiyalar';

  @override
  String get tracks => 'TREKLAR';

  @override
  String get trending => 'Trendda';

  @override
  String get tryAgain => 'Qayta urinish';

  @override
  String get tryADifferentSearchTerm =>
      'Boshqa qidiruv so\'zini sinab ko\'ring';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Mavjud bo\'lsa YouTube pleyerini ishlatish';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Nima tinglashni xohlaysiz?';

  @override
  String get youtubeCredentials => 'YouTube hisob ma\'lumotlari';

  @override
  String get yourLibrary => 'Sizning kutubxonangiz';

  @override
  String get playerscreenviewswitch => 'pleyer_ekrani_ko_rinish_almashtirish';

  @override
  String get addToPlaylist => 'Pleylistga qo\'shish';

  @override
  String get addToQueue => 'Navbatga qo\'shish';

  @override
  String get copyId => 'ID nusxalash';

  @override
  String get copyLink => 'Havolani nusxalash';

  @override
  String get discover => 'Kashf etish';

  @override
  String get enterYourName => 'Ismingizni kiriting';

  @override
  String get favorites => 'Sevimlilar';

  @override
  String get goToAlbum => 'Albomga o\'tish';

  @override
  String get goToArtist => 'Ijrochiga o\'tish';

  @override
  String get goToArtistRadio => 'Ijrochi radioga o\'tish';

  @override
  String get goToPlaylist => 'Pleylistga o\'tish';

  @override
  String get goToSongRadio => 'Qo\'shiq radioga o\'tish';

  @override
  String get home => 'Asosiy';

  @override
  String get myAwesomePlaylist => 'Mening ajoyib pleylistim';

  @override
  String get myPlaylist => 'Mening pleylistim';

  @override
  String get newPlaylist1 => 'Yangi pleylist';

  @override
  String get play => 'Ijro etish';

  @override
  String get playStation => 'Stansiyani ijro etish';

  @override
  String get playNext => 'Keyingisini ijro etish';

  @override
  String get playlist => 'Pleylist';

  @override
  String get playlistName => 'Pleylist nomi';

  @override
  String get playlists1 => 'Pleylistlar';

  @override
  String get queue1 => 'Navbat';

  @override
  String get recentlyPlayed => 'Yaqinda ijro etilgan';

  @override
  String get removeFromQueue => 'Navbatdan olib tashlash';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get searchMusicArtistsAlbums => 'Musiqa, ijrochilar, albomlar...';

  @override
  String get share => 'Ulashish';

  @override
  String featuringArtist(String artistName) {
    return 'ISHTIROKIDA $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Joriy: $country';
  }

  @override
  String get queueTooltip => 'Navbat';

  @override
  String get searchHint => 'Musiqa, ijrochilar, albomlar...';

  @override
  String get language => 'Til';

  @override
  String get systemDefault => 'Tizim standarti';

  @override
  String get songsTab => 'Qo\'shiqlar';

  @override
  String get foldersTab => 'Jildlar';

  @override
  String get artistsTab => 'Ijrochilar';

  @override
  String get albumsTab => 'Albomlar';

  @override
  String get addMusic => 'Musiqa qo\'shish';

  @override
  String get addFiles => 'Fayllar qo\'shish';

  @override
  String get addFolder => 'Jild qo\'shish';

  @override
  String get rescanLibrary => 'Kutubxonani qayta skanerlash';

  @override
  String get sortTitle => 'Nomi bo\'yicha saralash';

  @override
  String get sortArtist => 'Ijrochi bo\'yicha saralash';

  @override
  String get sortAlbum => 'Albom bo\'yicha saralash';

  @override
  String get sortDuration => 'Davomiyligi bo\'yicha saralash';

  @override
  String get sortDateAdded => 'Qo\'shilgan sana bo\'yicha saralash';

  @override
  String get trackInformation => 'Trek haqida ma\'lumot';

  @override
  String get removeFromLibrary => 'Kutubxonadan olib tashlash';

  @override
  String get showInFolder => 'Jildda ko\'rsatish';

  @override
  String get unknownArtist => 'Noma\'lum ijrochi';

  @override
  String get unknownAlbum => 'Noma\'lum albom';

  @override
  String get importedFiles => 'Import qilingan fayllar';

  @override
  String get playFolder => 'Jildni o\'ynatish';

  @override
  String get shuffleFolder => 'Jildni aralashtirib o\'ynatish';

  @override
  String get playAll => 'Barchasini o\'ynatish';

  @override
  String get includeSubfolders => 'Ostki jildlarni qo\'shish';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trek',
      one: '1 trek',
      zero: '0 trek',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Hech qanday mahalliy qo\'shiq topilmadi';

  @override
  String get searchLocalMusic => 'Mahalliy musiqani qidirish...';

  @override
  String get viewAsList => 'Ro\'yxat sifatida ko\'rish';

  @override
  String get viewAsGrid => 'To\'r sifatida ko\'rish';

  @override
  String get trackInfoPath => 'Yo\'l';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Davomiyligi';

  @override
  String get aboutDescription => 'Bepul va ochiq kodli musiqa pleyeri.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Versiya $version (Qurilma $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho tomonidan yaratilgan';

  @override
  String get website => 'Veb-sayt';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Chiqarish qaydlari';

  @override
  String get support => 'Qo\'llab-quvvatlash';

  @override
  String get license => 'Litsenziya';

  @override
  String get acknowledgments => 'Minnatdorchilik';

  @override
  String get close => 'Yopish';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer hissa qo\'shuvchilari';
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
  String get filterAll => 'Barchasi';

  @override
  String get filterPlaylists => 'Pley-listlar';

  @override
  String get filterArtists => 'Ijrochilar';

  @override
  String get filterAlbums => 'Albomlar';

  @override
  String get filterStations => 'Stansiyalar';

  @override
  String get localMusicCard => 'Mahalliy musiqa';

  @override
  String get createPlaylistButton => 'Pley-list yaratish';

  @override
  String get radioStations => 'Radio stansiyalar';

  @override
  String get discoverMusic => 'Musiqa kashf etish';

  @override
  String get importLocalMusic => 'Mahalliy musiqani import qilish';

  @override
  String get importAudioFiles => 'Audio fayllarni import qilish';

  @override
  String get importFolder => 'Jildni import qilish';
}
