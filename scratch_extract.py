import os
import re
import json

app_dir = '/Users/veneno/Projects/Apps/ppplayer/app/lib/features'
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

# Some special strings missed by the simple regex
strings.update([
    'Library',
    'Your Library',
    'Liked Songs',
    'Cancel',
    'Create',
    'Search',
    'Recent searches',
    'Browse all',
    'Artist'
])

def to_camel_case(text):
    # Remove variables like $e or ${var}
    text = re.sub(r'\$[{a-zA-Z0-9_}]+', '', text)
    # Remove special chars
    text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    words = text.strip().split()
    if not words: return "emptyStr"
    first = words[0].lower()
    rest = [w.capitalize() for w in words[1:]]
    return first + "".join(rest)

arb = {
  "@@locale": "en",
  "appTitle": "PPPlayer"
}

for s in sorted(strings):
    key = to_camel_case(s)
    if not key or key == 'emptyStr': continue
    # Append suffix if collision
    original_key = key
    counter = 1
    while key in arb and arb[key] != s:
        key = f"{original_key}{counter}"
        counter += 1
    
    arb[key] = s

with open('/Users/veneno/Projects/Apps/ppplayer/app/lib/l10n/app_en.arb', 'w') as f:
    json.dump(arb, f, indent=2)

print(f"Extracted {len(arb)} strings to app_en.arb")
