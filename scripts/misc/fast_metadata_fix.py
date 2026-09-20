import json
import os
import glob

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    updated = False
    
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
                elif k in ["featuringArtist", "currentCountry", "inspiredByName"]:
                    pass # We will skip these or add them manually, wait no, let's just use {} for everything else
                else:
                    data[meta_key] = {}
                updated = True
                
    if updated:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

print("Fast metadata injection complete.", flush=True)
