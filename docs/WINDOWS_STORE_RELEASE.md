# Windows Store Release Guide

This guide details the requirements and steps to generate a Microsoft Store compatible `.msix` package for PPPLAYER.

## Requirements

1. **Microsoft Partner Center Account:** You need an active developer account on the [Microsoft Partner Center](https://partner.microsoft.com/dashboard).
2. **App Identity:** An app reserved in the Partner Center.
3. **pubspec.yaml Configuration:** The `msix_config` block must exactly match your Partner Center identity.

## `pubspec.yaml` MSIX Configuration

The `pubspec.yaml` has an `msix_config` block that defines your Microsoft Store identity.

```yaml
msix_config:
  display_name: PPPlayer
  publisher_display_name: YOUR_PUBLISHER_NAME
  identity_name: YOUR_IDENTITY_NAME
  publisher: YOUR_PUBLISHER_ID
  msix_version: 1.3.1.0
  logo_path: assets/logo.png
  architecture: x64
  capabilities: internetClient, musicLibrary
```

> [!IMPORTANT]
> If you ever update the `version` of your app at the top of `pubspec.yaml`, you **MUST** also update the `msix_version` field to match (and ensure it follows the format `MAJOR.MINOR.PATCH.0`).

## Automated Build Process

We have included a PowerShell script to automate the entire build and packaging process. 

1. Open PowerShell in your terminal.
2. Run the script:
   ```powershell
   .\scripts\build_windows_msix.ps1
   ```

### What this script does:
- Runs `flutter clean` to ensure a fresh build.
- Runs `flutter pub get` to fetch dependencies.
- Runs `dart run msix:create --store`. This compiles the `Release` windows executable and packages it into an MSIX file. The `--store` flag is crucial as it tells the packager *not* to sign the package with a local certificate (the Microsoft Store will sign it automatically upon upload).

## Uploading to Microsoft Store

1. Once the script finishes, locate your package at:
   `build\windows\x64\runner\Release\ppplayer.msix`
2. Go to the **Microsoft Partner Center** -> **Windows & Xbox** -> **PPPLAYER** -> **Submissions**.
3. Create a new submission.
4. Drag and drop the `ppplayer.msix` file into the "Packages" section.
5. Fill out your store listing details, age ratings, and pricing.
6. Submit for certification!
