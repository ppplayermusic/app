adb logcat -c
adb shell am force-stop com.ppplayer.app
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 10
# Tap around to play something
adb shell input tap 500 1000
Start-Sleep -Seconds 2
adb shell input tap 500 1200
Start-Sleep -Seconds 15
# Trigger PiP
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 8
adb logcat -d > c:\Users\User\Projects\ppplayermusic\app\test_a_logs.txt
