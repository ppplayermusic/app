import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

enum PlayerView { video, artwork, queue }

enum PerformanceMode { high, balanced, powerSaver }

enum SpotifyProviderType { ppplayer, custom }

enum YoutubeSearchMethod { scraping, api }

enum YoutubeApiProviderType { ppplayer, custom }

enum VideoFitMode { fit, fill }

class SettingsState {
  final String selectedCountry;
  final bool showVideo;
  final PlayerView playerView;
  final int themeIndex;
  final PerformanceMode performanceMode;
  final bool lowDataMode;
  final String userName;
  final int userAvatarColorIndex;
  final String? userAvatarBase64;
  final bool isLoaded;

  // New Provider Settings
  final SpotifyProviderType spotifyProvider;
  final YoutubeSearchMethod youtubeSearchMethod;
  final YoutubeApiProviderType youtubeApiProvider;
  final bool autoplayEnabled;
  final bool continuePlaybackInPip;
  final String? languageCode;
  final VideoFitMode videoFitMode;

  SettingsState({
    required this.selectedCountry,
    this.showVideo = true,
    this.playerView = PlayerView.video,
    this.themeIndex = 0,
    this.performanceMode = PerformanceMode.balanced,
    this.lowDataMode = false,
    this.userName = '',
    this.userAvatarColorIndex = 0,
    this.userAvatarBase64,
    this.isLoaded = false,
    this.spotifyProvider = SpotifyProviderType.ppplayer,
    this.youtubeSearchMethod = YoutubeSearchMethod.scraping,
    this.youtubeApiProvider = YoutubeApiProviderType.ppplayer,
    this.autoplayEnabled = true,
    this.continuePlaybackInPip = false,
    this.languageCode,
    this.videoFitMode = VideoFitMode.fit,
  });

  SettingsState copyWith({
    String? selectedCountry,
    bool? showVideo,
    PlayerView? playerView,
    int? themeIndex,
    PerformanceMode? performanceMode,
    bool? lowDataMode,
    String? userName,
    int? userAvatarColorIndex,
    String? userAvatarBase64,
    bool? isLoaded,
    SpotifyProviderType? spotifyProvider,
    YoutubeSearchMethod? youtubeSearchMethod,
    YoutubeApiProviderType? youtubeApiProvider,
    bool? autoplayEnabled,
    bool? continuePlaybackInPip,
    String? languageCode,
    VideoFitMode? videoFitMode,
  }) {
    return SettingsState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      showVideo: showVideo ?? this.showVideo,
      playerView: playerView ?? this.playerView,
      themeIndex: themeIndex ?? this.themeIndex,
      performanceMode: performanceMode ?? this.performanceMode,
      lowDataMode: lowDataMode ?? this.lowDataMode,
      userName: userName ?? this.userName,
      userAvatarColorIndex: userAvatarColorIndex ?? this.userAvatarColorIndex,
      userAvatarBase64: userAvatarBase64 ?? this.userAvatarBase64,
      isLoaded: isLoaded ?? this.isLoaded,
      spotifyProvider: spotifyProvider ?? this.spotifyProvider,
      youtubeSearchMethod: youtubeSearchMethod ?? this.youtubeSearchMethod,
      youtubeApiProvider: youtubeApiProvider ?? this.youtubeApiProvider,
      autoplayEnabled: autoplayEnabled ?? this.autoplayEnabled,
      continuePlaybackInPip:
          continuePlaybackInPip ?? this.continuePlaybackInPip,
      languageCode: languageCode ?? this.languageCode,
      videoFitMode: videoFitMode ?? this.videoFitMode,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadSettings();
    return SettingsState(
      selectedCountry: 'US',
      showVideo: true,
      themeIndex: 0,
      performanceMode: PerformanceMode.balanced,
      lowDataMode: false,
      autoplayEnabled: true,
    );
  }

  static const _boxName = 'settings';
  static const _countryKey = 'selected_country';
  static const _showVideoKey = 'show_video';
  static const _playerViewKey = 'player_view';
  static const _themeIndexKey = 'theme_index';
  static const _performanceModeKey = 'performance_mode';
  static const _lowDataModeKey = 'low_data_mode';
  static const _userNameKey = 'user_name';
  static const _userAvatarColorIndexKey = 'user_avatar_color_index';
  static const _userAvatarPathKey = 'user_avatar_path';
  static const _spotifyProviderKey = 'spotify_provider';
  static const _youtubeSearchMethodKey = 'youtube_search_method';
  static const _youtubeApiProviderKey = 'youtube_api_provider';
  static const _autoplayEnabledKey = 'autoplay_enabled';
  static const _continuePlaybackInPipKey = 'continue_playback_in_pip';
  static const _languageCodeKey = 'language_code';
  static const _videoFitModeKey = 'video_fit_mode';

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(_boxName);
    final country = box.get(_countryKey, defaultValue: 'US') as String;
    final showVideo = box.get(_showVideoKey, defaultValue: true) as bool;
    final playerViewIndex = box.get(_playerViewKey, defaultValue: 0) as int;
    final themeIndex = box.get(_themeIndexKey, defaultValue: 0) as int;

    // Auto-detect default performance mode based on platform if not set
    final performanceModeIndex =
        box.get(_performanceModeKey, defaultValue: -1) as int;
    final PerformanceMode defaultMode =
        (defaultTargetPlatform == TargetPlatform.android)
        ? PerformanceMode.balanced
        : PerformanceMode.high;
    final lowDataMode = box.get(_lowDataModeKey, defaultValue: false) as bool;
    final userName = box.get(_userNameKey, defaultValue: '') as String;
    final userAvatarColorIndex =
        box.get(_userAvatarColorIndexKey, defaultValue: 0) as int;
    final userAvatarBase64 = box.get(_userAvatarPathKey) as String?;

    // Provider settings
    final spotifyProviderIndex =
        box.get(
              _spotifyProviderKey,
              defaultValue: SpotifyProviderType.ppplayer.index,
            )
            as int;
    final youtubeSearchMethodIndex =
        box.get(
              _youtubeSearchMethodKey,
              defaultValue: YoutubeSearchMethod.scraping.index,
            )
            as int;
    final youtubeApiProviderIndex =
        box.get(
              _youtubeApiProviderKey,
              defaultValue: YoutubeApiProviderType.ppplayer.index,
            )
            as int;
    final autoplayEnabled =
        box.get(_autoplayEnabledKey, defaultValue: true) as bool;
    final continuePlaybackInPip =
        box.get(_continuePlaybackInPipKey, defaultValue: false) as bool;
    final languageCode = box.get(_languageCodeKey) as String?;
    final videoFitModeIndex =
        box.get(_videoFitModeKey, defaultValue: VideoFitMode.fit.index) as int;

    state = state.copyWith(
      selectedCountry: country,
      showVideo: showVideo,
      playerView: PlayerView
          .values[playerViewIndex.clamp(0, PlayerView.values.length - 1)],
      themeIndex: themeIndex,
      performanceMode: performanceModeIndex == -1
          ? defaultMode
          : PerformanceMode.values[performanceModeIndex.clamp(
              0,
              PerformanceMode.values.length - 1,
            )],
      lowDataMode: lowDataMode,
      userName: userName,
      userAvatarColorIndex: userAvatarColorIndex,
      userAvatarBase64: userAvatarBase64,
      spotifyProvider:
          SpotifyProviderType.values[spotifyProviderIndex.clamp(
            0,
            SpotifyProviderType.values.length - 1,
          )],
      youtubeSearchMethod:
          YoutubeSearchMethod.values[youtubeSearchMethodIndex.clamp(
            0,
            YoutubeSearchMethod.values.length - 1,
          )],
      youtubeApiProvider:
          YoutubeApiProviderType.values[youtubeApiProviderIndex.clamp(
            0,
            YoutubeApiProviderType.values.length - 1,
          )],
      autoplayEnabled: autoplayEnabled,
      continuePlaybackInPip: continuePlaybackInPip,
      languageCode: languageCode,
      videoFitMode: VideoFitMode
          .values[videoFitModeIndex.clamp(0, VideoFitMode.values.length - 1)],
      isLoaded: true,
    );
  }

  Future<void> setPerformanceMode(PerformanceMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_performanceModeKey, mode.index);
    state = state.copyWith(performanceMode: mode);
  }

  Future<void> setLanguageCode(String? code) async {
    final box = await Hive.openBox(_boxName);
    if (code == null) {
      await box.delete(_languageCodeKey);
    } else {
      await box.put(_languageCodeKey, code);
    }
    state = state.copyWith(languageCode: code);
  }

  Future<void> setCountry(String country) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_countryKey, country);
    state = state.copyWith(selectedCountry: country);
  }

  Future<void> setTheme(int index) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_themeIndexKey, index);
    state = state.copyWith(themeIndex: index);
  }

  Future<void> setUserName(String name) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userNameKey, name);
    state = state.copyWith(userName: name);
  }

  Future<void> setUserAvatarColorIndex(int index) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userAvatarColorIndexKey, index);
    state = state.copyWith(userAvatarColorIndex: index);
  }

  Future<void> setUserAvatarBase64(String? base64String) async {
    final box = await Hive.openBox(_boxName);
    if (base64String == null) {
      await box.delete(_userAvatarPathKey);
    } else {
      await box.put(_userAvatarPathKey, base64String);
    }
    state = state.copyWith(userAvatarBase64: base64String);
  }

  Future<void> setSpotifyProvider(SpotifyProviderType provider) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_spotifyProviderKey, provider.index);
    state = state.copyWith(spotifyProvider: provider);
  }

  Future<void> setYoutubeSearchMethod(YoutubeSearchMethod method) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_youtubeSearchMethodKey, method.index);
    state = state.copyWith(youtubeSearchMethod: method);
  }

  Future<void> setYoutubeApiProvider(YoutubeApiProviderType type) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_youtubeApiProviderKey, type.index);
    state = state.copyWith(youtubeApiProvider: type);
  }

  Future<void> toggleAutoplay(bool enabled) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_autoplayEnabledKey, enabled);
    state = state.copyWith(autoplayEnabled: enabled);
  }

  Future<void> toggleContinuePlaybackInPip(bool enabled) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_continuePlaybackInPipKey, enabled);
    state = state.copyWith(continuePlaybackInPip: enabled);
  }

  Future<void> toggleVideo() async {
    final box = await Hive.openBox(_boxName);
    final newValue = !state.showVideo;
    await box.put(_showVideoKey, newValue);
    state = state.copyWith(showVideo: newValue);

    if (newValue) {
      setPlayerView(PlayerView.video);
    } else if (state.playerView == PlayerView.video) {
      setPlayerView(PlayerView.artwork);
    }
  }

  Future<void> toggleLowDataMode() async {
    final box = await Hive.openBox(_boxName);
    final newValue = !state.lowDataMode;
    await box.put(_lowDataModeKey, newValue);
    state = state.copyWith(lowDataMode: newValue);
  }

  Future<void> setPlayerView(PlayerView view) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_playerViewKey, view.index);
    state = state.copyWith(playerView: view);

    if (view == PlayerView.video && !state.showVideo) {
      await box.put(_showVideoKey, true);
      state = state.copyWith(showVideo: true);
    } else if (view == PlayerView.artwork && state.showVideo) {
      await box.put(_showVideoKey, false);
      state = state.copyWith(showVideo: false);
    }
  }

  Future<void> setVideoFitMode(VideoFitMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_videoFitModeKey, mode.index);
    state = state.copyWith(videoFitMode: mode);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

final selectedCountryProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).selectedCountry;
});
