# PPPlayer Android Setup Guide

This guide will help you run the PPPlayer application on an Android emulator using Flutter and ADB.

## Prerequisites

1.  **Flutter SDK** installed and added to your PATH.
2.  **Android Studio** installed (to provide the Android SDK and emulators).
3.  **ADB (Android Debug Bridge)** available in your PATH.

## Running the App

We have provided a convenient bash script to automatically launch an Android emulator and start the app:

```bash
./run_android.sh
```

### What the script does:
1. Checks if an Android emulator or device is already running.
2. If not, it launches the default emulator (currently configured to `Medium_Phone_API_36.1`).
3. Waits for the emulator to fully boot.
4. Executes `flutter run -d android` to compile and install the app on the running emulator.

## Manual Launch (ADB & Flutter CLI)

If you prefer to run things manually or need more control over the process, you can use the standard Flutter and ADB commands.

### 1. List Available Emulators
Find out which emulators you have configured on your machine:
```bash
flutter emulators
```

### 2. Launch an Emulator
Launch an emulator from the list by its ID:
```bash
flutter emulators --launch <emulator_id>
```
*Example: `flutter emulators --launch Medium_Phone_API_36.1`*

### 3. Run the App
Once the emulator is running (you can verify with `flutter devices`), run the app:
```bash
flutter run
```
If you have multiple devices connected (e.g., an iOS simulator and an Android emulator), specify the Android device:
```bash
flutter run -d android
```

## Troubleshooting

### "Activity class does not exist" Error
If you ever manually install the APK and try to run it via `adb shell am start`, you must use the fully qualified class name for the MainActivity since we explicitly defined it in the `AndroidManifest.xml` to prevent intent resolution errors:

```bash
# Correct way to manually start the app via ADB
adb -s emulator-5554 shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
```

### Stuck on "Installing build/app/outputs/flutter-apk/app-debug.apk..."
Sometimes Flutter gets stuck waiting for the emulator to respond. If this happens:
1. Press `Ctrl + C` to stop the current `flutter run` process.
2. Force stop the app on the emulator:
   ```bash
   adb shell am force-stop com.ppplayer.app
   ```
3. Run `flutter run` again.

### Clearing App Data
If the app gets into a bad state or a database migration fails, you can clear the app's data:
```bash
adb shell pm clear com.ppplayer.app
```
