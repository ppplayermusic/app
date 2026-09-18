import 'package:flutter/foundation.dart';

/// Controls the background-playback feasibility experiment.
///
/// **Release exclusion:**
/// [enabled] is the conjunction of two independent gates:
///   1. The compile-time `--dart-define=BG_PLAYBACK_EXPERIMENT=true` flag.
///   2. The runtime `kDebugMode` check (false in profile/release regardless
///      of any dart-define supplied at build time).
///
/// A release build supplied with `--dart-define=BG_PLAYBACK_EXPERIMENT=true`
/// will still evaluate [enabled] as `false` because `kDebugMode` is `false`.
///
/// Usage:
///   Baseline:    flutter run --debug                                        (enabled = false)
///   Experiment:  flutter run --debug --dart-define=BG_PLAYBACK_EXPERIMENT=true  (enabled = true)
///   Release:     flutter build apk                                          (enabled = false, always)
class BackgroundPlaybackExperiment {
  const BackgroundPlaybackExperiment._();

  static const bool _compileFlagSet = bool.fromEnvironment(
    'BG_PLAYBACK_EXPERIMENT',
    defaultValue: false,
  );

  /// True only when BOTH the compile-time flag is set AND we are in debug mode.
  static bool get enabled => _compileFlagSet && kDebugMode;

  static bool get supportsSpeed => false;

  /// Embedded in every diagnostic line for post-hoc logcat filtering.
  static String get tag => enabled ? '[BG-EXP]' : '[BASELINE]';
}
