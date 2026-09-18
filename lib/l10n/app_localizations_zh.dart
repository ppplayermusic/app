// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => '专辑';

  @override
  String get api => 'API';

  @override
  String get artists => '艺术家';

  @override
  String get artwork => '封面';

  @override
  String get appVersion => '应用版本';

  @override
  String get artist => '艺术家';

  @override
  String get artistsYouFollow => '你关注的艺术家';

  @override
  String get autoplay => '自动播放';

  @override
  String get becauseYouListenedTo => '因为你听过';

  @override
  String get browseAll => '浏览全部';

  @override
  String get cancel => '取消';

  @override
  String get clearAppCache => '清除应用缓存？';

  @override
  String get clearCache => '清除缓存';

  @override
  String get clearHistory => '清除历史记录？';

  @override
  String get clearRecentlyPlayed => '清除最近播放';

  @override
  String get contentMarket => '内容市场';

  @override
  String get continueListening => '继续聆听';

  @override
  String get continueVideoPlaybackInASmallWindow => '在小窗口中继续播放视频';

  @override
  String get create => '创建';

  @override
  String get createAPlaylistToGetStarted => '创建一个播放列表以开始';

  @override
  String currentSelectedcountry(Object country) {
    return '当前：$country';
  }

  @override
  String get deletePlaylist => '删除播放列表';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String errorLoadingMarkets(Object err) {
    return '加载市场时出错：$err';
  }

  @override
  String error(Object error) {
    return '错误：$error';
  }

  @override
  String explore(Object genre) {
    return '探索 $genre';
  }

  @override
  String get fansAlsoLike => '粉丝也喜欢';

  @override
  String featuringTouppercase(Object artist) {
    return '合作艺人 $artist';
  }

  @override
  String get featuredPlaylists => '精选播放列表';

  @override
  String get followArtistsToSeeThemHere => '关注艺术家以在这里看到他们';

  @override
  String get followStationsToSeeThemHere => '关注电台以在这里看到它们';

  @override
  String get forceAudioonlyStreamsToSaveData => '强制仅播放音频以节省数据';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad => '释放空间并在下次加载时强制获取新数据';

  @override
  String get fromYourFavorites => '来自你的收藏';

  @override
  String get goBack => '返回';

  @override
  String inspiredByName(Object name) {
    return '受 $name 启发';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds => '队列结束时继续播放相似曲目';

  @override
  String get library => '音乐库';

  @override
  String get likeAlbumsToSeeThemHere => '点赞专辑以在这里看到它们';

  @override
  String get likedSongs => '喜欢的歌曲';

  @override
  String get lowDataMode => '省流量模式';

  @override
  String get madeForYou => '为你打造';

  @override
  String moreLikeName(Object name) {
    return '更多类似 $name';
  }

  @override
  String get moreOptions => '更多选项';

  @override
  String get nameYourMasterpiece => '为你的杰作命名...';

  @override
  String get newPlaylist => '新播放列表';

  @override
  String get newReleases => '新发行';

  @override
  String get next => '下一首';

  @override
  String get noAlbumsFound => '未找到专辑';

  @override
  String get noArtistsFollowed => '未关注任何艺术家';

  @override
  String get noArtistsFound => '未找到艺术家';

  @override
  String get noLikedAlbums => '没有喜欢的专辑';

  @override
  String get noPlaylistsFound => '未找到播放列表';

  @override
  String get noPlaylistsYet => '暂无播放列表';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get noStationsFollowed => '未关注任何电台';

  @override
  String get noTrackPlaying => '当前没有播放曲目';

  @override
  String get noTracksFound => '未找到曲目';

  @override
  String get playlists => '播放列表';

  @override
  String get popular => '热门';

  @override
  String get permanentlyRemoveListeningHistory => '永久删除收听历史';

  @override
  String get pictureinpicturePip => '画中画 (PiP)';

  @override
  String get popularAlbums => '热门专辑';

  @override
  String get popularArtists => '热门艺术家';

  @override
  String get popularGenres => '热门流派';

  @override
  String get popularSongs => '热门歌曲';

  @override
  String get popularTracks => '热门曲目';

  @override
  String get popularHitsRightNow => '当前热门单曲';

  @override
  String get previous => '上一首';

  @override
  String get queue => '队列';

  @override
  String get recentSearches => '最近搜索';

  @override
  String get recommendedForYou => '为你推荐';

  @override
  String get scraping => '抓取中';

  @override
  String get search => '搜索';

  @override
  String get searchInAlbum => '在专辑中搜索...';

  @override
  String get searchInLibrary => '在音乐库中搜索...';

  @override
  String get searchInPlaylist => '在播放列表中搜索';

  @override
  String get searchLikedSongs => '在喜欢的歌曲中搜索...';

  @override
  String get searchPopularSongs => '搜索热门歌曲...';

  @override
  String get selectMarket => '选择市场';

  @override
  String get settings => '设置';

  @override
  String get showVideoPlayer => '显示视频播放器';

  @override
  String get shuffle => '随机播放';

  @override
  String get spotifyCredentials => 'Spotify 凭证';

  @override
  String get suggestedStations => '推荐电台';

  @override
  String get tracks => '曲目';

  @override
  String get trending => '趋势';

  @override
  String get tryAgain => '重试';

  @override
  String get tryADifferentSearchTerm => '尝试不同的搜索词';

  @override
  String get useYoutubePlayerWhenAvailable => '可用时使用 YouTube 播放器';

  @override
  String get video => '视频';

  @override
  String get whatDoYouWantToListenTo => '你想听什么？';

  @override
  String get youtubeCredentials => 'YouTube 凭证';

  @override
  String get yourLibrary => '你的音乐库';

  @override
  String get playerscreenviewswitch => '播放器屏幕视图切换';

  @override
  String get addToPlaylist => '添加到播放列表';

  @override
  String get addToQueue => '添加到队列';

  @override
  String get copyId => '复制 ID';

  @override
  String get copyLink => '复制链接';

  @override
  String get discover => '发现';

  @override
  String get enterYourName => '输入你的名字';

  @override
  String get favorites => '收藏夹';

  @override
  String get goToAlbum => '转到专辑';

  @override
  String get goToArtist => '转到艺术家';

  @override
  String get goToArtistRadio => '转到艺术家电台';

  @override
  String get goToPlaylist => '转到播放列表';

  @override
  String get goToSongRadio => '转到歌曲电台';

  @override
  String get home => '首页';

  @override
  String get myAwesomePlaylist => '我的超棒播放列表';

  @override
  String get myPlaylist => '我的播放列表';

  @override
  String get newPlaylist1 => '新播放列表';

  @override
  String get play => '播放';

  @override
  String get playStation => '播放电台';

  @override
  String get playNext => '下一首播放';

  @override
  String get playlist => '播放列表';

  @override
  String get playlistName => '播放列表名称';

  @override
  String get playlists1 => '播放列表';

  @override
  String get queue1 => '队列';

  @override
  String get recentlyPlayed => '最近播放';

  @override
  String get removeFromQueue => '从队列中移除';

  @override
  String get retry => '重试';

  @override
  String get searchMusicArtistsAlbums => '搜索音乐、艺术家、专辑...';

  @override
  String get share => '分享';

  @override
  String featuringArtist(String artistName) {
    return '合作艺人: $artistName';
  }

  @override
  String currentCountry(String country) {
    return '当前: $country';
  }

  @override
  String get queueTooltip => '播放队列';

  @override
  String get searchHint => '搜索音乐、歌手、专辑...';

  @override
  String get language => '语言';

  @override
  String get systemDefault => '系统默认';

  @override
  String get songsTab => '歌曲';

  @override
  String get foldersTab => '文件夹';

  @override
  String get artistsTab => '艺术家';

  @override
  String get albumsTab => '专辑';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get addMusic => '添加音乐';

  @override
  String get addFiles => '添加文件';

  @override
  String get addFolder => '添加文件夹';

  @override
  String get rescanLibrary => '重新扫描库';

  @override
  String get sortTitle => '按标题排序';

  @override
  String get sortArtist => '按艺术家排序';

  @override
  String get sortAlbum => '按专辑排序';

  @override
  String get sortDuration => '按时长排序';

  @override
  String get sortDateAdded => '按添加日期排序';

  @override
  String get sortBy => 'Sort by';

  @override
  String get trackInformation => '曲目信息';

  @override
  String get removeFromLibrary => '从库中移除';

  @override
  String get showInFolder => '在文件夹中显示';

  @override
  String get unknownArtist => '未知艺术家';

  @override
  String get unknownAlbum => '未知专辑';

  @override
  String get importedFiles => '导入的文件';

  @override
  String get playFolder => '播放文件夹';

  @override
  String get shuffleFolder => '随机播放文件夹';

  @override
  String get playAll => '播放全部';

  @override
  String get includeSubfolders => '包含子文件夹';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首曲目',
      one: '1 首曲目',
      zero: '0 首曲目',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => '未找到本地歌曲';

  @override
  String get searchLocalMusic => '搜索本地音乐...';

  @override
  String get viewAsList => '列表视图';

  @override
  String get viewAsGrid => '网格视图';

  @override
  String get trackInfoPath => '路径';

  @override
  String get trackInfoFormat => '格式';

  @override
  String get trackInfoDuration => '时长';

  @override
  String get aboutDescription => '免费、开源的音乐播放器。';

  @override
  String versionInfo(Object version, Object build) {
    return '版本 $version (构建 $build)';
  }

  @override
  String get createdBy => '由 Lucas Coelho 创建';

  @override
  String get website => '网站';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => '发行说明';

  @override
  String get support => '支持';

  @override
  String get license => '许可证';

  @override
  String get acknowledgments => '鸣谢';

  @override
  String get close => '关闭';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer 贡献者';
  }

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => '你的音乐在等你。';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries => '你的最爱\n和新发现';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => '专为你准备的\n新音乐';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => '放松身心';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => '深度专注\n与效率';

  @override
  String artistRadio(Object artist) {
    return '$artist 电台';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre 电台';
  }

  @override
  String get filterAll => '全部';

  @override
  String get filterPlaylists => '播放列表';

  @override
  String get filterArtists => '艺术家';

  @override
  String get filterAlbums => '专辑';

  @override
  String get filterStations => '电台';

  @override
  String get localMusicCard => '本地音乐';

  @override
  String get createPlaylistButton => '创建播放列表';

  @override
  String get radioStations => '广播电台';

  @override
  String get discoverMusic => '发现音乐';

  @override
  String get importLocalMusic => '导入本地音乐';

  @override
  String get importAudioFiles => '导入音频文件';

  @override
  String get importFolder => '导入文件夹';

  @override
  String get importFolderSubtitle => '选择一个包含音频文件的文件夹';

  @override
  String get importPlaylist => 'Import Playlist';

  @override
  String get importPlaylistSubtitle => 'Import .m3u or .m3u8 files';

  @override
  String get exportPlaylist => 'Export Playlist';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Unsupported format or corrupted file';

  @override
  String get playbackErrorFileInaccessible => 'File inaccessible or not found';

  @override
  String get localVideosCard => 'Local Videos';

  @override
  String get noLocalVideos => 'No videos found';

  @override
  String get searchLocalVideos => 'Search local videos';

  @override
  String get addVideos => 'Add Videos';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get audioTracks => 'Audio Tracks';

  @override
  String get loadSubtitleFile => 'Load subtitle file...';

  @override
  String errorLoadingSubtitle(String error) {
    return '加载字幕时出错：$error';
  }

  @override
  String get off => 'Off';
}
