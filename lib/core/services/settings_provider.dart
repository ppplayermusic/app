import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

enum PlayerView { video, artwork, queue }
enum PerformanceMode { high, balanced, powerSaver }

class SettingsState {
  final String selectedCountry;
  final bool showVideo;
  final PlayerView playerView;
  final int themeIndex;
  final PerformanceMode performanceMode;
  final bool lowDataMode;

  SettingsState({
    required this.selectedCountry,
    this.showVideo = true,
    this.playerView = PlayerView.video,
    this.themeIndex = 0,
    this.performanceMode = PerformanceMode.balanced,
    this.lowDataMode = false,
  });

  SettingsState copyWith({
    String? selectedCountry,
    bool? showVideo,
    PlayerView? playerView,
    int? themeIndex,
    PerformanceMode? performanceMode,
    bool? lowDataMode,
  }) {
    return SettingsState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      showVideo: showVideo ?? this.showVideo,
      playerView: playerView ?? this.playerView,
      themeIndex: themeIndex ?? this.themeIndex,
      performanceMode: performanceMode ?? this.performanceMode,
      lowDataMode: lowDataMode ?? this.lowDataMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(
    selectedCountry: 'US', 
    showVideo: true, 
    themeIndex: 0,
    performanceMode: PerformanceMode.balanced,
    lowDataMode: false,
  )) {
    _loadSettings();
  }

  static const _boxName = 'settings';
  static const _countryKey = 'selected_country';
  static const _showVideoKey = 'show_video';
  static const _playerViewKey = 'player_view';
  static const _themeIndexKey = 'theme_index';
  static const _performanceModeKey = 'performance_mode';
  static const _lowDataModeKey = 'low_data_mode';

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(_boxName);
    final country = box.get(_countryKey, defaultValue: 'US') as String;
    final showVideo = box.get(_showVideoKey, defaultValue: true) as bool;
    final playerViewIndex = box.get(_playerViewKey, defaultValue: 0) as int;
    final themeIndex = box.get(_themeIndexKey, defaultValue: 0) as int;
    
    // Auto-detect default performance mode based on platform if not set
    final performanceModeIndex = box.get(_performanceModeKey, defaultValue: -1) as int;
    final PerformanceMode defaultMode = (defaultTargetPlatform == TargetPlatform.android)
        ? PerformanceMode.balanced
        : PerformanceMode.high;
    final lowDataMode = box.get(_lowDataModeKey, defaultValue: false) as bool;

    state = state.copyWith(
      selectedCountry: country,
      showVideo: showVideo,
      playerView: PlayerView.values[playerViewIndex.clamp(0, PlayerView.values.length - 1)],
      themeIndex: themeIndex,
      performanceMode: performanceModeIndex == -1 
          ? defaultMode 
          : PerformanceMode.values[performanceModeIndex.clamp(0, PerformanceMode.values.length - 1)],
      lowDataMode: lowDataMode,
    );
  }

  Future<void> setPerformanceMode(PerformanceMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_performanceModeKey, mode.index);
    state = state.copyWith(performanceMode: mode);
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
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

final selectedCountryProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).selectedCountry;
});
