import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

enum PlayerView { video, artwork, queue }

class SettingsState {
  final String selectedCountry;
  final bool showVideo;
  final PlayerView playerView;
  final int themeIndex;

  SettingsState({
    required this.selectedCountry,
    this.showVideo = true,
    this.playerView = PlayerView.video,
    this.themeIndex = 0,
  });

  SettingsState copyWith({
    String? selectedCountry,
    bool? showVideo,
    PlayerView? playerView,
    int? themeIndex,
  }) {
    return SettingsState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      showVideo: showVideo ?? this.showVideo,
      playerView: playerView ?? this.playerView,
      themeIndex: themeIndex ?? this.themeIndex,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(selectedCountry: 'US', showVideo: true, themeIndex: 0)) {
    _loadSettings();
  }

  static const _boxName = 'settings';
  static const _countryKey = 'selected_country';
  static const _showVideoKey = 'show_video';
  static const _playerViewKey = 'player_view';
  static const _themeIndexKey = 'theme_index';

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(_boxName);
    final country = box.get(_countryKey, defaultValue: 'US') as String;
    final showVideo = box.get(_showVideoKey, defaultValue: true) as bool;
    final playerViewIndex = box.get(_playerViewKey, defaultValue: 0) as int;
    final themeIndex = box.get(_themeIndexKey, defaultValue: 0) as int;
    
    state = state.copyWith(
      selectedCountry: country,
      showVideo: showVideo,
      playerView: PlayerView.values[playerViewIndex],
      themeIndex: themeIndex,
    );
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
