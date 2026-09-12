import json
import os

with open('/Users/veneno/Projects/Apps/ppplayer/app/lib/l10n/app_en.arb', 'r') as f:
    arb = json.load(f)

# Hardcoded exact replacements
replacements = {
    "'Search in library...'": "AppLocalizations.of(context)!.searchInLibrary",
    "'Library'": "AppLocalizations.of(context)!.library",
    "'Go Back'": "AppLocalizations.of(context)!.goBack",
    "'Cancel'": "AppLocalizations.of(context)!.cancel",
    "'Create'": "AppLocalizations.of(context)!.create",
    "'New Playlist'": "AppLocalizations.of(context)!.newPlaylist",
    "'Name your masterpiece...'": "AppLocalizations.of(context)!.nameYourMasterpiece",
    "'No results found'": "AppLocalizations.of(context)!.noResultsFound",
    "'Try a different search term'": "AppLocalizations.of(context)!.tryADifferentSearchTerm",
    "'No playlists yet'": "AppLocalizations.of(context)!.noPlaylistsYet",
    "'Create a playlist to get started'": "AppLocalizations.of(context)!.createAPlaylistToGetStarted",
    "'Delete Playlist'": "AppLocalizations.of(context)!.deletePlaylist",
    "'No artists followed'": "AppLocalizations.of(context)!.noArtistsFollowed",
    "'Follow artists to see them here'": "AppLocalizations.of(context)!.followArtistsToSeeThemHere",
    "'No liked albums'": "AppLocalizations.of(context)!.noLikedAlbums",
    "'Like albums to see them here'": "AppLocalizations.of(context)!.likeAlbumsToSeeThemHere",
    "'No stations followed'": "AppLocalizations.of(context)!.noStationsFollowed",
    "'Follow stations to see them here'": "AppLocalizations.of(context)!.followStationsToSeeThemHere",
    "'Search in album...'": "AppLocalizations.of(context)!.searchInAlbum",
    "'Search in playlist'": "AppLocalizations.of(context)!.searchInPlaylist",
    "'Search liked songs...'": "AppLocalizations.of(context)!.searchLikedSongs",
    "'Search popular songs...'": "AppLocalizations.of(context)!.searchPopularSongs",
    "'ALBUMS'": "AppLocalizations.of(context)!.albums",
    "'FANS ALSO LIKE'": "AppLocalizations.of(context)!.fansAlsoLike",
    "'POPULAR'": "AppLocalizations.of(context)!.popular",
    "'Settings'": "AppLocalizations.of(context)!.settings",
    "'Your Library'": "AppLocalizations.of(context)!.yourLibrary",
}

app_dir = '/Users/veneno/Projects/Apps/ppplayer/app/lib/features'
for root, _, files in os.walk(app_dir):
    for f in files:
        if not f.endswith('.dart'): continue
        filepath = os.path.join(root, f)
        with open(filepath, 'r') as file:
            content = file.read()
            
        new_content = content
        for k, v in replacements.items():
            new_content = new_content.replace(k, v)
            
        if new_content != content:
            if 'import \'package:ppplayer/l10n/app_localizations.dart\';' not in new_content:
                import_stmt = "import 'package:ppplayer/l10n/app_localizations.dart';\n"
                # insert after first import
                first_import = new_content.find('import')
                if first_import != -1:
                    end_of_line = new_content.find('\n', first_import)
                    new_content = new_content[:end_of_line+1] + import_stmt + new_content[end_of_line+1:]
                else:
                    new_content = import_stmt + new_content
            with open(filepath, 'w') as file:
                file.write(new_content)
            print(f"Updated {filepath}")
