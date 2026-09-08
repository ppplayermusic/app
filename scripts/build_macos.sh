#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "Building macOS release..."
flutter build macos --release
echo "Build complete."
