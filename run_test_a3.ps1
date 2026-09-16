adb logcat -c
adb shell am start -n com.ppplayer.app/com.ppplayer.app.MainActivity
Start-Sleep -Seconds 5
# Tap mini player title to open PlayerScreen
adb shell input tap 300 2480
Start-Sleep -Seconds 3
# Tap Play button if needed (maybe in the center of PlayerScreen?)
# Let's see if it auto-plays or if the play button in PlayerScreen is needed.
# Usually opening it is enough. Let's tap Play in PlayerScreen. (Center of screen)
adb shell input tap 600 2000
Start-Sleep -Seconds 10
# Trigger PiP
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 8
adb logcat -d > c:\Users\User\Projects\ppplayermusic\app\test_a_logs_3.txt
