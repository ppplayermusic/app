import urllib.request
import urllib.parse
import json
import os
import glob
import time

def translate_mymemory(text, target_lang):
    if target_lang == 'en':
        return text
    
    # Map to valid ISO languages for mymemory if needed
    lang_map = {
        'fil': 'tl', # Filipino -> Tagalog
        'my': 'my',
        'pcm': 'en', # Nigerian Pidgin -> English
    }
    lang = lang_map.get(target_lang, target_lang)
    
    url = f"https://api.mymemory.translated.net/get?q={urllib.parse.quote(text)}&langpair=en|{lang}&de=veneno@example.com"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        response = urllib.request.urlopen(req, timeout=10)
        data = json.loads(response.read().decode('utf-8'))
        return data['responseData']['translatedText']
    except Exception as e:
        print(f"Failed to translate to {target_lang}: {e}", flush=True)
        return text

# Load english as source of truth
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

# The list of missing keys
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
    lang_code = filename.replace('app_', '').replace('.arb', '')
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    updated = False
    
    # Handle normal translation
    if filename != 'app_en.arb':
        for key in keys_to_translate:
            if key not in data:
                english_text = en_data[key]
                translated = translate_mymemory(english_text, lang_code)
                data[key] = translated
                updated = True
                time.sleep(0.1) # Sleep to be nice to API
                
        # Handle trackCount specially
        if "trackCount" not in data:
            t_0 = translate_mymemory("0 tracks", lang_code)
            t_1 = translate_mymemory("1 track", lang_code)
            t_other = translate_mymemory("tracks", lang_code)
            data["trackCount"] = "{count, plural, =0{" + t_0 + "} =1{" + t_1 + "} other{{count} " + t_other + "}}"
            updated = True
            
    # Add empty metadata for EVERY key that doesn't have it, to satisfy the IDE.
    keys = list(data.keys())
    for k in keys:
        if not k.startswith('@'):
            meta_key = f"@{k}"
            if meta_key not in data:
                # Add default empty metadata
                if k == "trackCount":
                    data[meta_key] = {"placeholders": {"count": {}}}
                elif k == "versionInfo":
                    data[meta_key] = {"placeholders": {"version": {}, "build": {}}}
                elif k == "copyright":
                    data[meta_key] = {"placeholders": {"year": {}}}
                else:
                    data[meta_key] = {}
                updated = True
                
    if updated:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"[{i+1}/{total_files}] Updated {filename}", flush=True)
    else:
        print(f"[{i+1}/{total_files}] Skipped {filename} (no updates needed)", flush=True)

print("Translation and metadata generation complete.", flush=True)
