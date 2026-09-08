#!/bin/bash
set -e
cd "$(dirname "$0")/.."

VERSION="$1"
APP_NAME="PPPlayer"
APP_PATH="build/macos/Build/Products/Release/${APP_NAME}.app"
DMG_DIR="dist"
DMG_NAME="${APP_NAME}-${VERSION}-macOS.dmg"
DMG_PATH="${DMG_DIR}/${DMG_NAME}"

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH."
    exit 1
fi

mkdir -p "$DMG_DIR"
rm -f "$DMG_PATH"

echo "Creating DMG..."
if ! command -v create-dmg &> /dev/null; then
    echo "Error: create-dmg not found. Please install it with: brew install create-dmg"
    exit 1
fi

# create-dmg creates the DMG containing the app
create-dmg \
  --volname "${APP_NAME} Installer" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "${APP_NAME}.app" 150 190 \
  --hide-extension "${APP_NAME}.app" \
  --app-drop-link 450 190 \
  "$DMG_PATH" \
  "$APP_PATH"

echo "DMG created at $DMG_PATH"
