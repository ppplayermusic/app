// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUM';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTI';

  @override
  String get artwork => 'COPERTINA';

  @override
  String get appVersion => 'Versione app';

  @override
  String get artist => 'Artista';

  @override
  String get artistsYouFollow => 'Artisti che segui';

  @override
  String get autoplay => 'Riproduzione automatica';

  @override
  String get becauseYouListenedTo => 'Perché hai ascoltato';

  @override
  String get browseAll => 'Sfoglia tutto';

  @override
  String get cancel => 'Annulla';

  @override
  String get clearAppCache => 'Svuotare la cache dell\'app?';

  @override
  String get clearCache => 'Svuota cache';

  @override
  String get clearHistory => 'Cancellare la cronologia?';

  @override
  String get clearRecentlyPlayed => 'Cancella ascoltati di recente';

  @override
  String get contentMarket => 'Mercato dei contenuti';

  @override
  String get continueListening => 'Continua ad ascoltare';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continua la riproduzione video in una piccola finestra';

  @override
  String get create => 'Crea';

  @override
  String get createAPlaylistToGetStarted => 'Crea una playlist per iniziare';

  @override
  String currentSelectedcountry(Object country) {
    return 'Attuale: $country';
  }

  @override
  String get deletePlaylist => 'Elimina playlist';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Errore nel caricamento dei mercati: $err';
  }

  @override
  String error(Object error) {
    return 'Errore: $error';
  }

  @override
  String explore(Object genre) {
    return 'Esplora $genre';
  }

  @override
  String get fansAlsoLike => 'I FAN AMANO ANCHE';

  @override
  String featuringTouppercase(Object artist) {
    return 'CON $artist';
  }

  @override
  String get featuredPlaylists => 'Playlist in primo piano';

  @override
  String get followArtistsToSeeThemHere => 'Segui gli artisti per vederli qui';

  @override
  String get followStationsToSeeThemHere => 'Segui le stazioni per vederle qui';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forza stream solo audio per risparmiare dati';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Libera spazio e forza dati freschi al prossimo caricamento';

  @override
  String get fromYourFavorites => 'Dai tuoi preferiti';

  @override
  String get goBack => 'Torna indietro';

  @override
  String inspiredByName(Object name) {
    return 'Ispirato da $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Continua a riprodurre brani simili quando la coda finisce';

  @override
  String get library => 'Libreria';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Metti mi piace agli album per vederli qui';

  @override
  String get likedSongs => 'Brani che ti piacciono';

  @override
  String get lowDataMode => 'Modalità risparmio dati';

  @override
  String get madeForYou => 'Creato per te';

  @override
  String moreLikeName(Object name) {
    return 'Simile a $name';
  }

  @override
  String get moreOptions => 'Altre opzioni';

  @override
  String get nameYourMasterpiece => 'Dai un nome al tuo capolavoro...';

  @override
  String get newPlaylist => 'Nuova playlist';

  @override
  String get newReleases => 'Nuove uscite';

  @override
  String get next => 'Successivo';

  @override
  String get noAlbumsFound => 'Nessun album trovato';

  @override
  String get noArtistsFollowed => 'Nessun artista seguito';

  @override
  String get noArtistsFound => 'Nessun artista trovato';

  @override
  String get noLikedAlbums => 'Nessun album piaciuto';

  @override
  String get noPlaylistsFound => 'Nessuna playlist trovata';

  @override
  String get noPlaylistsYet => 'Nessuna playlist ancora';

  @override
  String get noResultsFound => 'Nessun risultato trovato';

  @override
  String get noStationsFollowed => 'Nessuna stazione seguita';

  @override
  String get noTrackPlaying => 'Nessun brano in riproduzione';

  @override
  String get noTracksFound => 'Nessun brano trovato';

  @override
  String get playlists => 'PLAYLIST';

  @override
  String get popular => 'POPOLARE';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Rimuovi permanentemente la cronologia di ascolto';

  @override
  String get pictureinpicturePip => 'Picture-in-Picture (PiP)';

  @override
  String get popularAlbums => 'Album popolari';

  @override
  String get popularArtists => 'Artisti popolari';

  @override
  String get popularGenres => 'Generi popolari';

  @override
  String get popularSongs => 'Brani popolari';

  @override
  String get popularTracks => 'Tracce popolari';

  @override
  String get popularHitsRightNow => 'Hit popolari al momento';

  @override
  String get previous => 'Precedente';

  @override
  String get queue => 'CODA';

  @override
  String get recentSearches => 'Ricerche recenti';

  @override
  String get recommendedForYou => 'Consigliato per te';

  @override
  String get scraping => 'Scraping';

  @override
  String get search => 'Cerca';

  @override
  String get searchInAlbum => 'Cerca nell\'album...';

  @override
  String get searchInLibrary => 'Cerca nella libreria...';

  @override
  String get searchInPlaylist => 'Cerca nella playlist';

  @override
  String get searchLikedSongs => 'Cerca nei brani piaciuti...';

  @override
  String get searchPopularSongs => 'Cerca brani popolari...';

  @override
  String get selectMarket => 'Seleziona mercato';

  @override
  String get settings => 'Impostazioni';

  @override
  String get showVideoPlayer => 'Mostra riproduttore video';

  @override
  String get shuffle => 'Riproduzione casuale';

  @override
  String get spotifyCredentials => 'Credenziali Spotify';

  @override
  String get suggestedStations => 'Stazioni suggerite';

  @override
  String get tracks => 'BRANI';

  @override
  String get trending => 'Tendenze';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get tryADifferentSearchTerm => 'Prova un termine di ricerca diverso';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Usa il player di YouTube quando disponibile';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Cosa vuoi ascoltare?';

  @override
  String get youtubeCredentials => 'Credenziali YouTube';

  @override
  String get yourLibrary => 'La tua libreria';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Aggiungi alla playlist';

  @override
  String get addToQueue => 'Aggiungi alla coda';

  @override
  String get copyId => 'Copia ID';

  @override
  String get copyLink => 'Copia link';

  @override
  String get discover => 'Scopri';

  @override
  String get enterYourName => 'Inserisci il tuo nome';

  @override
  String get favorites => 'Preferiti';

  @override
  String get goToAlbum => 'Vai all\'album';

  @override
  String get goToArtist => 'Vai all\'artista';

  @override
  String get goToArtistRadio => 'Vai alla radio dell\'artista';

  @override
  String get goToPlaylist => 'Vai alla playlist';

  @override
  String get goToSongRadio => 'Vai alla radio del brano';

  @override
  String get home => 'Home';

  @override
  String get myAwesomePlaylist => 'La mia fantastica playlist';

  @override
  String get myPlaylist => 'La mia playlist';

  @override
  String get newPlaylist1 => 'Nuova playlist';

  @override
  String get play => 'Riproduci';

  @override
  String get playStation => 'Riproduci stazione';

  @override
  String get playNext => 'Riproduci successivo';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Nome della playlist';

  @override
  String get playlists1 => 'Playlist';

  @override
  String get queue1 => 'Coda';

  @override
  String get recentlyPlayed => 'Ascoltati di recente';

  @override
  String get removeFromQueue => 'Rimuovi dalla coda';

  @override
  String get retry => 'Riprova';

  @override
  String get searchMusicArtistsAlbums => 'Cerca musica, artisti, album...';

  @override
  String get share => 'Condividi';

  @override
  String featuringArtist(String artistName) {
    return 'CON $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Attuale: $country';
  }

  @override
  String get queueTooltip => 'Coda';

  @override
  String get searchHint => 'Cerca musica, artisti, album...';

  @override
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';
}
