adb shell am force-stop com.ppplayer.app
adb logcat -c
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 10
# Tap play on mini player
adb shell input tap 886 2453
Start-Sleep -Seconds 5
# Tap mini player to open full screen
adb shell input tap 500 2450
Start-Sleep -Seconds 5
# Trigger PiP
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 8
# Take screenshot of PiP
adb exec-out screencap -p > c:\Users\User\Projects\ppplayermusic\app\pip_screenshot.png
# Restore to fullscreen
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 10
adb logcat -d > c:\Users\User\Projects\ppplayermusic\app\test_run_2.txt
