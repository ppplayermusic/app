import json
import os

translations = {
    'uz': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'pleyer_ekrani_ko_rinish_almashtirish', 'video': 'VIDEO', 'trackInfoFormat': 'Format'},
    'cs': {'titleSubtitle': '{title}, {subtitle}', 'video': 'VIDEO', 'playerscreenviewswitch': 'prepinac_zobrazeni_prehravace', 'playlist': 'Seznam skladeb'},
    'my': {'scraping': 'ခြစ်ယူခြင်း', 'playerscreenviewswitch': 'ကစားသမား_မျက်နှာပြင်_မြင်ကွင်း_ပြောင်းရန်'},
    'pt': {'titleSubtitle': '{title}, {subtitle}', 'playlists': 'LISTAS DE REPRODUÇÃO', 'popular': 'POPULAR', 'playerscreenviewswitch': 'alternar_visualizacao_tela_jogador', 'playlist': 'Lista de Reprodução', 'playlists1': 'Listas de Reprodução'},
    'hr': {'titleSubtitle': '{title}, {subtitle}', 'video': 'VIDEO', 'playerscreenviewswitch': 'prebacivanje_prikaza_zaslona_sviraca', 'trackInfoFormat': 'Format'},
    'et': {'titleSubtitle': '{title}, {subtitle}', 'artist': 'Esitaja', 'video': 'VIDEO', 'playerscreenviewswitch': 'mangija_ekraani_vaate_lüliti'},
    'de': {'titleSubtitle': '{title}, {subtitle}', 'autoplay': 'Autoplay', 'playlists': 'PLAYLISTS', 'video': 'VIDEO', 'playerscreenviewswitch': 'spieler_bildschirm_ansicht_wechseln', 'playlist': 'Wiedergabeliste', 'playlists1': 'Wiedergabelisten', 'trackInfoFormat': 'Format', 'versionInfo': 'Version {version} (Build {build})', 'support': 'Unterstützung'},
    'it': {'titleSubtitle': '{title}, {subtitle}', 'scraping': 'Raschiatura', 'video': 'VIDEO', 'playerscreenviewswitch': 'cambia_vista_schermo_giocatore', 'home': 'Inizio', 'playlist': 'Playlist'},
    'kk': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'ойыншы_экраны_көрінісін_ауыстыру'},
    'es': {'titleSubtitle': '{title}, {subtitle}', 'error': 'Error: {error}', 'playlists': 'LISTAS DE REPRODUCCIÓN', 'popular': 'POPULAR', 'video': 'VIDEO', 'playerscreenviewswitch': 'cambiar_vista_pantalla_jugador', 'playlist': 'Lista de reproducción', 'playlists1': 'Listas de reproducción'},
    'ko': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': '플레이어_화면_보기_전환'},
    'hu': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'lejatszo_kepernyo_nezet_valto'},
    'fil': {'titleSubtitle': '{title}, {subtitle}', 'artwork': 'SINING', 'autoplay': 'Autoplay', 'contentMarket': 'Market ng Nilalaman', 'error': 'Error: {error}', 'home': 'Home', 'library': 'Aklatan', 'lowDataMode': 'Mode ng Mababang Data', 'pictureinpicturePip': 'Picture-in-Picture (PiP)', 'playerscreenviewswitch': 'pagpalit_tingin_screen_manlalaro', 'playlist': 'Playlist', 'queue': 'PILA', 'queue1': 'Pila', 'queueTooltip': 'Pila', 'shuffle': 'I-shuffle', 'trending': 'Trending', 'video': 'VIDEO', 'trackInfoPath': 'Landas', 'trackInfoFormat': 'Format'},
    'da': {'titleSubtitle': '{title}, {subtitle}', 'video': 'VIDEO', 'playerscreenviewswitch': 'skift_spiller_skaerm_visning', 'trackInfoFormat': 'Format', 'versionInfo': 'Version {version} (Build {build})', 'support': 'Support'},
    'id': {'titleSubtitle': '{title}, {subtitle}', 'scraping': 'Mengikis', 'video': 'VIDEO', 'playerscreenviewswitch': 'beralih_tampilan_layar_pemain', 'playlist': 'Daftar Putar', 'trackInfoFormat': 'Format'},
    'gn': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'moambue_hecha_mba_e_ryru', 'video': 'VIDEO'},
    'ru': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'переключение_вида_экрана_плеера'},
    'pcm': {
        'titleSubtitle': '{title}, {subtitle}', 'albums': 'ALBUMS', 'appVersion': 'App vershon', 'artist': 'Artis', 'artists': 'ARTIS DEM', 'artwork': 'ARTWORK', 'autoplay': 'Autoplay', 'cancel': 'Cancel', 'clearAppCache': 'Clear App Cache?', 'clearCache': 'Clear Cache', 'clearHistory': 'Clear History?', 'contentMarket': 'Content Market', 'copyId': 'Copy ID', 'copyLink': 'Copy link', 'create': 'Make', 'currentCountry': 'Current: {country}', 'currentSelectedcountry': 'Current: {country}', 'deletePlaylist': 'Delete Playlist', 'discover': 'Discover', 'editProfile': 'Edit Profile', 'enterYourName': 'Enter your name', 'error': 'Error: {error}', 'explore': 'Explore {genre}', 'fansAlsoLike': 'FANS ALSO LIKE', 'favorites': 'Favorites', 'featuredPlaylists': 'Featured Playlists', 'featuringArtist': 'FEATURING {artistName}', 'featuringTouppercase': 'FEATURING {artist}', 'fromYourFavorites': 'From your favorites', 'goToAlbum': 'Go to album', 'goToArtist': 'Go to artist', 'goToArtistRadio': 'Go to artist radio', 'goToPlaylist': 'Go to playlist', 'goToSongRadio': 'Go to song radio', 'home': 'Home', 'inspiredByName': 'Inspired by {name}', 'language': 'Language', 'library': 'Library', 'lowDataMode': 'Low Data Mode', 'madeForYou': 'Made For You', 'moreLikeName': 'More like {name}', 'moreOptions': 'More options', 'myPlaylist': 'My Playlist', 'newPlaylist': 'New Playlist', 'newPlaylist1': 'New playlist', 'newReleases': 'New Releases', 'next': 'Next', 'pictureinpicturePip': 'Picture-in-Picture (PiP)', 'play': 'Play', 'playNext': 'Play next', 'playerscreenviewswitch': 'player_screen_view_switch', 'playStation': 'Play Station', 'playlist': 'Playlist', 'playlistName': 'Playlist Name', 'playlists': 'PLAYLISTS', 'playlists1': 'Playlists', 'popular': 'POPULAR', 'popularAlbums': 'Popular Albums', 'popularArtists': 'Popular Artists', 'popularGenres': 'Popular Genres', 'popularSongs': 'Popular Songs', 'popularTracks': 'Popular Tracks', 'previous': 'Previous', 'queue': 'QUEUE', 'queue1': 'Queue', 'queueTooltip': 'Queue', 'recentSearches': 'Recent searches', 'recentlyPlayed': 'Recently Played', 'removeFromQueue': 'Remove from queue', 'search': 'Search', 'searchHint': 'Search music, artists, albums...', 'searchMusicArtistsAlbums': 'Search music, artists, albums...', 'searchPopularSongs': 'Search popular songs...', 'settings': 'Settings', 'share': 'Share', 'showVideoPlayer': 'Show Video Player', 'shuffle': 'Shuffle', 'spotifyCredentials': 'Spotify Credentials', 'systemDefault': 'System Default', 'tracks': 'TRACKS', 'trending': 'Trending', 'video': 'VIDEO', 'yourLibrary': 'Your Library', 'youtubeCredentials': 'YouTube Credentials', 'addToPlaylist': 'Add to playlist', 'addToQueue': 'Add to queue', 'songsTab': 'Songs', 'foldersTab': 'Folders', 'artistsTab': 'Artists', 'albumsTab': 'Albums', 'trackInformation': 'Track Informashon', 'unknownArtist': 'Unknown Artist', 'unknownAlbum': 'Unknown Album', 'importedFiles': 'Imported Files', 'trackInfoPath': 'Path', 'trackInfoFormat': 'Format', 'trackInfoDuration': 'Duration', 'trackCount': '{count, plural, =0{0 tracks} =1{1 track} other{{count} tracks}}', 'aboutDescription': 'Awoof music player wey their code open for everybody.', 'versionInfo': 'Vershon {version} (Build {build})', 'createdBy': 'Na Lucas Coelho do am', 'releaseNotes': 'Release notes', 'support': 'Help', 'license': 'License', 'acknowledgments': 'Acknowledgments', 'copyright': '© {year} PPPlayer contributors', 'close': 'Close'
    },
    'ka': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'მოთამაშის_ეკრანის_ნახვის_გადამრთველი'},
    'fr': {'titleSubtitle': '{title}, {subtitle}', 'albums': 'ALBUMS', 'playlists': 'LISTES DE LECTURE', 'playerscreenviewswitch': 'basculer_vue_ecran_joueur', 'playlist': 'Liste de lecture', 'playlists1': 'Listes de lecture', 'albumsTab': 'Albums', 'trackInfoFormat': 'Format', 'versionInfo': 'Version {version} (Build {build})'},
    'pl': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'przelacznik_widoku_ekranu_gracza', 'trackInfoFormat': 'Format'},
    'fa': {'playerscreenviewswitch': 'تغییر_نمای_صفحه_پخش‌کننده'},
    'sv': {'titleSubtitle': '{title}, {subtitle}', 'artist': 'Artist', 'video': 'VIDEO', 'playerscreenviewswitch': 'vaxla_spelar_skarm_vy', 'trackInfoFormat': 'Format', 'support': 'Support'},
    'hi': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'प्लेयर_स्क्रीन_व्यू_स्विच'},
    'ja': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'プレーヤー画面ビュー切り替え'},
    'bn': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'প্লেয়ার_স্ক্রিন_ভিউ_সুইচ'},
    'zh': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': '播放器屏幕视图切换'},
    'lv': {'titleSubtitle': '{title}, {subtitle}', 'playerscreenviewswitch': 'speletaja_ekrana_skata_sledzis', 'video': 'VIDEO'},
    'ms': {'titleSubtitle': '{title}, {subtitle}', 'popular': 'POPULAR', 'video': 'VIDEO', 'playerscreenviewswitch': 'tukar_pandangan_skrin_pemain', 'trackInfoFormat': 'Format'},
    'ar': {'playerscreenviewswitch': 'تبديل_عرض_شاشة_اللاعب'}
}

with open('to_translate.json', 'r', encoding='utf-8') as f:
    to_translate = json.load(f)

for lang, data in to_translate.items():
    filepath = f'lib/l10n/app_{lang}.arb'
    
    with open(filepath, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
        
    for k, v in data.items():
        # Only inject if we have a better translation that isn't API or titleSubtitle
        if k in translations.get(lang, {}):
            arb_data[k] = translations[lang][k]
            
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, ensure_ascii=False, indent=2)

print("Remaining translations applied!")
