// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'อัลบั้ม';

  @override
  String get api => 'API';

  @override
  String get artists => 'ศิลปิน';

  @override
  String get artwork => 'หน้าปก';

  @override
  String get appVersion => 'เวอร์ชันแอป';

  @override
  String get artist => 'ศิลปิน';

  @override
  String get artistsYouFollow => 'ศิลปินที่คุณติดตาม';

  @override
  String get autoplay => 'เล่นอัตโนมัติ';

  @override
  String get becauseYouListenedTo => 'เพราะคุณฟัง';

  @override
  String get browseAll => 'เรียกดูทั้งหมด';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get clearAppCache => 'ล้างแคชของแอปหรือไม่';

  @override
  String get clearCache => 'ล้างแคช';

  @override
  String get clearHistory => 'ล้างประวัติหรือไม่';

  @override
  String get clearRecentlyPlayed => 'ล้างที่เพิ่งเล่น';

  @override
  String get contentMarket => 'ตลาดเนื้อหา';

  @override
  String get continueListening => 'ฟังต่อ';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'เล่นวิดีโอต่อในหน้าต่างขนาดเล็ก';

  @override
  String get create => 'สร้าง';

  @override
  String get createAPlaylistToGetStarted => 'สร้างเพลย์ลิสต์เพื่อเริ่มต้น';

  @override
  String currentSelectedcountry(Object country) {
    return 'ปัจจุบัน: $country';
  }

  @override
  String get deletePlaylist => 'ลบเพลย์ลิสต์';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String errorLoadingMarkets(Object err) {
    return 'เกิดข้อผิดพลาดในการโหลดตลาด: $err';
  }

  @override
  String error(Object error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String explore(Object genre) {
    return 'สำรวจ $genre';
  }

  @override
  String get fansAlsoLike => 'แฟนๆ ยังชื่นชอบ';

  @override
  String featuringTouppercase(Object artist) {
    return 'ร่วมกับ $artist';
  }

  @override
  String get featuredPlaylists => 'เพลย์ลิสต์แนะนำ';

  @override
  String get followArtistsToSeeThemHere => 'ติดตามศิลปินเพื่อดูที่นี่';

  @override
  String get followStationsToSeeThemHere => 'ติดตามสถานีเพื่อดูที่นี่';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'บังคับสตรีมเฉพาะเสียงเพื่อประหยัดข้อมูล';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'เพิ่มพื้นที่ว่างและบังคับให้โหลดข้อมูลใหม่ในครั้งต่อไป';

  @override
  String get fromYourFavorites => 'จากรายการโปรดของคุณ';

  @override
  String get goBack => 'ย้อนกลับ';

  @override
  String inspiredByName(Object name) {
    return 'แรงบันดาลใจจาก $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'เล่นเพลงที่คล้ายกันต่อเมื่อคิวจบลง';

  @override
  String get library => 'คลัง';

  @override
  String get likeAlbumsToSeeThemHere => 'กดถูกใจอัลบั้มเพื่อดูที่นี่';

  @override
  String get likedSongs => 'เพลงที่ถูกใจ';

  @override
  String get lowDataMode => 'โหมดประหยัดข้อมูล';

  @override
  String get madeForYou => 'จัดทำเพื่อคุณ';

  @override
  String moreLikeName(Object name) {
    return 'เพิ่มเติมที่เหมือน $name';
  }

  @override
  String get moreOptions => 'ตัวเลือกเพิ่มเติม';

  @override
  String get nameYourMasterpiece => 'ตั้งชื่อผลงานชิ้นเอกของคุณ...';

  @override
  String get newPlaylist => 'เพลย์ลิสต์ใหม่';

  @override
  String get newReleases => 'ออกใหม่';

  @override
  String get next => 'ถัดไป';

  @override
  String get noAlbumsFound => 'ไม่พบอัลบั้ม';

  @override
  String get noArtistsFollowed => 'ยังไม่ได้ติดตามศิลปิน';

  @override
  String get noArtistsFound => 'ไม่พบศิลปิน';

  @override
  String get noLikedAlbums => 'ไม่มีอัลบั้มที่ถูกใจ';

  @override
  String get noPlaylistsFound => 'ไม่พบเพลย์ลิสต์';

  @override
  String get noPlaylistsYet => 'ยังไม่มีเพลย์ลิสต์';

  @override
  String get noResultsFound => 'ไม่พบผลลัพธ์';

  @override
  String get noStationsFollowed => 'ยังไม่ได้ติดตามสถานี';

  @override
  String get noTrackPlaying => 'ไม่มีเพลงเล่นอยู่';

  @override
  String get noTracksFound => 'ไม่พบเพลง';

  @override
  String get playlists => 'เพลย์ลิสต์';

  @override
  String get popular => 'ยอดนิยม';

  @override
  String get permanentlyRemoveListeningHistory => 'ลบประวัติการฟังอย่างถาวร';

  @override
  String get pictureinpicturePip => 'การแสดงภาพซ้อนภาพ (PiP)';

  @override
  String get popularAlbums => 'อัลบั้มยอดนิยม';

  @override
  String get popularArtists => 'ศิลปินยอดนิยม';

  @override
  String get popularGenres => 'ประเภทเพลงยอดนิยม';

  @override
  String get popularSongs => 'เพลงยอดนิยม';

  @override
  String get popularTracks => 'แทร็กยอดนิยม';

  @override
  String get popularHitsRightNow => 'เพลงฮิตยอดนิยมตอนนี้';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get queue => 'คิว';

  @override
  String get recentSearches => 'การค้นหาล่าสุด';

  @override
  String get recommendedForYou => 'แนะนำสำหรับคุณ';

  @override
  String get scraping => 'กำลังคัดลอกข้อมูล';

  @override
  String get search => 'ค้นหา';

  @override
  String get searchInAlbum => 'ค้นหาในอัลบั้ม...';

  @override
  String get searchInLibrary => 'ค้นหาในคลัง...';

  @override
  String get searchInPlaylist => 'ค้นหาในเพลย์ลิสต์';

  @override
  String get searchLikedSongs => 'ค้นหาเพลงที่ถูกใจ...';

  @override
  String get searchPopularSongs => 'ค้นหาเพลงยอดนิยม...';

  @override
  String get selectMarket => 'เลือกตลาด';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get showVideoPlayer => 'แสดงโปรแกรมเล่นวิดีโอ';

  @override
  String get shuffle => 'สุ่ม';

  @override
  String get spotifyCredentials => 'ข้อมูลรับรอง Spotify';

  @override
  String get suggestedStations => 'สถานีที่แนะนำ';

  @override
  String get tracks => 'เพลง';

  @override
  String get trending => 'กำลังมาแรง';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get tryADifferentSearchTerm => 'ลองใช้คำค้นหาอื่น';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'ใช้โปรแกรมเล่น YouTube เมื่อพร้อมใช้งาน';

  @override
  String get video => 'วิดีโอ';

  @override
  String get whatDoYouWantToListenTo => 'คุณต้องการฟังอะไร';

  @override
  String get youtubeCredentials => 'ข้อมูลรับรอง YouTube';

  @override
  String get yourLibrary => 'คลังของคุณ';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'เพิ่มลงในเพลย์ลิสต์';

  @override
  String get addToQueue => 'เพิ่มลงในคิว';

  @override
  String get copyId => 'คัดลอก ID';

  @override
  String get copyLink => 'คัดลอกลิงก์';

  @override
  String get discover => 'ค้นพบ';

  @override
  String get enterYourName => 'ป้อนชื่อของคุณ';

  @override
  String get favorites => 'รายการโปรด';

  @override
  String get goToAlbum => 'ไปที่อัลบั้ม';

  @override
  String get goToArtist => 'ไปที่ศิลปิน';

  @override
  String get goToArtistRadio => 'ไปที่วิทยุของศิลปิน';

  @override
  String get goToPlaylist => 'ไปที่เพลย์ลิสต์';

  @override
  String get goToSongRadio => 'ไปที่วิทยุของเพลง';

  @override
  String get home => 'หน้าแรก';

  @override
  String get myAwesomePlaylist => 'เพลย์ลิสต์สุดเจ๋งของฉัน';

  @override
  String get myPlaylist => 'เพลย์ลิสต์ของฉัน';

  @override
  String get newPlaylist1 => 'เพลย์ลิสต์ใหม่';

  @override
  String get play => 'เล่น';

  @override
  String get playStation => 'เล่นสถานี';

  @override
  String get playNext => 'เล่นถัดไป';

  @override
  String get playlist => 'เพลย์ลิสต์';

  @override
  String get playlistName => 'ชื่อเพลย์ลิสต์';

  @override
  String get playlists1 => 'เพลย์ลิสต์';

  @override
  String get queue1 => 'คิว';

  @override
  String get recentlyPlayed => 'เพิ่งเล่น';

  @override
  String get removeFromQueue => 'นำออกจากคิว';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get searchMusicArtistsAlbums => 'ค้นหาเพลง ศิลปิน อัลบั้ม...';

  @override
  String get share => 'แชร์';

  @override
  String featuringArtist(String artistName) {
    return 'ร่วมกับ $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'ปัจจุบัน: $country';
  }

  @override
  String get queueTooltip => 'คิว';

  @override
  String get searchHint => 'ค้นหาเพลง ศิลปิน อัลบั้ม...';

  @override
  String get language => 'ภาษา';

  @override
  String get systemDefault => 'ค่าเริ่มต้นของระบบ';

  @override
  String get songsTab => 'เพลง';

  @override
  String get foldersTab => 'โฟลเดอร์';

  @override
  String get artistsTab => 'ศิลปิน';

  @override
  String get albumsTab => 'อัลบั้ม';

  @override
  String get genresTab => 'ประเภท';

  @override
  String get noLocalGenres => 'ไม่พบประเภทเพลง';

  @override
  String get playbackSpeed => 'ความเร็วในการเล่น';

  @override
  String get addMusic => 'เพิ่มเพลง';

  @override
  String get addFiles => 'เพิ่มไฟล์';

  @override
  String get addFolder => 'เพิ่มโฟลเดอร์';

  @override
  String get rescanLibrary => 'สแกนคลังใหม่';

  @override
  String get sortTitle => 'ชื่อ';

  @override
  String get sortArtist => 'ศิลปิน';

  @override
  String get sortAlbum => 'อัลบั้ม';

  @override
  String get sortDuration => 'ระยะเวลา';

  @override
  String get sortDateAdded => 'วันที่เพิ่ม';

  @override
  String get sortBy => 'จัดเรียงตาม';

  @override
  String get trackInformation => 'ข้อมูลแทร็ก';

  @override
  String get removeFromLibrary => 'นำออกจากคลัง';

  @override
  String get showInFolder => 'แสดงในโฟลเดอร์';

  @override
  String get unknownArtist => 'ศิลปินที่ไม่รู้จัก';

  @override
  String get unknownAlbum => 'อัลบั้มที่ไม่รู้จัก';

  @override
  String get importedFiles => 'ไฟล์ที่นำเข้า';

  @override
  String get playFolder => 'เล่นโฟลเดอร์';

  @override
  String get shuffleFolder => 'สุ่มโฟลเดอร์';

  @override
  String get playAll => 'เล่นทั้งหมด';

  @override
  String get includeSubfolders => 'รวมโฟลเดอร์ย่อย';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เพลง',
      one: '1 เพลง',
      zero: '0 เพลง',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'ไม่มีเพลงในเครื่องที่นำเข้า';

  @override
  String get searchLocalMusic => 'ค้นหาเพลงในเครื่อง';

  @override
  String get viewAsList => 'ดูเป็นรายการ';

  @override
  String get viewAsGrid => 'ดูเป็นตาราง';

  @override
  String get trackInfoPath => 'เส้นทาง';

  @override
  String get trackInfoFormat => 'รูปแบบ';

  @override
  String get trackInfoDuration => 'ระยะเวลา';

  @override
  String get aboutDescription => 'โปรแกรมเล่นสื่อแบบโอเพนซอร์สฟรี';

  @override
  String get aboutApp => 'เกี่ยวกับ PPPlayer';

  @override
  String get appTagline => 'เพลงของคุณ ในแบบของคุณ';

  @override
  String get exploreApp => 'สำรวจ PPPlayer';

  @override
  String get viewSource => 'ดูซอร์สโค้ด';

  @override
  String get seeWhatsNew => 'ดูว่ามีอะไรใหม่';

  @override
  String get getHelp => 'รับความช่วยเหลือ';

  @override
  String versionInfo(Object version, Object build) {
    return 'เวอร์ชัน $version (บิลด์ $build)';
  }

  @override
  String get createdBy => 'สร้างโดย Lucas Coelho';

  @override
  String get website => 'เว็บไซต์';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'บันทึกประจำรุ่น';

  @override
  String get support => 'การสนับสนุน';

  @override
  String get license => 'ใบอนุญาต';

  @override
  String get acknowledgments => 'กิตติกรรมประกาศ';

  @override
  String get close => 'ปิด';

  @override
  String copyright(Object year) {
    return '© $year ผู้ร่วมให้ข้อมูล PPPlayer';
  }

  @override
  String get goodMorning => 'สวัสดีตอนเช้า';

  @override
  String get goodAfternoon => 'สวัสดีตอนบ่าย';

  @override
  String get goodEvening => 'สวัสดีตอนเย็น';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting $name';
  }

  @override
  String get yourMusicIsWaiting => 'เพลงของคุณกำลังรออยู่';

  @override
  String dailyMix(Object number) {
    return 'มิกซ์ประจำวัน $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'รายการโปรดของคุณ\nและการค้นพบใหม่ๆ';

  @override
  String get discoverWeekly => 'ค้นพบประจำสัปดาห์';

  @override
  String get releaseRadar => 'เรดาร์เพลงใหม่';

  @override
  String get newMusicJustForYou => 'เพลงใหม่\nสำหรับคุณโดยเฉพาะ';

  @override
  String get chillMix => 'มิกซ์ชิลล์ๆ';

  @override
  String get relaxAndUnwind => 'พักผ่อนและผ่อนคลาย';

  @override
  String get focusMix => 'มิกซ์มีสมาธิ';

  @override
  String get deepFocusAndProductivity =>
      'มีสมาธิอย่างลึกซึ้ง\nและทำงานอย่างมีประสิทธิภาพ';

  @override
  String artistRadio(Object artist) {
    return 'วิทยุของ $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'วิทยุ $genre';
  }

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterPlaylists => 'เพลย์ลิสต์';

  @override
  String get filterArtists => 'ศิลปิน';

  @override
  String get filterAlbums => 'อัลบั้ม';

  @override
  String get filterStations => 'สถานี';

  @override
  String get filterStreams => 'สตรีม';

  @override
  String get localMusicCard => 'เพลงในเครื่อง';

  @override
  String get createPlaylistButton => 'สร้างเพลย์ลิสต์';

  @override
  String get radioStations => 'สถานีวิทยุ';

  @override
  String get discoverMusic => 'ค้นพบเพลง';

  @override
  String get importLocalMusic => 'นำเข้าเพลงในเครื่อง';

  @override
  String get importAudioFiles => 'นำเข้าไฟล์เสียง';

  @override
  String get importFolder => 'นำเข้าโฟลเดอร์';

  @override
  String get importFolderSubtitle =>
      'หมายเหตุ: ไฟล์เสียงจะถูกซ่อนไว้ในตัวเลือกโฟลเดอร์ ซึ่งเป็นเรื่องปกติ';

  @override
  String get importPlaylist => 'นำเข้าเพลย์ลิสต์';

  @override
  String get importPlaylistSubtitle => 'นำเข้าไฟล์ .m3u หรือ .m3u8';

  @override
  String get exportPlaylist => 'ส่งออกเพลย์ลิสต์';

  @override
  String get playbackErrorUnsupportedFormat => 'ไม่รองรับรูปแบบหรือไฟล์เสียหาย';

  @override
  String get playbackErrorFileInaccessible =>
      'ไม่สามารถเข้าถึงไฟล์ได้หรือไม่พบไฟล์';

  @override
  String get localVideosCard => 'วิดีโอในเครื่อง';

  @override
  String get noLocalVideos => 'ไม่พบวิดีโอ';

  @override
  String get searchLocalVideos => 'ค้นหาวิดีโอในเครื่อง';

  @override
  String get addVideos => 'เพิ่มวิดีโอ';

  @override
  String get subtitles => 'คำบรรยาย';

  @override
  String get audioTracks => 'แทร็กเสียง';

  @override
  String get loadSubtitleFile => 'โหลดไฟล์คำบรรยาย...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'เกิดข้อผิดพลาดในการโหลดคำบรรยาย: $error';
  }

  @override
  String get off => 'ปิด';
}
