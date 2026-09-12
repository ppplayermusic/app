import os
import re
import json

app_dir = '/Users/veneno/Projects/Apps/ppplayer/app/lib/shared'
strings = set()

# Regex to find single quoted strings inside Text(), hintText:, title:, text:, tooltip:, label:
pattern = re.compile(r"(?:Text\(|hintText:\s*|title:\s*|text:\s*|tooltip:\s*|label:\s*)'([^']+)'")

for root, _, files in os.walk(app_dir):
    for f in files:
        if f.endswith('.dart'):
            with open(os.path.join(root, f), 'r') as file:
                content = file.read()
                matches = pattern.findall(content)
                for m in matches:
                    strings.add(m)

# Some special strings that might have been missed
strings.update([
    'Play', 'Play next', 'Add to queue', 'Remove from queue', 'Add to playlist', 'Go to artist',
    'Go to album', 'Go to song radio', 'Share', 'Go to playlist', 'Go to artist radio', 'Play Station',
    'New playlist', 'Home', 'Discover', 'Search', 'Favorites', 'Recently Played', 'Playlists', 'My Playlist'
])

def to_camel_case(text):
    text = re.sub(r'\$[{a-zA-Z0-9_}]+', '', text)
    text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    words = text.strip().split()
    if not words: return "emptyStr"
    first = words[0].lower()
    rest = [w.capitalize() for w in words[1:]]
    return first + "".join(rest)

arb_path = '/Users/veneno/Projects/Apps/ppplayer/app/lib/l10n/app_en.arb'
with open(arb_path, 'r') as f:
    arb = json.load(f)

for s in sorted(strings):
    if s == ', ': continue # Skip comma
    
    # Check if already present as value in arb
    if s in arb.values():
        continue

    key = to_camel_case(s)
    if not key or key == 'emptyStr': continue
    original_key = key
    counter = 1
    while key in arb and arb[key] != s:
        key = f"{original_key}{counter}"
        counter += 1
    
    arb[key] = s

with open(arb_path, 'w') as f:
    json.dump(arb, f, indent=2)

print(f"Updated app_en.arb")
