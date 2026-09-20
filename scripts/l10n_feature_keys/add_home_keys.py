import json
import os

keys_to_add = {
  "goodMorning": "Good morning",
  "goodAfternoon": "Good afternoon",
  "goodEvening": "Good evening",
  "greetingWithName": "{greeting}, {name}",
  "yourMusicIsWaiting": "Your music is waiting.",
  "dailyMix": "Daily Mix {number}",
  "yourFavoritesAndNewDiscoveries": "Your favorites\nand new discoveries",
  "discoverWeekly": "Discover Weekly",
  "madeForYou": "Made for you",
  "releaseRadar": "Release Radar",
  "newMusicJustForYou": "New music\njust for you",
  "chillMix": "Chill Mix",
  "relaxAndUnwind": "Relax and unwind",
  "focusMix": "Focus Mix",
  "deepFocusAndProductivity": "Deep focus\nand productivity",
  "artistRadio": "{artist} Radio",
  "genreRadio": "{genre} Radio"
}

metadata = {
  "@goodMorning": {},
  "@goodAfternoon": {},
  "@goodEvening": {},
  "@greetingWithName": {
    "placeholders": {
      "greeting": {},
      "name": {}
    }
  },
  "@yourMusicIsWaiting": {},
  "@dailyMix": {
    "placeholders": {
      "number": {}
    }
  },
  "@yourFavoritesAndNewDiscoveries": {},
  "@discoverWeekly": {},
  "@madeForYou": {},
  "@releaseRadar": {},
  "@newMusicJustForYou": {},
  "@chillMix": {},
  "@relaxAndUnwind": {},
  "@focusMix": {},
  "@deepFocusAndProductivity": {},
  "@artistRadio": {
    "placeholders": {
      "artist": {}
    }
  },
  "@genreRadio": {
    "placeholders": {
      "genre": {}
    }
  }
}

en_path = 'lib/l10n/app_en.arb'
with open(en_path, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

for k, v in keys_to_add.items():
    en_data[k] = v
    en_data[f"@{k}"] = metadata[f"@{k}"]

with open(en_path, 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)

print("Added keys to app_en.arb")
