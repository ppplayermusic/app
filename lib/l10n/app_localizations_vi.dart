// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUM';

  @override
  String get api => 'API';

  @override
  String get artists => 'NGHỆ SĨ';

  @override
  String get artwork => 'ẢNH BÌA';

  @override
  String get appVersion => 'Phiên bản ứng dụng';

  @override
  String get artist => 'Nghệ sĩ';

  @override
  String get artistsYouFollow => 'Nghệ sĩ bạn theo dõi';

  @override
  String get autoplay => 'Tự động phát';

  @override
  String get becauseYouListenedTo => 'Vì bạn đã nghe';

  @override
  String get browseAll => 'Duyệt tất cả';

  @override
  String get cancel => 'Hủy';

  @override
  String get clearAppCache => 'Xóa bộ nhớ cache của ứng dụng?';

  @override
  String get clearCache => 'Xóa bộ nhớ cache';

  @override
  String get clearHistory => 'Xóa lịch sử?';

  @override
  String get clearRecentlyPlayed => 'Xóa nội dung vừa phát';

  @override
  String get contentMarket => 'Thị trường nội dung';

  @override
  String get continueListening => 'Tiếp tục nghe';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Tiếp tục phát video trong cửa sổ nhỏ';

  @override
  String get create => 'Tạo';

  @override
  String get createAPlaylistToGetStarted => 'Tạo danh sách phát để bắt đầu';

  @override
  String currentSelectedcountry(Object country) {
    return 'Hiện tại: $country';
  }

  @override
  String get deletePlaylist => 'Xóa danh sách phát';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Lỗi khi tải thị trường: $err';
  }

  @override
  String error(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String explore(Object genre) {
    return 'Khám phá $genre';
  }

  @override
  String get fansAlsoLike => 'NGƯỜI HÂM MỘ CŨNG THÍCH';

  @override
  String featuringTouppercase(Object artist) {
    return 'CÓ SỰ THAM GIA CỦA $artist';
  }

  @override
  String get featuredPlaylists => 'Danh sách phát nổi bật';

  @override
  String get followArtistsToSeeThemHere => 'Theo dõi nghệ sĩ để xem họ ở đây';

  @override
  String get followStationsToSeeThemHere => 'Theo dõi đài để xem ở đây';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Bắt buộc chỉ phát âm thanh để tiết kiệm dữ liệu';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Giải phóng dung lượng và bắt buộc tải dữ liệu mới trong lần tiếp theo';

  @override
  String get fromYourFavorites => 'Từ mục yêu thích của bạn';

  @override
  String get goBack => 'Quay lại';

  @override
  String inspiredByName(Object name) {
    return 'Lấy cảm hứng từ $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Tiếp tục phát các bài hát tương tự khi kết thúc danh sách chờ';

  @override
  String get library => 'Thư viện';

  @override
  String get likeAlbumsToSeeThemHere => 'Thích album để xem chúng ở đây';

  @override
  String get likedSongs => 'Bài hát đã thích';

  @override
  String get lowDataMode => 'Chế độ tiết kiệm dữ liệu';

  @override
  String get madeForYou => 'Dành cho bạn';

  @override
  String moreLikeName(Object name) {
    return 'Tương tự như $name';
  }

  @override
  String get moreOptions => 'Tùy chọn khác';

  @override
  String get nameYourMasterpiece => 'Đặt tên cho kiệt tác của bạn...';

  @override
  String get newPlaylist => 'Danh sách phát mới';

  @override
  String get newReleases => 'Bản phát hành mới';

  @override
  String get next => 'Tiếp theo';

  @override
  String get noAlbumsFound => 'Không tìm thấy album nào';

  @override
  String get noArtistsFollowed => 'Chưa theo dõi nghệ sĩ nào';

  @override
  String get noArtistsFound => 'Không tìm thấy nghệ sĩ nào';

  @override
  String get noLikedAlbums => 'Không có album đã thích';

  @override
  String get noPlaylistsFound => 'Không tìm thấy danh sách phát nào';

  @override
  String get noPlaylistsYet => 'Chưa có danh sách phát nào';

  @override
  String get noResultsFound => 'Không tìm thấy kết quả';

  @override
  String get noStationsFollowed => 'Chưa theo dõi đài nào';

  @override
  String get noTrackPlaying => 'Không có bài hát nào đang phát';

  @override
  String get noTracksFound => 'Không tìm thấy bài hát nào';

  @override
  String get playlists => 'DANH SÁCH PHÁT';

  @override
  String get popular => 'PHỔ BIẾN';

  @override
  String get permanentlyRemoveListeningHistory => 'Xóa vĩnh viễn lịch sử nghe';

  @override
  String get pictureinpicturePip => 'Hình trong hình (PiP)';

  @override
  String get popularAlbums => 'Album phổ biến';

  @override
  String get popularArtists => 'Nghệ sĩ phổ biến';

  @override
  String get popularGenres => 'Thể loại phổ biến';

  @override
  String get popularSongs => 'Bài hát phổ biến';

  @override
  String get popularTracks => 'Bản nhạc phổ biến';

  @override
  String get popularHitsRightNow => 'Bản hit phổ biến hiện nay';

  @override
  String get previous => 'Trước đó';

  @override
  String get queue => 'DANH SÁCH CHỜ';

  @override
  String get recentSearches => 'Tìm kiếm gần đây';

  @override
  String get recommendedForYou => 'Đề xuất cho bạn';

  @override
  String get scraping => 'Đang trích xuất';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchInAlbum => 'Tìm kiếm trong album...';

  @override
  String get searchInLibrary => 'Tìm kiếm trong thư viện...';

  @override
  String get searchInPlaylist => 'Tìm kiếm trong danh sách phát';

  @override
  String get searchLikedSongs => 'Tìm kiếm bài hát đã thích...';

  @override
  String get searchPopularSongs => 'Tìm kiếm bài hát phổ biến...';

  @override
  String get selectMarket => 'Chọn thị trường';

  @override
  String get settings => 'Cài đặt';

  @override
  String get showVideoPlayer => 'Hiển thị trình phát video';

  @override
  String get shuffle => 'Phát ngẫu nhiên';

  @override
  String get spotifyCredentials => 'Thông tin xác thực Spotify';

  @override
  String get suggestedStations => 'Đài được đề xuất';

  @override
  String get tracks => 'BÀI HÁT';

  @override
  String get trending => 'Thịnh hành';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get tryADifferentSearchTerm => 'Hãy thử một từ khóa tìm kiếm khác';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Sử dụng trình phát YouTube khi khả dụng';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Bạn muốn nghe gì?';

  @override
  String get youtubeCredentials => 'Thông tin xác thực YouTube';

  @override
  String get yourLibrary => 'Thư viện của bạn';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Thêm vào danh sách phát';

  @override
  String get addToQueue => 'Thêm vào danh sách chờ';

  @override
  String get copyId => 'Sao chép ID';

  @override
  String get copyLink => 'Sao chép liên kết';

  @override
  String get discover => 'Khám phá';

  @override
  String get enterYourName => 'Nhập tên của bạn';

  @override
  String get favorites => 'Yêu thích';

  @override
  String get goToAlbum => 'Đi tới album';

  @override
  String get goToArtist => 'Đi tới nghệ sĩ';

  @override
  String get goToArtistRadio => 'Đi tới đài của nghệ sĩ';

  @override
  String get goToPlaylist => 'Đi tới danh sách phát';

  @override
  String get goToSongRadio => 'Đi tới đài của bài hát';

  @override
  String get home => 'Trang chủ';

  @override
  String get myAwesomePlaylist => 'Danh sách phát tuyệt vời của tôi';

  @override
  String get myPlaylist => 'Danh sách phát của tôi';

  @override
  String get newPlaylist1 => 'Danh sách phát mới';

  @override
  String get play => 'Phát';

  @override
  String get playStation => 'Phát đài';

  @override
  String get playNext => 'Phát tiếp theo';

  @override
  String get playlist => 'Danh sách phát';

  @override
  String get playlistName => 'Tên danh sách phát';

  @override
  String get playlists1 => 'Danh sách phát';

  @override
  String get queue1 => 'Danh sách chờ';

  @override
  String get recentlyPlayed => 'Vừa mới phát';

  @override
  String get removeFromQueue => 'Xóa khỏi danh sách chờ';

  @override
  String get retry => 'Thử lại';

  @override
  String get searchMusicArtistsAlbums => 'Tìm kiếm nhạc, nghệ sĩ, album...';

  @override
  String get share => 'Chia sẻ';

  @override
  String featuringArtist(String artistName) {
    return 'CÓ SỰ THAM GIA CỦA $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Hiện tại: $country';
  }

  @override
  String get queueTooltip => 'Danh sách chờ';

  @override
  String get searchHint => 'Tìm kiếm nhạc, nghệ sĩ, album...';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get systemDefault => 'Mặc định hệ thống';

  @override
  String get songsTab => 'Bài hát';

  @override
  String get foldersTab => 'Thư mục';

  @override
  String get artistsTab => 'Nghệ sĩ';

  @override
  String get albumsTab => 'Album';

  @override
  String get genresTab => 'Thể loại';

  @override
  String get noLocalGenres => 'Không tìm thấy thể loại nào';

  @override
  String get playbackSpeed => 'Tốc độ phát';

  @override
  String get addMusic => 'Thêm nhạc';

  @override
  String get addFiles => 'Thêm tệp';

  @override
  String get addFolder => 'Thêm thư mục';

  @override
  String get rescanLibrary => 'Quét lại thư viện';

  @override
  String get sortTitle => 'Tiêu đề';

  @override
  String get sortArtist => 'Nghệ sĩ';

  @override
  String get sortAlbum => 'Album';

  @override
  String get sortDuration => 'Thời lượng';

  @override
  String get sortDateAdded => 'Ngày thêm';

  @override
  String get sortBy => 'Sắp xếp theo';

  @override
  String get trackInformation => 'Thông tin bài hát';

  @override
  String get removeFromLibrary => 'Xóa khỏi thư viện';

  @override
  String get showInFolder => 'Hiển thị trong thư mục';

  @override
  String get unknownArtist => 'Nghệ sĩ không xác định';

  @override
  String get unknownAlbum => 'Album không xác định';

  @override
  String get importedFiles => 'Tệp đã nhập';

  @override
  String get playFolder => 'Phát thư mục';

  @override
  String get shuffleFolder => 'Phát ngẫu nhiên thư mục';

  @override
  String get playAll => 'Phát tất cả';

  @override
  String get includeSubfolders => 'Bao gồm thư mục con';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bài hát',
      one: '1 bài hát',
      zero: '0 bài hát',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Chưa nhập bài hát cục bộ nào';

  @override
  String get searchLocalMusic => 'Tìm kiếm nhạc cục bộ';

  @override
  String get viewAsList => 'Xem dưới dạng danh sách';

  @override
  String get viewAsGrid => 'Xem dưới dạng lưới';

  @override
  String get trackInfoPath => 'Đường dẫn';

  @override
  String get trackInfoFormat => 'Định dạng';

  @override
  String get trackInfoDuration => 'Thời lượng';

  @override
  String get aboutDescription =>
      'Trình phát đa phương tiện miễn phí, mã nguồn mở.';

  @override
  String get aboutApp => 'Giới thiệu PPPlayer';

  @override
  String get appTagline => 'Âm nhạc của bạn. Theo cách của bạn.';

  @override
  String get exploreApp => 'Khám phá PPPlayer';

  @override
  String get viewSource => 'Xem mã nguồn';

  @override
  String get seeWhatsNew => 'Xem tính năng mới';

  @override
  String get getHelp => 'Nhận trợ giúp';

  @override
  String versionInfo(Object version, Object build) {
    return 'Phiên bản $version (Bản dựng $build)';
  }

  @override
  String get createdBy => 'Được tạo bởi Lucas Coelho';

  @override
  String get website => 'Trang web';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Ghi chú phát hành';

  @override
  String get support => 'Hỗ trợ';

  @override
  String get license => 'Giấy phép';

  @override
  String get acknowledgments => 'Lời cảm ơn';

  @override
  String get close => 'Đóng';

  @override
  String copyright(Object year) {
    return '© $year Các cộng tác viên PPPlayer';
  }

  @override
  String get goodMorning => 'Chào buổi sáng';

  @override
  String get goodAfternoon => 'Chào buổi chiều';

  @override
  String get goodEvening => 'Chào buổi tối';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Âm nhạc của bạn đang chờ.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Mục yêu thích của bạn\nvà những khám phá mới';

  @override
  String get discoverWeekly => 'Khám phá hàng tuần';

  @override
  String get releaseRadar => 'Radar phát hành';

  @override
  String get newMusicJustForYou => 'Âm nhạc mới\ndành riêng cho bạn';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Thư giãn và giải trí';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Tập trung sâu\nvà hiệu suất';

  @override
  String artistRadio(Object artist) {
    return 'Đài của $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'Đài $genre';
  }

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterPlaylists => 'Danh sách phát';

  @override
  String get filterArtists => 'Nghệ sĩ';

  @override
  String get filterAlbums => 'Album';

  @override
  String get filterStations => 'Đài';

  @override
  String get filterStreams => 'Luồng';

  @override
  String get localMusicCard => 'Nhạc cục bộ';

  @override
  String get createPlaylistButton => 'Tạo danh sách phát';

  @override
  String get radioStations => 'Đài phát thanh';

  @override
  String get discoverMusic => 'Khám phá âm nhạc';

  @override
  String get importLocalMusic => 'Nhập nhạc cục bộ';

  @override
  String get importAudioFiles => 'Nhập tệp âm thanh';

  @override
  String get importFolder => 'Nhập thư mục';

  @override
  String get importFolderSubtitle =>
      'Lưu ý: Các tệp âm thanh bị ẩn trong bộ chọn thư mục. Điều này là bình thường.';

  @override
  String get importPlaylist => 'Nhập danh sách phát';

  @override
  String get importPlaylistSubtitle => 'Nhập tệp .m3u hoặc .m3u8';

  @override
  String get exportPlaylist => 'Xuất danh sách phát';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Định dạng không được hỗ trợ hoặc tệp bị hỏng';

  @override
  String get playbackErrorFileInaccessible =>
      'Không thể truy cập tệp hoặc không tìm thấy tệp';

  @override
  String get localVideosCard => 'Video cục bộ';

  @override
  String get noLocalVideos => 'Không tìm thấy video nào';

  @override
  String get searchLocalVideos => 'Tìm kiếm video cục bộ';

  @override
  String get addVideos => 'Thêm video';

  @override
  String get subtitles => 'Phụ đề';

  @override
  String get audioTracks => 'Bản âm thanh';

  @override
  String get loadSubtitleFile => 'Tải tệp phụ đề...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Lỗi khi tải phụ đề: $error';
  }

  @override
  String get off => 'Tắt';
}
