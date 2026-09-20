import json
import glob
import os

en_file = 'lib/l10n/app_en.arb'
with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

to_translate = {}

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    if filename == 'app_en.arb':
        continue
    
    lang = filename.replace('app_', '').replace('.arb', '')
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    missing_for_lang = {}
    for k, v in data.items():
        if not k.startswith('@') and k in en_data and data[k] == en_data[k]:
            if v not in ['PPPlayer', 'GitHub', 'OK', 'Website']:
                missing_for_lang[k] = v
                
    if missing_for_lang:
        to_translate[lang] = missing_for_lang

with open('to_translate.json', 'w', encoding='utf-8') as f:
    json.dump(to_translate, f, ensure_ascii=False, indent=2)

print("Saved to_translate.json")
