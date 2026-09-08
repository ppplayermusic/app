#!/bin/bash
set -e
cd "$(dirname "$0")/.."

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

# Configuration - read from .env.macos_release if it exists
if [ -f .env.macos_release ]; then
    source .env.macos_release
fi

if [ -z "$DEVELOPER_ID_APPLICATION" ] || [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APP_SPECIFIC_PASSWORD" ]; then
    echo "Error: Missing required configuration."
    echo "Please set the following environment variables (e.g. in .env.macos_release):"
    echo " - DEVELOPER_ID_APPLICATION (e.g. 'Developer ID Application: Your Name (XXXXXXXXXX)')"
    echo " - APPLE_ID (e.g. your@email.com)"
    echo " - TEAM_ID (e.g. XXXXXXXXXX)"
    echo " - APP_SPECIFIC_PASSWORD (e.g. xxxx-xxxx-xxxx-xxxx)"
    exit 1
fi

echo "Starting macOS release process for version $VERSION..."

echo "--------------------------------------------------------"
echo "Step 1: Build macOS app"
echo "--------------------------------------------------------"
./scripts/build_macos.sh

echo "--------------------------------------------------------"
echo "Step 2: Sign the .app bundle"
echo "--------------------------------------------------------"
./scripts/sign_macos.sh "$DEVELOPER_ID_APPLICATION"

echo "--------------------------------------------------------"
echo "Step 3: Create DMG"
echo "--------------------------------------------------------"
./scripts/create_dmg.sh "$VERSION"

DMG_PATH="dist/PPPlayer-${VERSION}-macOS.dmg"

echo "--------------------------------------------------------"
echo "Step 4: Sign the DMG"
echo "--------------------------------------------------------"
codesign --force --sign "$DEVELOPER_ID_APPLICATION" "$DMG_PATH"
codesign --verify --verbose "$DMG_PATH"

echo "--------------------------------------------------------"
echo "Step 5: Notarize the DMG"
echo "--------------------------------------------------------"
./scripts/notarize_macos.sh "$DMG_PATH" "$APPLE_ID" "$TEAM_ID" "$APP_SPECIFIC_PASSWORD"

echo "--------------------------------------------------------"
echo "Step 6: Deploy to Website"
echo "--------------------------------------------------------"
WEBSITE_DOWNLOADS_DIR="../website/public/downloads"
mkdir -p "$WEBSITE_DOWNLOADS_DIR"
cp "$DMG_PATH" "$WEBSITE_DOWNLOADS_DIR/"
echo "Copied $DMG_PATH to $WEBSITE_DOWNLOADS_DIR/"

echo ""
echo "🎉 Release ready! The signed and notarized DMG is at: $DMG_PATH"
echo "🌐 It has also been copied to the website for direct download."
