import json
import re
import os

with open('/Users/veneno/Projects/Apps/ppplayer/app/lib/l10n/app_en.arb', 'r') as f:
    arb = json.load(f)

keys = sorted([k for k in arb.keys() if not k.startswith('@')], key=lambda k: len(arb[k]), reverse=True)
strings_to_keys = {arb[k]: k for k in keys if k != "@@locale"}

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    def repl(m):
        prefix = m.group(1)
        val = m.group(2)
        if val in strings_to_keys:
            key = strings_to_keys[val]
            return f"{prefix}AppLocalizations.of(context)!.{key}"
        return m.group(0)

    pattern = re.compile(r"(title:\s*|subtitle:\s*|hintText:\s*|tooltip:\s*|label:\s*|Text\(\s*|\s*)'([^']+)'")
    
    new_content = pattern.sub(repl, content)
    
    if new_content != content:
        if 'import \'package:ppplayer/l10n/app_localizations.dart\';' not in new_content:
            match = re.search(r'^import .*;$', new_content, re.MULTILINE)
            if match:
                insert_pos = match.end()
                new_content = new_content[:insert_pos] + "\nimport 'package:ppplayer/l10n/app_localizations.dart';" + new_content[insert_pos:]
        
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

app_dir = '/Users/veneno/Projects/Apps/ppplayer/app/lib/shared'
for root, _, files in os.walk(app_dir):
    for f in files:
        if f.endswith('.dart'):
            process_file(os.path.join(root, f))
