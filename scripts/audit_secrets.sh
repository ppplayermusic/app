#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "--------------------------------------------------------"
echo "Production-Readiness Security Audit: Secret Extraction"
echo "--------------------------------------------------------"

# 1. Source the environment variables safely
WEBSITE_ENV="../website/.env.local"
if [ ! -f "$WEBSITE_ENV" ]; then
    echo "Error: Next.js proxy environment file not found at $WEBSITE_ENV"
    exit 1
fi

# Extract the values safely without exporting them to subshells unnecessarily
# We'll use grep and cut to pull the exact values.
SPOTIFY_SECRET=$(grep '^SPOTIFY_CLIENT_SECRET=' "$WEBSITE_ENV" | cut -d '=' -f 2- | tr -d '\r')
YOUTUBE_KEY=$(grep '^YOUTUBE_API_KEY=' "$WEBSITE_ENV" | cut -d '=' -f 2- | tr -d '\r')

if [ -z "$SPOTIFY_SECRET" ] || [ -z "$YOUTUBE_KEY" ]; then
    echo "Error: Failed to read secrets from proxy environment."
    exit 1
fi

# 2. Check source/build-config
echo "Checking Flutter build configuration and source files..."
# Ignore the website directory where secrets are supposed to be, scripts/, build/, and .dart_tool/
if grep -r -I "SPOTIFY_CLIENT_SECRET=" . --exclude-dir={scripts,build,.dart_tool,.git} ; then
    echo "FAIL: Found SPOTIFY_CLIENT_SECRET assignment in Flutter source!"
    exit 1
fi
if grep -r -I "YOUTUBE_API_KEY=" . --exclude-dir={scripts,build,.dart_tool,.git} ; then
    echo "FAIL: Found YOUTUBE_API_KEY assignment in Flutter source!"
    exit 1
fi
echo "PASS: No source assignments found."

# 3. Check binary
APP_BUNDLE="build/macos/Build/Products/Release/PPPlayer.app"
if [ ! -d "$APP_BUNDLE" ]; then
    echo "Error: Release bundle not found at $APP_BUNDLE. Did you run flutter build macos --release?"
    exit 1
fi

echo "Forensic extraction test on $APP_BUNDLE..."

# Prepare substrings to search for (to avoid logging full secrets on matches)
# Just 12 chars is enough to prove leakage
S_FINGERPRINT="${SPOTIFY_SECRET:0:12}"
Y_FINGERPRINT="${YOUTUBE_KEY:0:12}"
AIZA_PREFIX="AIzaSy"

# Search for the exact secrets
FOUND_LEAK=0

# Use strings to dump all printable characters from all files in the app bundle
# Redirect stderr to dev null to ignore "Is a directory" errors
strings -a $(find "$APP_BUNDLE" -type f) 2>/dev/null > /tmp/ppplayer_strings.txt

if grep -q "$SPOTIFY_SECRET" /tmp/ppplayer_strings.txt; then
    echo "FAIL: Spotify Client Secret was found in the application bundle!"
    FOUND_LEAK=1
elif grep -q "$S_FINGERPRINT" /tmp/ppplayer_strings.txt; then
    echo "FAIL: Spotify Client Secret fingerprint ($S_FINGERPRINT...) was found in the application bundle!"
    FOUND_LEAK=1
else
    echo "PASS: Spotify Client Secret is not present in the application bundle."
fi

if grep -q "$YOUTUBE_KEY" /tmp/ppplayer_strings.txt; then
    echo "FAIL: YouTube API Key was found in the application bundle!"
    FOUND_LEAK=1
elif grep -q "$Y_FINGERPRINT" /tmp/ppplayer_strings.txt; then
    echo "FAIL: YouTube API Key fingerprint ($Y_FINGERPRINT...) was found in the application bundle!"
    FOUND_LEAK=1
elif grep -q "$AIZA_PREFIX" /tmp/ppplayer_strings.txt; then
    echo "FAIL: Found an AIza... Google API key pattern in the application bundle!"
    # Print the line but obscure the end to avoid leaking if it's somehow different
    grep "$AIZA_PREFIX" /tmp/ppplayer_strings.txt | head -n 1 | cut -c 1-20 | sed 's/$/.../g'
    FOUND_LEAK=1
else
    echo "PASS: YouTube API Key is not present in the application bundle."
fi

# Clean up
rm -f /tmp/ppplayer_strings.txt

if [ $FOUND_LEAK -eq 1 ]; then
    echo "--------------------------------------------------------"
    echo "AUDIT FAILED: Secrets were recovered from the release bundle."
    exit 1
else
    echo "--------------------------------------------------------"
    echo "AUDIT PASSED: No backend credentials were leaked into the release bundle."
    exit 0
fi
