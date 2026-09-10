#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."
result=verification/playback-20260910
files=(
  lib/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart
  lib/core/playback/packages/pp_playback_engine/test/fake_youtube_controller.dart
  lib/core/playback/packages/pp_playback_engine/test/media_kit_playback_engine_test.dart
  lib/core/playback/packages/pp_playback_engine/test/engine_error_test.dart
  lib/core/player/player_provider.dart
  lib/core/playback/media_handler.dart
  test/core/player/autoplay_test.dart
  test/core/player/player_notifier_retry_test.dart
  test/core/playback/media_sync_pause_test.dart
)
/Users/veneno/flutter/bin/cache/dart-sdk/bin/dart format "${files[@]}" > "$result/format.log" 2>&1
flutter test --reporter expanded test/core/player/autoplay_test.dart test/core/player/player_notifier_retry_test.dart test/core/playback/media_sync_pause_test.dart lib/core/playback/packages/pp_playback_engine/test/engine_error_test.dart lib/core/playback/packages/pp_playback_engine/test/media_kit_playback_engine_test.dart > "$result/tests-final.log" 2>&1
flutter analyze "${files[@]}" > "$result/analysis.log" 2>&1
flutter build apk --debug --build-name=1.0.0-playback-baseline-20260910 --build-number=2026091003 --dart-define=BG_PLAYBACK_EXPERIMENT=false > "$result/build-baseline-final.log" 2>&1
cp build/app/outputs/flutter-apk/app-debug.apk "$result/ppplayer-baseline-2026091003.apk"
flutter build apk --debug --build-name=1.0.0-playback-experiment-20260910 --build-number=2026091004 --dart-define=BG_PLAYBACK_EXPERIMENT=true > "$result/build-experiment-final.log" 2>&1
cp build/app/outputs/flutter-apk/app-debug.apk "$result/ppplayer-experiment-2026091004.apk"
shasum -a 256 "$result"/*.apk > "$result/SHA256SUMS"
