adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am force-stop com.ppplayer.app
adb logcat -c
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 5
# Tap play on mini player (assumes app starts and loads previous track in miniplayer)
adb shell input tap 886 2453
Start-Sleep -Seconds 5
# Tap center of mini player to open full player screen
adb shell input tap 500 2450
Start-Sleep -Seconds 5
# Trigger PiP
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 8
adb logcat -d > c:\Users\User\Projects\ppplayermusic\app\test_run_1.txt
