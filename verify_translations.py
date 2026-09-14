import json
import os
import glob
import sys

def verify_translations():
    arb_files = glob.glob('lib/l10n/app_*.arb')
    if not arb_files:
        print("No .arb files found.")
        return

    # Load English keys as the source of truth
    en_file = 'lib/l10n/app_en.arb'
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    
    expected_keys = set(en_data.keys())
    
    all_good = True
    for filepath in arb_files:
        filename = os.path.basename(filepath)
        if filename == 'app_en.arb':
            continue
            
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        keys = set(data.keys())
        
        missing_keys = expected_keys - keys
        extra_keys = keys - expected_keys
        
        if missing_keys or extra_keys:
            all_good = False
            print(f"\n{filename}:")
            if missing_keys:
                print(f"  Missing: {missing_keys}")
            if extra_keys:
                print(f"  Extra: {extra_keys}")

    if all_good:
        print("All languages have exactly the same keys and metadata as English! Everything is translated properly.")
    else:
        print("\nFound discrepancies!")

verify_translations()
