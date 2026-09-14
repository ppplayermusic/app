import json
import glob
import os

en_file = 'lib/l10n/app_en.arb'
with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

untranslated_counts = {}
total_untranslated = 0

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    if filename == 'app_en.arb':
        continue
    
    lang = filename.replace('app_', '').replace('.arb', '')
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    count = 0
    for k, v in data.items():
        if not k.startswith('@') and k in en_data and data[k] == en_data[k]:
            # This string is identical to English, likely untranslated!
            # (Exceptions: 'PPPlayer', 'GitHub', 'OK' might be identical naturally, but let's count them)
            if v not in ['PPPlayer', 'GitHub', 'OK', 'Website']:
                count += 1
                
    if count > 0:
        untranslated_counts[lang] = count
        total_untranslated += count

print(f"Total untranslated strings across all languages: {total_untranslated}")
for lang, count in untranslated_counts.items():
    print(f"{lang}: {count} untranslated strings")
