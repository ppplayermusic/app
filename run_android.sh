#!/bin/bash

# Default emulator ID (use `flutter emulators` to list available IDs)
EMULATOR_ID="Medium_Phone_API_36.1"

echo "Checking if an Android emulator is already running..."
# Use adb instead of flutter devices to avoid Broken Pipe Dart errors
if ! adb devices | grep -q "emulator"; then
  echo "No active Android device found. Launching emulator ($EMULATOR_ID)..."
  flutter emulators --launch "$EMULATOR_ID"
  
  echo "Waiting for emulator to become available..."
  until adb devices | grep -q "emulator"; do
      sleep 2
      echo -n "."
  done
  echo -e "\nEmulator is up!"
  
  # Give it a few extra seconds to fully boot the OS
  sleep 5
else
  echo "Android emulator or device is already running."
fi

echo "Detecting running emulator ID..."
# Extract the device ID dynamically
RUNNING_DEVICE=$(flutter devices | grep "emulator" | head -n 1 | awk -F'•' '{print $2}' | xargs)

if [ -z "$RUNNING_DEVICE" ]; then
    echo "Could not detect the running emulator for Flutter."
    exit 1
fi

echo "Building and running the Flutter app on $RUNNING_DEVICE..."
flutter run -d "$RUNNING_DEVICE"
