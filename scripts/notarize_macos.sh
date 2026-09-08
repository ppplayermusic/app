#!/bin/bash
set -e
cd "$(dirname "$0")/.."

DMG_PATH="$1"
APPLE_ID="$2"
TEAM_ID="$3"
APP_SPECIFIC_PASSWORD="$4"

if [ -z "$APP_SPECIFIC_PASSWORD" ]; then
    echo "Usage: $0 <path-to-dmg> <apple-id> <team-id> <app-specific-password>"
    echo "Alternatively, you can use a keychain profile."
    exit 1
fi

if [ ! -f "$DMG_PATH" ]; then
    echo "Error: DMG not found at $DMG_PATH"
    exit 1
fi

echo "Submitting DMG for notarization..."
xcrun notarytool submit "$DMG_PATH" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "$APP_SPECIFIC_PASSWORD" \
  --wait

echo "Stapling notarization ticket to DMG..."
xcrun stapler staple "$DMG_PATH"

echo "Verifying notarization..."
spctl -a -vvvv -t install "$DMG_PATH"

echo "Notarization complete."
