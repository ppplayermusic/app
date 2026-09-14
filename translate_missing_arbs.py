import urllib.request
import urllib.parse
import json
import os
import glob
import time
import socket

# Set global default timeout for sockets
socket.setdefaulttimeout(10)

def translate(text, target_lang):
    if target_lang == 'en':
        return text
    # Fix language codes for Google Translate
    lang_map = {
        'fil': 'tl', # Filipino -> Tagalog
        'my': 'my',
        'pcm': 'en', # Nigerian Pidgin -> use English as fallback
    }
    lang = lang_map.get(target_lang, target_lang)
    
    url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={lang}&dt=t&q={urllib.parse.quote(text)}"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        response = urllib.request.urlopen(req, timeout=10)
        data = json.loads(response.read().decode('utf-8'))
        return ''.join([sentence[0] for sentence in data[0]])
    except Exception as e:
        print(f"Failed to translate to {target_lang}: {e}", flush=True)
        return text

# Load english as source of truth
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

keys_to_translate = [
    "songsTab", "foldersTab", "artistsTab", "albumsTab", "addMusic", 
    "addFiles", "addFolder", "rescanLibrary", "sortTitle", "sortArtist", 
    "sortAlbum", "sortDuration", "sortDateAdded", "trackInformation", 
    "removeFromLibrary", "showInFolder", "unknownArtist", "unknownAlbum", 
    "importedFiles", "playFolder", "shuffleFolder", "playAll", 
    "includeSubfolders", "noLocalSongs", "searchLocalMusic", 
    "viewAsList", "viewAsGrid", "trackInfoPath", "trackInfoFormat", "trackInfoDuration"
]

files = list(glob.glob('lib/l10n/app_*.arb'))
total_files = len(files)

for i, filepath in enumerate(files):
    filename = os.path.basename(filepath)
    if filename == 'app_en.arb':
        continue
        
    lang_code = filename.replace('app_', '').replace('.arb', '')
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    updated = False
    
    for key in keys_to_translate:
        if key not in data:
            english_text = en_data[key]
            translated = translate(english_text, lang_code)
            data[key] = translated
            updated = True
            time.sleep(0.3) # Avoid rate limiting
            
    # Handle trackCount specially
    if "trackCount" not in data:
        t_0 = translate("0 tracks", lang_code)
        t_1 = translate("1 track", lang_code)
        t_other = translate("tracks", lang_code)
        # Reconstruct ICU plural
        data["trackCount"] = "{count, plural, =0{" + t_0 + "} =1{" + t_1 + "} other{{count} " + t_other + "}}"
        updated = True
        
    if updated:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"[{i}/{total_files}] Updated {filename}", flush=True)
    else:
        print(f"[{i}/{total_files}] Skipped {filename} (no missing keys)", flush=True)

print("Translation complete.", flush=True)
