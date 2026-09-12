// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

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
  String get artists => 'KUNSTNERE';

  @override
  String get artwork => 'BILLEDE';

  @override
  String get appVersion => 'App-version';

  @override
  String get artist => 'Kunstner';

  @override
  String get artistsYouFollow => 'Kunstnere du følger';

  @override
  String get autoplay => 'Automatisk afspilning';

  @override
  String get becauseYouListenedTo => 'Fordi du lyttede til';

  @override
  String get browseAll => 'Gennemse alt';

  @override
  String get cancel => 'Annuller';

  @override
  String get clearAppCache => 'Ryd app-cache?';

  @override
  String get clearCache => 'Ryd cache';

  @override
  String get clearHistory => 'Ryd historik?';

  @override
  String get clearRecentlyPlayed => 'Ryd nyligt afspillede';

  @override
  String get contentMarket => 'Indholdsmarked';

  @override
  String get continueListening => 'Fortsæt med at lytte';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Fortsæt videoafspilning i et lille vindue';

  @override
  String get create => 'Opret';

  @override
  String get createAPlaylistToGetStarted =>
      'Opret en playliste for at komme i gang';

  @override
  String currentSelectedcountry(Object country) {
    return 'Nuværende: $country';
  }

  @override
  String get deletePlaylist => 'Slet playliste';

  @override
  String get editProfile => 'Rediger profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Fejl ved indlæsning af markeder: $err';
  }

  @override
  String error(Object error) {
    return 'Fejl: $error';
  }

  @override
  String explore(Object genre) {
    return 'Udforsk $genre';
  }

  @override
  String get fansAlsoLike => 'FANS KAN OGSÅ LIDE';

  @override
  String featuringTouppercase(Object artist) {
    return 'MED $artist';
  }

  @override
  String get featuredPlaylists => 'Udvalgte playlister';

  @override
  String get followArtistsToSeeThemHere => 'Følg kunstnere for at se dem her';

  @override
  String get followStationsToSeeThemHere => 'Følg stationer for at se dem her';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Tving kun lyd-streams for at spare data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Frigør plads og fremtvinger nye data ved næste indlæsning';

  @override
  String get fromYourFavorites => 'Fra dine favoritter';

  @override
  String get goBack => 'Gå tilbage';

  @override
  String inspiredByName(Object name) {
    return 'Inspireret af $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Bliv ved med at afspille lignende numre, når køen slutter';

  @override
  String get library => 'Bibliotek';

  @override
  String get likeAlbumsToSeeThemHere => 'Synes godt om album for at se dem her';

  @override
  String get likedSongs => 'Sange, du synes godt om';

  @override
  String get lowDataMode => 'Lav datatilstand';

  @override
  String get madeForYou => 'Lavet til dig';

  @override
  String moreLikeName(Object name) {
    return 'Mere som $name';
  }

  @override
  String get moreOptions => 'Flere muligheder';

  @override
  String get nameYourMasterpiece => 'Navngiv dit mesterværk...';

  @override
  String get newPlaylist => 'Ny playliste';

  @override
  String get newReleases => 'Nye udgivelser';

  @override
  String get next => 'Næste';

  @override
  String get noAlbumsFound => 'Ingen album fundet';

  @override
  String get noArtistsFollowed => 'Ingen fulgte kunstnere';

  @override
  String get noArtistsFound => 'Ingen kunstnere fundet';

  @override
  String get noLikedAlbums => 'Ingen album, du synes godt om';

  @override
  String get noPlaylistsFound => 'Ingen playlister fundet';

  @override
  String get noPlaylistsYet => 'Ingen playlister endnu';

  @override
  String get noResultsFound => 'Ingen resultater fundet';

  @override
  String get noStationsFollowed => 'Ingen fulgte stationer';

  @override
  String get noTrackPlaying => 'Intet nummer afspilles';

  @override
  String get noTracksFound => 'Ingen numre fundet';

  @override
  String get playlists => 'PLAYLISTER';

  @override
  String get popular => 'POPULÆR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Fjern lyttehistorik permanent';

  @override
  String get pictureinpicturePip => 'Billede-i-billede (PiP)';

  @override
  String get popularAlbums => 'Populære album';

  @override
  String get popularArtists => 'Populære kunstnere';

  @override
  String get popularGenres => 'Populære genrer';

  @override
  String get popularSongs => 'Populære sange';

  @override
  String get popularTracks => 'Populære numre';

  @override
  String get popularHitsRightNow => 'Populære hits lige nu';

  @override
  String get previous => 'Forrige';

  @override
  String get queue => 'KØ';

  @override
  String get recentSearches => 'Seneste søgninger';

  @override
  String get recommendedForYou => 'Anbefalet til dig';

  @override
  String get scraping => 'Skraber';

  @override
  String get search => 'Søg';

  @override
  String get searchInAlbum => 'Søg i album...';

  @override
  String get searchInLibrary => 'Søg i bibliotek...';

  @override
  String get searchInPlaylist => 'Søg i playliste';

  @override
  String get searchLikedSongs => 'Søg i sange, du synes godt om...';

  @override
  String get searchPopularSongs => 'Søg i populære sange...';

  @override
  String get selectMarket => 'Vælg marked';

  @override
  String get settings => 'Indstillinger';

  @override
  String get showVideoPlayer => 'Vis videoafspiller';

  @override
  String get shuffle => 'Bland';

  @override
  String get spotifyCredentials => 'Spotify-legitimationsoplysninger';

  @override
  String get suggestedStations => 'Foreslåede stationer';

  @override
  String get tracks => 'NUMRE';

  @override
  String get trending => 'Trender';

  @override
  String get tryAgain => 'Prøv igen';

  @override
  String get tryADifferentSearchTerm => 'Prøv et andet søgeord';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Brug YouTube-afspiller, når den er tilgængelig';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Hvad vil du lytte til?';

  @override
  String get youtubeCredentials => 'YouTube-legitimationsoplysninger';

  @override
  String get yourLibrary => 'Dit bibliotek';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Føj til playliste';

  @override
  String get addToQueue => 'Føj til kø';

  @override
  String get copyId => 'Kopier ID';

  @override
  String get copyLink => 'Kopier link';

  @override
  String get discover => 'Opdag';

  @override
  String get enterYourName => 'Indtast dit navn';

  @override
  String get favorites => 'Favoritter';

  @override
  String get goToAlbum => 'Gå til album';

  @override
  String get goToArtist => 'Gå til kunstner';

  @override
  String get goToArtistRadio => 'Gå til kunstnerradio';

  @override
  String get goToPlaylist => 'Gå til playliste';

  @override
  String get goToSongRadio => 'Gå til sangradio';

  @override
  String get home => 'Hjem';

  @override
  String get myAwesomePlaylist => 'Min fantastiske playliste';

  @override
  String get myPlaylist => 'Min playliste';

  @override
  String get newPlaylist1 => 'Ny playliste';

  @override
  String get play => 'Afspil';

  @override
  String get playStation => 'Afspil station';

  @override
  String get playNext => 'Afspil næste';

  @override
  String get playlist => 'Playliste';

  @override
  String get playlistName => 'Playlistenavn';

  @override
  String get playlists1 => 'Playlister';

  @override
  String get queue1 => 'Kø';

  @override
  String get recentlyPlayed => 'Nyligt afspillet';

  @override
  String get removeFromQueue => 'Fjern fra kø';

  @override
  String get retry => 'Prøv igen';

  @override
  String get searchMusicArtistsAlbums => 'Søg efter musik, kunstnere, album...';

  @override
  String get share => 'Del';

  @override
  String featuringArtist(String artistName) {
    return 'MED $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Nuværende: $country';
  }

  @override
  String get queueTooltip => 'Kø';

  @override
  String get searchHint => 'Søg efter musik, kunstnere, album...';

  @override
  String get language => 'Sprog';

  @override
  String get systemDefault => 'Systemstandard';
}
