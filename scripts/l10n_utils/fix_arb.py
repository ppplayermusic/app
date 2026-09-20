import json
import glob

# Load template
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    template = json.load(f)

# Get all string keys from template
template_keys = {k: v for k, v in template.items() if not k.startswith('@')}

for f in glob.glob('lib/l10n/app_*.arb'):
    if f.endswith('app_en.arb'): continue
    
    with open(f, 'r', encoding='utf-8') as file:
        data = json.load(file)
        
    changed = False
    
    # Remove empty @ keys
    keys_to_remove = []
    for k, v in data.items():
        if k.startswith('@') and k != '@@locale' and v == {}:
            keys_to_remove.append(k)
            
    for k in keys_to_remove:
        del data[k]
        changed = True
        
    # Add missing string keys from template
    for k, v in template_keys.items():
        if k not in data:
            data[k] = v
            changed = True
            
    if changed:
        with open(f, 'w', encoding='utf-8') as file:
            json.dump(data, file, ensure_ascii=False, indent=2)
        print(f"Fixed {f}")
