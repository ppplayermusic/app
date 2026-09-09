#!/bin/bash

# Default emulator ID (use `flutter emulators` to list available IDs)
EMULATOR_ID="Medium_Phone_API_36.1"

echo "Checking if an Android emulator is already running..."
if ! flutter devices | grep -q "android"; then
  echo "No active Android device found. Launching emulator ($EMULATOR_ID)..."
  flutter emulators --launch "$EMULATOR_ID"
  
  echo "Waiting for emulator to become available..."
  until flutter devices | grep -q "android"; do
      sleep 2
      echo -n "."
  done
  echo -e "\nEmulator is up!"
  
  # Give it a few extra seconds to fully boot the OS
  sleep 5
else
  echo "Android emulator or device is already running."
fi

echo "Building and running the Flutter app..."
# We explicitly target the android device just in case an iOS simulator is also open
flutter run -d android
