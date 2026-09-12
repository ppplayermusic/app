// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

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
  String get artists => 'ARTISTER';

  @override
  String get artwork => 'SKIVOMSLAG';

  @override
  String get appVersion => 'App-version';

  @override
  String get artist => 'Artist';

  @override
  String get artistsYouFollow => 'Artister du följer';

  @override
  String get autoplay => 'Spela upp automatiskt';

  @override
  String get becauseYouListenedTo => 'Eftersom du lyssnade på';

  @override
  String get browseAll => 'Bläddra bland alla';

  @override
  String get cancel => 'Avbryt';

  @override
  String get clearAppCache => 'Rensa appcache?';

  @override
  String get clearCache => 'Rensa cache';

  @override
  String get clearHistory => 'Rensa historik?';

  @override
  String get clearRecentlyPlayed => 'Rensa nyligen spelade';

  @override
  String get contentMarket => 'Innehållsmarknad';

  @override
  String get continueListening => 'Fortsätt lyssna';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Fortsätt videouppspelning i ett litet fönster';

  @override
  String get create => 'Skapa';

  @override
  String get createAPlaylistToGetStarted =>
      'Skapa en spellista för att komma igång';

  @override
  String currentSelectedcountry(Object country) {
    return 'Nuvarande: $country';
  }

  @override
  String get deletePlaylist => 'Ta bort spellista';

  @override
  String get editProfile => 'Redigera profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Fel vid inläsning av marknader: $err';
  }

  @override
  String error(Object error) {
    return 'Fel: $error';
  }

  @override
  String explore(Object genre) {
    return 'Utforska $genre';
  }

  @override
  String get fansAlsoLike => 'FANS GILLAR OCKSÅ';

  @override
  String featuringTouppercase(Object artist) {
    return 'MED $artist';
  }

  @override
  String get featuredPlaylists => 'Utvalda spellistor';

  @override
  String get followArtistsToSeeThemHere => 'Följ artister för att se dem här';

  @override
  String get followStationsToSeeThemHere => 'Följ stationer för att se dem här';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Tvinga endast ljud-strömmar för att spara data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Frigör utrymme och tvingar fram ny data vid nästa inläsning';

  @override
  String get fromYourFavorites => 'Från dina favoriter';

  @override
  String get goBack => 'Gå tillbaka';

  @override
  String inspiredByName(Object name) {
    return 'Inspirerad av $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Fortsätt spela liknande spår när kön tar slut';

  @override
  String get library => 'Bibliotek';

  @override
  String get likeAlbumsToSeeThemHere => 'Gilla album för att se dem här';

  @override
  String get likedSongs => 'Gillade låtar';

  @override
  String get lowDataMode => 'Låg dataförbrukning';

  @override
  String get madeForYou => 'Skapad för dig';

  @override
  String moreLikeName(Object name) {
    return 'Mer som $name';
  }

  @override
  String get moreOptions => 'Fler alternativ';

  @override
  String get nameYourMasterpiece => 'Namnge ditt mästerverk...';

  @override
  String get newPlaylist => 'Ny spellista';

  @override
  String get newReleases => 'Nya releaser';

  @override
  String get next => 'Nästa';

  @override
  String get noAlbumsFound => 'Inga album hittades';

  @override
  String get noArtistsFollowed => 'Inga artister följs';

  @override
  String get noArtistsFound => 'Inga artister hittades';

  @override
  String get noLikedAlbums => 'Inga gillade album';

  @override
  String get noPlaylistsFound => 'Inga spellistor hittades';

  @override
  String get noPlaylistsYet => 'Inga spellistor ännu';

  @override
  String get noResultsFound => 'Inga resultat hittades';

  @override
  String get noStationsFollowed => 'Inga stationer följs';

  @override
  String get noTrackPlaying => 'Inget spår spelas upp';

  @override
  String get noTracksFound => 'Inga spår hittades';

  @override
  String get playlists => 'SPELLISTOR';

  @override
  String get popular => 'POPULÄRA';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Ta bort lyssningshistorik permanent';

  @override
  String get pictureinpicturePip => 'Bild-i-bild (PiP)';

  @override
  String get popularAlbums => 'Populära album';

  @override
  String get popularArtists => 'Populära artister';

  @override
  String get popularGenres => 'Populära genrer';

  @override
  String get popularSongs => 'Populära låtar';

  @override
  String get popularTracks => 'Populära spår';

  @override
  String get popularHitsRightNow => 'Populära hits just nu';

  @override
  String get previous => 'Föregående';

  @override
  String get queue => 'KÖ';

  @override
  String get recentSearches => 'Senaste sökningar';

  @override
  String get recommendedForYou => 'Rekommenderas för dig';

  @override
  String get scraping => 'Hämtar';

  @override
  String get search => 'Sök';

  @override
  String get searchInAlbum => 'Sök i album...';

  @override
  String get searchInLibrary => 'Sök i biblioteket...';

  @override
  String get searchInPlaylist => 'Sök i spellistan';

  @override
  String get searchLikedSongs => 'Sök bland gillade låtar...';

  @override
  String get searchPopularSongs => 'Sök populära låtar...';

  @override
  String get selectMarket => 'Välj marknad';

  @override
  String get settings => 'Inställningar';

  @override
  String get showVideoPlayer => 'Visa videospelare';

  @override
  String get shuffle => 'Blanda';

  @override
  String get spotifyCredentials => 'Spotify-uppgifter';

  @override
  String get suggestedStations => 'Föreslagna stationer';

  @override
  String get tracks => 'SPÅR';

  @override
  String get trending => 'Trender';

  @override
  String get tryAgain => 'Försök igen';

  @override
  String get tryADifferentSearchTerm => 'Försök med en annan sökterm';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Använd YouTube-spelaren när den är tillgänglig';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Vad vill du lyssna på?';

  @override
  String get youtubeCredentials => 'YouTube-uppgifter';

  @override
  String get yourLibrary => 'Ditt bibliotek';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Lägg till i spellista';

  @override
  String get addToQueue => 'Lägg till i kö';

  @override
  String get copyId => 'Kopiera ID';

  @override
  String get copyLink => 'Kopiera länk';

  @override
  String get discover => 'Upptäck';

  @override
  String get enterYourName => 'Ange ditt namn';

  @override
  String get favorites => 'Favoriter';

  @override
  String get goToAlbum => 'Gå till album';

  @override
  String get goToArtist => 'Gå till artist';

  @override
  String get goToArtistRadio => 'Gå till artistradio';

  @override
  String get goToPlaylist => 'Gå till spellista';

  @override
  String get goToSongRadio => 'Gå till låtradio';

  @override
  String get home => 'Hem';

  @override
  String get myAwesomePlaylist => 'Min grymma spellista';

  @override
  String get myPlaylist => 'Min spellista';

  @override
  String get newPlaylist1 => 'Ny spellista';

  @override
  String get play => 'Spela';

  @override
  String get playStation => 'Spela station';

  @override
  String get playNext => 'Spela nästa';

  @override
  String get playlist => 'Spellista';

  @override
  String get playlistName => 'Spellistans namn';

  @override
  String get playlists1 => 'Spellistor';

  @override
  String get queue1 => 'Kö';

  @override
  String get recentlyPlayed => 'Nyligen spelade';

  @override
  String get removeFromQueue => 'Ta bort från kö';

  @override
  String get retry => 'Försök igen';

  @override
  String get searchMusicArtistsAlbums => 'Sök efter musik, artister, album...';

  @override
  String get share => 'Dela';

  @override
  String featuringArtist(String artistName) {
    return 'MED $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Nuvarande: $country';
  }

  @override
  String get queueTooltip => 'Kö';

  @override
  String get searchHint => 'Sök efter musik, artister, album...';

  @override
  String get language => 'Språk';

  @override
  String get systemDefault => 'Systemstandard';
}
