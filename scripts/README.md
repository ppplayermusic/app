# macOS Release Scripts

This directory contains the pipeline for building, signing, and notarizing the macOS release of PPPlayer.

## Prerequisites

- **create-dmg**: Required for building the `.dmg` file.
  ```bash
  brew install create-dmg
  ```
- **Apple Developer Account**: You need an active Apple Developer Program membership.
- **Developer ID Application Certificate**: Installed in your local Keychain.

## Configuration

Before running a release, ensure you have copied the example environment file and filled it in:

```bash
cp ../.env.macos_release.example ../.env.macos_release
```

Fill in your `APPLE_ID`, `TEAM_ID`, `DEVELOPER_ID_APPLICATION`, and `APP_SPECIFIC_PASSWORD`.

## Running a Release

To run the full end-to-end release pipeline, simply execute:

```bash
./release_macos.sh <version>
# Example: ./release_macos.sh 1.0.0
```

This will output the final `.dmg` in the `../dist/` folder, ready for distribution on your website.

---

## What each script does

If you need to run steps individually for debugging, here is what each script is responsible for:

### 1. `build_macos.sh`
Compiles the Flutter application into a release build located at `build/macos/Build/Products/Release/PPPlayer.app`.

### 2. `sign_macos.sh`
Takes a certificate name as an argument and performs deep code-signing on the `.app` bundle. It iterates through all `.framework` and `.dylib` files inside the app bundle, signing them with the `--options runtime` flag (required for notarization), and finally signs the main executable with the appropriate entitlements.
```bash
./sign_macos.sh "Developer ID Application: Your Name (XXXXXXXXXX)"
```

### 3. `create_dmg.sh`
Takes the version number as an argument and packages the signed `.app` into a `.dmg` file using `create-dmg`, handling the layout and icon positioning.
```bash
./create_dmg.sh 1.0.0
```
*(Note: `release_macos.sh` also signs the resulting DMG after this step!)*

### 4. `notarize_macos.sh`
Submits the signed `.dmg` to Apple's notarization service (`xcrun notarytool`). It blocks until Apple approves or rejects the build. Upon approval, it uses `xcrun stapler` to staple the offline ticket to the `.dmg`.
```bash
./notarize_macos.sh <path-to-dmg> <apple-id> <team-id> <app-specific-password>
```

### 5. `release_macos.sh`
The master script that orchestrates steps 1 through 4. It reads the `.env.macos_release` file, ensures all variables are present, and passes them to the individual scripts.
