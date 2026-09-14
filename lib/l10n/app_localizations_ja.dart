// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'アルバム';

  @override
  String get api => 'API';

  @override
  String get artists => 'アーティスト';

  @override
  String get artwork => 'アートワーク';

  @override
  String get appVersion => 'アプリのバージョン';

  @override
  String get artist => 'アーティスト';

  @override
  String get artistsYouFollow => 'フォローしているアーティスト';

  @override
  String get autoplay => '自動再生';

  @override
  String get becauseYouListenedTo => 'これを聴いたあなたへ';

  @override
  String get browseAll => 'すべて見る';

  @override
  String get cancel => 'キャンセル';

  @override
  String get clearAppCache => 'アプリのキャッシュを消去しますか？';

  @override
  String get clearCache => 'キャッシュを消去';

  @override
  String get clearHistory => '履歴を消去しますか？';

  @override
  String get clearRecentlyPlayed => '最近再生した項目を消去';

  @override
  String get contentMarket => 'コンテンツ市場';

  @override
  String get continueListening => '再生を続ける';

  @override
  String get continueVideoPlaybackInASmallWindow => '小さなウィンドウでビデオ再生を続ける';

  @override
  String get create => '作成';

  @override
  String get createAPlaylistToGetStarted => 'プレイリストを作成して始める';

  @override
  String currentSelectedcountry(Object country) {
    return '現在: $country';
  }

  @override
  String get deletePlaylist => 'プレイリストを削除';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String errorLoadingMarkets(Object err) {
    return '市場の読み込みエラー: $err';
  }

  @override
  String error(Object error) {
    return 'エラー: $error';
  }

  @override
  String explore(Object genre) {
    return '$genreを探索';
  }

  @override
  String get fansAlsoLike => 'ファンも好む';

  @override
  String featuringTouppercase(Object artist) {
    return '$artistをフィーチャー';
  }

  @override
  String get featuredPlaylists => '注目のプレイリスト';

  @override
  String get followArtistsToSeeThemHere => 'アーティストをフォローするとここに表示されます';

  @override
  String get followStationsToSeeThemHere => 'ステーションをフォローするとここに表示されます';

  @override
  String get forceAudioonlyStreamsToSaveData => 'データを節約するために音声のみのストリームを強制する';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      '空き容量を増やし、次回の読み込み時に新しいデータを強制します';

  @override
  String get fromYourFavorites => 'お気に入りから';

  @override
  String get goBack => '戻る';

  @override
  String inspiredByName(Object name) {
    return '$nameにインスパイアされて';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds => 'キューが終了したら似たトラックを再生し続ける';

  @override
  String get library => 'ライブラリ';

  @override
  String get likeAlbumsToSeeThemHere => 'アルバムに「いいね」するとここに表示されます';

  @override
  String get likedSongs => 'お気に入りの曲';

  @override
  String get lowDataMode => '低データモード';

  @override
  String get madeForYou => 'あなたのために';

  @override
  String moreLikeName(Object name) {
    return '$nameに似ている';
  }

  @override
  String get moreOptions => 'その他のオプション';

  @override
  String get nameYourMasterpiece => '傑作に名前を...';

  @override
  String get newPlaylist => '新しいプレイリスト';

  @override
  String get newReleases => '新しいリリース';

  @override
  String get next => '次へ';

  @override
  String get noAlbumsFound => 'アルバムが見つかりません';

  @override
  String get noArtistsFollowed => 'フォローしているアーティストはいません';

  @override
  String get noArtistsFound => 'アーティストが見つかりません';

  @override
  String get noLikedAlbums => 'お気に入りのアルバムはありません';

  @override
  String get noPlaylistsFound => 'プレイリストが見つかりません';

  @override
  String get noPlaylistsYet => 'プレイリストはまだありません';

  @override
  String get noResultsFound => '結果が見つかりません';

  @override
  String get noStationsFollowed => 'フォローしているステーションはありません';

  @override
  String get noTrackPlaying => '再生中のトラックはありません';

  @override
  String get noTracksFound => 'トラックが見つかりません';

  @override
  String get playlists => 'プレイリスト';

  @override
  String get popular => '人気';

  @override
  String get permanentlyRemoveListeningHistory => '再生履歴を完全に削除';

  @override
  String get pictureinpicturePip => 'ピクチャーインピクチャー（PiP）';

  @override
  String get popularAlbums => '人気のアルバム';

  @override
  String get popularArtists => '人気のアーティスト';

  @override
  String get popularGenres => '人気のジャンル';

  @override
  String get popularSongs => '人気の曲';

  @override
  String get popularTracks => '人気のトラック';

  @override
  String get popularHitsRightNow => '現在の人気ヒット';

  @override
  String get previous => '前へ';

  @override
  String get queue => 'キュー';

  @override
  String get recentSearches => '最近の検索';

  @override
  String get recommendedForYou => 'おすすめ';

  @override
  String get scraping => 'スクレイピング';

  @override
  String get search => '検索';

  @override
  String get searchInAlbum => 'アルバム内を検索...';

  @override
  String get searchInLibrary => 'ライブラリ内を検索...';

  @override
  String get searchInPlaylist => 'プレイリスト内を検索';

  @override
  String get searchLikedSongs => 'お気に入りの曲を検索...';

  @override
  String get searchPopularSongs => '人気の曲を検索...';

  @override
  String get selectMarket => '市場を選択';

  @override
  String get settings => '設定';

  @override
  String get showVideoPlayer => 'ビデオプレーヤーを表示';

  @override
  String get shuffle => 'シャッフル';

  @override
  String get spotifyCredentials => 'Spotify認証情報';

  @override
  String get suggestedStations => 'おすすめのステーション';

  @override
  String get tracks => 'トラック';

  @override
  String get trending => 'トレンド';

  @override
  String get tryAgain => '再試行';

  @override
  String get tryADifferentSearchTerm => '別の検索語をお試しください';

  @override
  String get useYoutubePlayerWhenAvailable => '可能な場合はYouTubeプレーヤーを使用';

  @override
  String get video => 'ビデオ';

  @override
  String get whatDoYouWantToListenTo => '何を聴きたいですか？';

  @override
  String get youtubeCredentials => 'YouTube認証情報';

  @override
  String get yourLibrary => 'マイライブラリ';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'プレイリストに追加';

  @override
  String get addToQueue => 'キューに追加';

  @override
  String get copyId => 'IDをコピー';

  @override
  String get copyLink => 'リンクをコピー';

  @override
  String get discover => '見つける';

  @override
  String get enterYourName => '名前を入力してください';

  @override
  String get favorites => 'お気に入り';

  @override
  String get goToAlbum => 'アルバムへ移動';

  @override
  String get goToArtist => 'アーティストへ移動';

  @override
  String get goToArtistRadio => 'アーティストラジオへ移動';

  @override
  String get goToPlaylist => 'プレイリストへ移動';

  @override
  String get goToSongRadio => 'ソングラジオへ移動';

  @override
  String get home => 'ホーム';

  @override
  String get myAwesomePlaylist => '私の素晴らしいプレイリスト';

  @override
  String get myPlaylist => 'マイプレイリスト';

  @override
  String get newPlaylist1 => '新しいプレイリスト';

  @override
  String get play => '再生';

  @override
  String get playStation => 'ステーションを再生';

  @override
  String get playNext => '次に再生';

  @override
  String get playlist => 'プレイリスト';

  @override
  String get playlistName => 'プレイリスト名';

  @override
  String get playlists1 => 'プレイリスト';

  @override
  String get queue1 => 'キュー';

  @override
  String get recentlyPlayed => '最近再生した項目';

  @override
  String get removeFromQueue => 'キューから削除';

  @override
  String get retry => '再試行';

  @override
  String get searchMusicArtistsAlbums => '音楽、アーティスト、アルバムを検索...';

  @override
  String get share => '共有';

  @override
  String featuringArtist(String artistName) {
    return '$artistName をフィーチャー';
  }

  @override
  String currentCountry(String country) {
    return '現在: $country';
  }

  @override
  String get queueTooltip => 'キュー';

  @override
  String get searchHint => '音楽、アーティスト、アルバムを検索...';

  @override
  String get language => '言語';

  @override
  String get systemDefault => 'システムデフォルト';

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
