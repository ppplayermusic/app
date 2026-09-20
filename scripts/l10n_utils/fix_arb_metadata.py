import json
import os
import glob

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    if filename == 'app_en.arb':
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    keys_to_remove = [k for k in data.keys() if k.startswith('@') and k != '@@locale']
    
    for k in keys_to_remove:
        del data[k]
        
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Removed redundant metadata from all non-English .arb files.")
