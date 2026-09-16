adb logcat -c
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 5
# Tap Play button
adb shell input tap 886 2453
Start-Sleep -Seconds 10
# Trigger PiP
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 8
adb logcat -d > c:\Users\User\Projects\ppplayermusic\app\test_a_logs_2.txt
