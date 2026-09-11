# macOS Release Setup Guide

This guide explains how to properly configure the Apple Developer certificates and GitHub Secrets required to build, sign, and notarize the macOS version of the PPPlayer app via GitHub Actions.

## 1. Finding the Correct Certificate in Keychain Access

To sign a macOS app for distribution *outside* the Mac App Store, you must use a **Developer ID Application** certificate. 

1. Open **Keychain Access** on your Mac.
2. In the left sidebar, ensure you have the **login** keychain selected.
3. At the top of the window, click the **My Certificates** tab. *(This is crucial! It filters out certificates that don't have your private key).*
4. In the search bar at the top right, type: `Developer ID Application`
5. Look for the certificate named: `Developer ID Application: Your Name (TEAM_ID)`
6. Ensure it has a small blue arrow `>` next to it, which indicates the private key is attached.

> [!WARNING]
> Do NOT export certificates named `3rd Party Mac Developer Installer`, `Apple Development`, or `Apple Distribution`. Only the `Developer ID Application` certificate will work for this workflow.

## 2. Exporting the Certificate

1. Right-click the `Developer ID Application` certificate.
2. Select **Export "Developer ID Application: ..."**.
3. Save the file to your Desktop as `Certificates.p12`.
4. When prompted, set the password to something secure (e.g., `your_secure_password`). You will need this password for the GitHub Secrets.
5. Enter your Mac login password to allow the export.

## 3. Encoding the Certificate for GitHub Secrets

GitHub Actions cannot read binary `.p12` files directly. We must convert the file into a Base64 text string.

1. Open your Terminal.
2. Run the following command to encode the file and copy the result directly to your clipboard:
   ```bash
   base64 -i ~/Desktop/Certificates.p12 | pbcopy
   ```

## 4. Configuring GitHub Secrets

Go to your repository on GitHub -> **Settings** -> **Secrets and variables** -> **Actions** and configure the following secrets:

- **`MACOS_CERTIFICATE_B64`**: Paste the massive Base64 string you just copied (Cmd + V).
- **`MACOS_CERTIFICATE_PWD`**: The password you set when exporting the `.p12` file (e.g., `your_secure_password`).
- **`APPLE_ID`**: Your Apple ID email address (e.g., `contact@yourdomain.com`).
- **`TEAM_ID`**: Your 10-character Apple Team ID (e.g., `ABCDE12345`).
- **`APP_SPECIFIC_PASSWORD`**: An App-Specific Password generated from [appleid.apple.com](https://appleid.apple.com/) (used for the notarization process).

## 5. Local `.env.macos_release` File (Optional Backup)

For your own reference, keep these values stored locally in `.env.macos_release`. This file is ignored by Git, so your secrets will not be accidentally pushed to the repository.

```env
DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAM_ID)"
APPLE_ID="contact@yourdomain.com"
TEAM_ID="ABCDE12345"
APP_SPECIFIC_PASSWORD="your-app-specific-password"
MACOS_CERTIFICATE_PWD="your_secure_password"
MACOS_CERTIFICATE_B64="MIINUAIBAzCC..."
```

## Troubleshooting

- **"No signing certificate Developer ID Application found... with a private key"**: This happens if you accidentally exported the wrong certificate (like the Installer one), or if you didn't include the private key (e.g., exporting a `.cer` instead of a `.p12`).
- **"Runner has conflicting provisioning settings"**: Our CI workflow handles this automatically by running `sed` commands to switch Xcode to Manual signing style during the build.
