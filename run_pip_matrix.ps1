$ErrorActionPreference = "Continue"

Write-Host "Clearing logcat..."
adb logcat -c

Write-Host "Starting logcat background capture..."
$job = Start-Job {
    adb logcat -v threadtime | Select-String "PipDebug|HybridPlaybackEngine|PipHandler|VideoInit" | Out-File -FilePath .\pip_final_verification.txt -Encoding utf8
}

Write-Host "Starting app..."
adb shell am start -n com.ppplayer.app/.MainActivity
Write-Host "Waiting 12 seconds for app to load and autoplay video..."
Start-Sleep -Seconds 12

Write-Host "Simulating tap to bypass WebView autoplay restrictions..."
adb shell input tap 500 500
Start-Sleep -Seconds 2
adb shell input tap 500 1000
Start-Sleep -Seconds 2
adb shell input keyevent KEYCODE_MEDIA_PLAY
Start-Sleep -Seconds 10

Write-Host "Test 1: Home -> PiP"
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 5

Write-Host "Test 2: PiP -> reopen"
adb shell am start -n com.ppplayer.app/.MainActivity
Start-Sleep -Seconds 5

Write-Host "Test 3: PiP -> dismiss"
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_WINDOW
Start-Sleep -Seconds 1
adb shell input keyevent KEYCODE_DEL
Start-Sleep -Seconds 5

Write-Host "Test 4: PiP -> lock"
adb shell am start -n com.ppplayer.app/.MainActivity
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_POWER
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_POWER
adb shell input keyevent KEYCODE_WAKEUP
Start-Sleep -Seconds 2

Write-Host "Test 5 & 6: PiP -> next / pause / resume"
adb shell am start -n com.ppplayer.app/.MainActivity
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_HOME
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_MEDIA_NEXT
Start-Sleep -Seconds 5
adb shell input keyevent KEYCODE_MEDIA_PAUSE
Start-Sleep -Seconds 3
adb shell input keyevent KEYCODE_MEDIA_PLAY
Start-Sleep -Seconds 5

Write-Host "Stopping logcat capture..."
Stop-Job $job
Remove-Job $job
Write-Host "Matrix complete."
