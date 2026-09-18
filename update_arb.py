import json
import glob

en_file = 'lib/l10n/app_en.arb'
with open(en_file, 'r') as f:
    en_data = json.load(f)

for arb_file in glob.glob('lib/l10n/app_*.arb'):
    if arb_file == en_file:
        continue
    with open(arb_file, 'r') as f:
        data = json.load(f)
    
    # Update missing keys
    changed = False
    for k, v in en_data.items():
        if k not in data and not k.startswith('@'):
            data[k] = v
            changed = True
            
        # Also copy metadata
        if k.startswith('@'):
            if k not in data:
                data[k] = v
                changed = True
                
    if changed:
        with open(arb_file, 'w') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
            f.write('\n')
