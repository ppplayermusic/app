import os
import json
from deep_translator import GoogleTranslator

# Target keys and their English strings
target_keys = {
    'filterAll': 'All',
    'filterPlaylists': 'Playlists',
    'filterArtists': 'Artists',
    'filterAlbums': 'Albums',
    'filterStations': 'Stations',
    'localMusicCard': 'Local Music',
    'createPlaylistButton': 'Create Playlist',
}

# The language map for Google Translator
lang_map = {
    'ar': 'ar', 'bn': 'bn', 'cs': 'cs', 'da': 'da', 'de': 'de', 'es': 'es', 
    'et': 'et', 'fa': 'fa', 'fil': 'tl', 'fr': 'fr', 'gn': 'gn', 'hi': 'hi', 
    'hr': 'hr', 'hu': 'hu', 'id': 'id', 'it': 'it', 'ja': 'ja', 'ka': 'ka', 
    'kk': 'kk', 'ko': 'ko', 'lv': 'lv', 'ms': 'ms', 'my': 'my', 'pcm': 'en', # Pidgin usually fallback to english or closest
    'pl': 'pl', 'pt': 'pt', 'ru': 'ru', 'sv': 'sv', 'uz': 'uz', 'zh': 'zh-CN'
}

# Read English
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

# Add keys to english
for k, v in target_keys.items():
    if k not in en_data:
        en_data[k] = v
        en_data[f"@{k}"] = {}

with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_data, f, indent=2, ensure_ascii=False)
    f.write('\n')

for code in lang_map:
    file_path = f'lib/l10n/app_{code}.arb'
    if not os.path.exists(file_path):
        continue
        
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    translator = GoogleTranslator(source='en', target=lang_map[code])
    
    modified = False
    for k, v in target_keys.items():
        if k not in data:
            try:
                translated = translator.translate(v)
                data[k] = translated
                modified = True
            except Exception as e:
                print(f"Error translating {k} to {code}: {e}")
                data[k] = v
                modified = True
    
    if modified:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
            f.write('\n')
        print(f"Updated {file_path}")

print("Done translating library keys!")
