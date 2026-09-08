#!/bin/bash
set -e
cd "$(dirname "$0")/.."

APP_PATH="build/macos/Build/Products/Release/PPPlayer.app"
# The default entitlements used by Flutter for Release
ENTITLEMENTS="macos/Runner/Release.entitlements"
SIGNING_IDENTITY="$1"

if [ -z "$SIGNING_IDENTITY" ]; then
    echo "Usage: $0 \"Developer ID Application: Your Name (TEAMID)\""
    exit 1
fi

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH. Run build_macos.sh first."
    exit 1
fi

echo "Signing frameworks and dylibs..."
find "$APP_PATH/Contents/Frameworks" -type d -name "*.framework" -exec codesign --force --verify --verbose --sign "$SIGNING_IDENTITY" --options runtime {} \; || true
find "$APP_PATH/Contents/Frameworks" -type f -name "*.dylib" -exec codesign --force --verify --verbose --sign "$SIGNING_IDENTITY" --options runtime {} \; || true

echo "Signing main application bundle..."
# If Release.entitlements does not exist, we just sign without entitlements
if [ -f "$ENTITLEMENTS" ]; then
    codesign --force --verify --verbose --sign "$SIGNING_IDENTITY" --options runtime --entitlements "$ENTITLEMENTS" "$APP_PATH"
else
    echo "Release.entitlements not found, signing without custom entitlements."
    codesign --force --verify --verbose --sign "$SIGNING_IDENTITY" --options runtime "$APP_PATH"
fi

echo "Verifying signature..."
codesign --verify --verbose --strict "$APP_PATH"
echo "Signature OK."
