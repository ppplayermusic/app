#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "Building macOS release..."
flutter build macos --release --dart-define=PPPLAYER_API_BASE_URL=https://ppplayer.com
echo "Build complete."
