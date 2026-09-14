// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => '앨범';

  @override
  String get api => 'API';

  @override
  String get artists => '아티스트';

  @override
  String get artwork => '아트워크';

  @override
  String get appVersion => '앱 버전';

  @override
  String get artist => '아티스트';

  @override
  String get artistsYouFollow => '팔로우하는 아티스트';

  @override
  String get autoplay => '자동 재생';

  @override
  String get becauseYouListenedTo => '이전에 들었던 음악을 기반으로';

  @override
  String get browseAll => '모두 찾아보기';

  @override
  String get cancel => '취소';

  @override
  String get clearAppCache => '앱 캐시를 지우시겠습니까?';

  @override
  String get clearCache => '캐시 지우기';

  @override
  String get clearHistory => '기록을 지우시겠습니까?';

  @override
  String get clearRecentlyPlayed => '최근 재생 지우기';

  @override
  String get contentMarket => '콘텐츠 마켓';

  @override
  String get continueListening => '계속 듣기';

  @override
  String get continueVideoPlaybackInASmallWindow => '작은 창에서 동영상 재생 계속하기';

  @override
  String get create => '만들기';

  @override
  String get createAPlaylistToGetStarted => '시작하려면 플레이리스트를 만드세요';

  @override
  String currentSelectedcountry(Object country) {
    return '현재: $country';
  }

  @override
  String get deletePlaylist => '플레이리스트 삭제';

  @override
  String get editProfile => '프로필 수정';

  @override
  String errorLoadingMarkets(Object err) {
    return '마켓을 불러오는 중 오류 발생: $err';
  }

  @override
  String error(Object error) {
    return '오류: $error';
  }

  @override
  String explore(Object genre) {
    return '$genre 둘러보기';
  }

  @override
  String get fansAlsoLike => '팬들이 좋아하는 음악';

  @override
  String featuringTouppercase(Object artist) {
    return '피처링 $artist';
  }

  @override
  String get featuredPlaylists => '추천 플레이리스트';

  @override
  String get followArtistsToSeeThemHere => '아티스트를 팔로우하면 여기에 표시됩니다';

  @override
  String get followStationsToSeeThemHere => '스테이션을 팔로우하면 여기에 표시됩니다';

  @override
  String get forceAudioonlyStreamsToSaveData => '데이터를 절약하기 위해 오디오 전용 스트림 강제 사용';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      '공간을 확보하고 다음 로드 시 새 데이터를 강제로 가져옵니다';

  @override
  String get fromYourFavorites => '즐겨찾기에서';

  @override
  String get goBack => '뒤로 가기';

  @override
  String inspiredByName(Object name) {
    return '$name에서 영감을 받아';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds => '대기열이 끝나면 비슷한 트랙 계속 재생';

  @override
  String get library => '라이브러리';

  @override
  String get likeAlbumsToSeeThemHere => '앨범에 \'좋아요\'를 누르면 여기에 표시됩니다';

  @override
  String get likedSongs => '좋아요 표시한 곡';

  @override
  String get lowDataMode => '데이터 절약 모드';

  @override
  String get madeForYou => '맞춤 믹스';

  @override
  String moreLikeName(Object name) {
    return '$name와 비슷한 음악';
  }

  @override
  String get moreOptions => '추가 옵션';

  @override
  String get nameYourMasterpiece => '멋진 이름을 지어주세요...';

  @override
  String get newPlaylist => '새 플레이리스트';

  @override
  String get newReleases => '새로운 릴리스';

  @override
  String get next => '다음';

  @override
  String get noAlbumsFound => '앨범을 찾을 수 없습니다';

  @override
  String get noArtistsFollowed => '팔로우한 아티스트가 없습니다';

  @override
  String get noArtistsFound => '아티스트를 찾을 수 없습니다';

  @override
  String get noLikedAlbums => '좋아요 표시한 앨범이 없습니다';

  @override
  String get noPlaylistsFound => '플레이리스트를 찾을 수 없습니다';

  @override
  String get noPlaylistsYet => '아직 플레이리스트가 없습니다';

  @override
  String get noResultsFound => '결과를 찾을 수 없습니다';

  @override
  String get noStationsFollowed => '팔로우한 스테이션이 없습니다';

  @override
  String get noTrackPlaying => '재생 중인 트랙이 없습니다';

  @override
  String get noTracksFound => '트랙을 찾을 수 없습니다';

  @override
  String get playlists => '플레이리스트';

  @override
  String get popular => '인기';

  @override
  String get permanentlyRemoveListeningHistory => '청취 기록 영구 삭제';

  @override
  String get pictureinpicturePip => 'PIP 모드 (Picture-in-Picture)';

  @override
  String get popularAlbums => '인기 앨범';

  @override
  String get popularArtists => '인기 아티스트';

  @override
  String get popularGenres => '인기 장르';

  @override
  String get popularSongs => '인기 곡';

  @override
  String get popularTracks => '인기 트랙';

  @override
  String get popularHitsRightNow => '지금 인기 있는 히트곡';

  @override
  String get previous => '이전';

  @override
  String get queue => '대기열';

  @override
  String get recentSearches => '최근 검색';

  @override
  String get recommendedForYou => '추천 음악';

  @override
  String get scraping => '스크랩 중';

  @override
  String get search => '검색';

  @override
  String get searchInAlbum => '앨범에서 검색...';

  @override
  String get searchInLibrary => '라이브러리에서 검색...';

  @override
  String get searchInPlaylist => '플레이리스트에서 검색';

  @override
  String get searchLikedSongs => '좋아요 표시한 곡에서 검색...';

  @override
  String get searchPopularSongs => '인기 곡 검색...';

  @override
  String get selectMarket => '마켓 선택';

  @override
  String get settings => '설정';

  @override
  String get showVideoPlayer => '동영상 플레이어 표시';

  @override
  String get shuffle => '셔플';

  @override
  String get spotifyCredentials => 'Spotify 자격 증명';

  @override
  String get suggestedStations => '추천 스테이션';

  @override
  String get tracks => '트랙';

  @override
  String get trending => '트렌딩';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get tryADifferentSearchTerm => '다른 검색어를 시도해 보세요';

  @override
  String get useYoutubePlayerWhenAvailable => '가능한 경우 YouTube 플레이어 사용';

  @override
  String get video => '동영상';

  @override
  String get whatDoYouWantToListenTo => '어떤 음악을 듣고 싶으신가요?';

  @override
  String get youtubeCredentials => 'YouTube 자격 증명';

  @override
  String get yourLibrary => '내 라이브러리';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => '플레이리스트에 추가';

  @override
  String get addToQueue => '대기열에 추가';

  @override
  String get copyId => 'ID 복사';

  @override
  String get copyLink => '링크 복사';

  @override
  String get discover => '둘러보기';

  @override
  String get enterYourName => '이름을 입력하세요';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get goToAlbum => '앨범으로 이동';

  @override
  String get goToArtist => '아티스트로 이동';

  @override
  String get goToArtistRadio => '아티스트 라디오로 이동';

  @override
  String get goToPlaylist => '플레이리스트로 이동';

  @override
  String get goToSongRadio => '곡 라디오로 이동';

  @override
  String get home => '홈';

  @override
  String get myAwesomePlaylist => '나의 멋진 플레이리스트';

  @override
  String get myPlaylist => '내 플레이리스트';

  @override
  String get newPlaylist1 => '새 플레이리스트';

  @override
  String get play => '재생';

  @override
  String get playStation => '스테이션 재생';

  @override
  String get playNext => '다음 재생';

  @override
  String get playlist => '플레이리스트';

  @override
  String get playlistName => '플레이리스트 이름';

  @override
  String get playlists1 => '플레이리스트';

  @override
  String get queue1 => '대기열';

  @override
  String get recentlyPlayed => '최근 재생';

  @override
  String get removeFromQueue => '대기열에서 삭제';

  @override
  String get retry => '다시 시도';

  @override
  String get searchMusicArtistsAlbums => '음악, 아티스트, 앨범 검색...';

  @override
  String get share => '공유';

  @override
  String featuringArtist(String artistName) {
    return '피처링: $artistName';
  }

  @override
  String currentCountry(String country) {
    return '현재: $country';
  }

  @override
  String get queueTooltip => '대기열';

  @override
  String get searchHint => '음악, 아티스트, 앨범 검색...';

  @override
  String get language => '언어';

  @override
  String get systemDefault => '시스템 기본값';

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
  String get aboutDescription => '무료 오픈 소스 음악 플레이어입니다.';

  @override
  String versionInfo(Object version, Object build) {
    return '버전 $version (빌드 $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho 제작';

  @override
  String get website => '웹사이트';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => '릴리스 노트';

  @override
  String get support => '지원';

  @override
  String get license => '라이선스';

  @override
  String get acknowledgments => '감사';

  @override
  String get close => '닫기';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
  }
}
