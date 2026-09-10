"""ADB evidence capture. Does not infer sound from media-session position."""
import json
from pathlib import Path
import subprocess
import time

out = Path(__file__).resolve().parent

def adb(*args):
    return subprocess.check_output(['adb', '-s', 'emulator-5554', *args], text=True)

def sample(label):
    start = time.time()
    value = adb('shell', 'dumpsys', 'media_session')
    with (out / 'native-session-samples.jsonl').open('a') as f:
        f.write(json.dumps({'label': label, 'host_start': start, 'host_end': time.time(), 'dump': value}) + '\n')

# An explicit pause is measurable even if YouTube is refusing this video; this
# must be reported separately from a playing-to-paused latency measurement.
sample('before-pause')
adb('shell', 'input', 'keyevent', 'KEYCODE_MEDIA_PAUSE')
for i in range(15):
    sample('pause-%d' % i)
    time.sleep(.1)
adb('shell', 'input', 'keyevent', 'KEYCODE_SLEEP')
# Poll lifecycle state, rather than assuming an arbitrary delay means stopped.
for i in range(50):
    activity = adb('shell', 'dumpsys', 'activity', 'activities')
    if 'mResumedActivity: ActivityRecord' not in activity or 'com.ppplayer.app/.MainActivity' not in activity.split('mResumedActivity:')[-1].split('\n')[0]:
        break
    time.sleep(.1)
(out / 'activity-locked.txt').write_text(activity)
adb('shell', 'input', 'keyevent', 'KEYCODE_MEDIA_PLAY')
start = time.monotonic()
while time.monotonic() - start < 61:
    sample('locked-play')
    time.sleep(1)
sample('locked-play-end')
adb('shell', 'input', 'keyevent', 'KEYCODE_WAKEUP')
adb('shell', 'wm', 'dismiss-keyguard')
adb('shell', 'am', 'start', '-n', 'com.ppplayer.app/.MainActivity')
adb('shell', 'input', 'keyevent', 'KEYCODE_MEDIA_PLAY')
for i in range(10):
    sample('foreground-resume-%d' % i)
    time.sleep(.5)
print('Probe complete; locked observation >=61 seconds. Audio was not measured.')
