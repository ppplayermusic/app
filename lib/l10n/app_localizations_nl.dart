// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMS';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTIESTEN';

  @override
  String get artwork => 'ARTWORK';

  @override
  String get appVersion => 'App-versie';

  @override
  String get artist => 'Artiest';

  @override
  String get artistsYouFollow => 'Artiesten die je volgt';

  @override
  String get autoplay => 'Automatisch afspelen';

  @override
  String get becauseYouListenedTo => 'Omdat je geluisterd hebt naar';

  @override
  String get browseAll => 'Alles bladeren';

  @override
  String get cancel => 'Annuleren';

  @override
  String get clearAppCache => 'App-cache wissen?';

  @override
  String get clearCache => 'Cache wissen';

  @override
  String get clearHistory => 'Geschiedenis wissen?';

  @override
  String get clearRecentlyPlayed => 'Recent afgespeeld wissen';

  @override
  String get contentMarket => 'Contentmarkt';

  @override
  String get continueListening => 'Verder luisteren';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Videoweergave hervatten in een klein venster';

  @override
  String get create => 'Maken';

  @override
  String get createAPlaylistToGetStarted =>
      'Maak een afspeellijst om te beginnen';

  @override
  String currentSelectedcountry(Object country) {
    return 'Huidig: $country';
  }

  @override
  String get deletePlaylist => 'Afspeellijst verwijderen';

  @override
  String get editProfile => 'Profiel bewerken';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Fout bij laden markten: $err';
  }

  @override
  String error(Object error) {
    return 'Fout: $error';
  }

  @override
  String explore(Object genre) {
    return 'Ontdekken $genre';
  }

  @override
  String get fansAlsoLike => 'FANS VINDEN DIT OOK LEUK';

  @override
  String featuringTouppercase(Object artist) {
    return 'MET $artist';
  }

  @override
  String get featuredPlaylists => 'Aanbevolen afspeellijsten';

  @override
  String get followArtistsToSeeThemHere => 'Volg artiesten om ze hier te zien';

  @override
  String get followStationsToSeeThemHere => 'Volg stations om ze hier te zien';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forceer alleen-audio streams om data te besparen';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Maakt ruimte vrij en forceert verse data bij volgende keer laden';

  @override
  String get fromYourFavorites => 'Uit je favorieten';

  @override
  String get goBack => 'Ga terug';

  @override
  String inspiredByName(Object name) {
    return 'Geïnspireerd door $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Blijf vergelijkbare nummers afspelen als de wachtrij eindigt';

  @override
  String get library => 'Bibliotheek';

  @override
  String get likeAlbumsToSeeThemHere => 'Vind albums leuk om ze hier te zien';

  @override
  String get likedSongs => 'Gelikete nummers';

  @override
  String get lowDataMode => 'Datareductiemodus';

  @override
  String get madeForYou => 'Gemaakt voor jou';

  @override
  String moreLikeName(Object name) {
    return 'Meer zoals $name';
  }

  @override
  String get moreOptions => 'Meer opties';

  @override
  String get nameYourMasterpiece => 'Geef je meesterwerk een naam...';

  @override
  String get newPlaylist => 'Nieuwe afspeellijst';

  @override
  String get newReleases => 'Nieuwe releases';

  @override
  String get next => 'Volgende';

  @override
  String get noAlbumsFound => 'Geen albums gevonden';

  @override
  String get noArtistsFollowed => 'Geen artiesten gevolgd';

  @override
  String get noArtistsFound => 'Geen artiesten gevonden';

  @override
  String get noLikedAlbums => 'Geen gelikete albums';

  @override
  String get noPlaylistsFound => 'Geen afspeellijsten gevonden';

  @override
  String get noPlaylistsYet => 'Nog geen afspeellijsten';

  @override
  String get noResultsFound => 'Geen resultaten gevonden';

  @override
  String get noStationsFollowed => 'Geen stations gevolgd';

  @override
  String get noTrackPlaying => 'Geen nummer aan het afspelen';

  @override
  String get noTracksFound => 'Geen nummers gevonden';

  @override
  String get playlists => 'AFSPEELLIJSTEN';

  @override
  String get popular => 'POPULAIR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Luistergeschiedenis permanent verwijderen';

  @override
  String get pictureinpicturePip => 'Beeld-in-beeld (PiP)';

  @override
  String get popularAlbums => 'Populaire albums';

  @override
  String get popularArtists => 'Populaire artiesten';

  @override
  String get popularGenres => 'Populaire genres';

  @override
  String get popularSongs => 'Populaire nummers';

  @override
  String get popularTracks => 'Populaire nummers';

  @override
  String get popularHitsRightNow => 'Populaire hits van nu';

  @override
  String get previous => 'Vorige';

  @override
  String get queue => 'WACHTRIJ';

  @override
  String get recentSearches => 'Recente zoekopdrachten';

  @override
  String get recommendedForYou => 'Aanbevolen voor jou';

  @override
  String get scraping => 'Gegevens verzamelen';

  @override
  String get search => 'Zoeken';

  @override
  String get searchInAlbum => 'Zoeken in album...';

  @override
  String get searchInLibrary => 'Zoeken in bibliotheek...';

  @override
  String get searchInPlaylist => 'Zoeken in afspeellijst';

  @override
  String get searchLikedSongs => 'Zoek gelikete nummers...';

  @override
  String get searchPopularSongs => 'Zoek populaire nummers...';

  @override
  String get selectMarket => 'Selecteer markt';

  @override
  String get settings => 'Instellingen';

  @override
  String get showVideoPlayer => 'Toon videospeler';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get spotifyCredentials => 'Spotify-inloggegevens';

  @override
  String get suggestedStations => 'Voorgestelde stations';

  @override
  String get tracks => 'NUMMERS';

  @override
  String get trending => 'Trending';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get tryADifferentSearchTerm => 'Probeer een andere zoekterm';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Gebruik YouTube-speler indien beschikbaar';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Waar wil je naar luisteren?';

  @override
  String get youtubeCredentials => 'YouTube-inloggegevens';

  @override
  String get yourLibrary => 'Jouw bibliotheek';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Toevoegen aan afspeellijst';

  @override
  String get addToQueue => 'Aan wachtrij toevoegen';

  @override
  String get copyId => 'ID kopiëren';

  @override
  String get copyLink => 'Link kopiëren';

  @override
  String get discover => 'Ontdekken';

  @override
  String get enterYourName => 'Vul je naam in';

  @override
  String get favorites => 'Favorieten';

  @override
  String get goToAlbum => 'Ga naar album';

  @override
  String get goToArtist => 'Ga naar artiest';

  @override
  String get goToArtistRadio => 'Ga naar artiestenradio';

  @override
  String get goToPlaylist => 'Ga naar afspeellijst';

  @override
  String get goToSongRadio => 'Ga naar nummerradio';

  @override
  String get home => 'Home';

  @override
  String get myAwesomePlaylist => 'Mijn Geweldige Afspeellijst';

  @override
  String get myPlaylist => 'Mijn Afspeellijst';

  @override
  String get newPlaylist1 => 'Nieuwe afspeellijst';

  @override
  String get play => 'Afspelen';

  @override
  String get playStation => 'Station afspelen';

  @override
  String get playNext => 'Volgende afspelen';

  @override
  String get playlist => 'Afspeellijst';

  @override
  String get playlistName => 'Naam afspeellijst';

  @override
  String get playlists1 => 'Afspeellijsten';

  @override
  String get queue1 => 'Wachtrij';

  @override
  String get recentlyPlayed => 'Recent afgespeeld';

  @override
  String get removeFromQueue => 'Verwijderen uit wachtrij';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get searchMusicArtistsAlbums => 'Zoek muziek, artiesten, albums...';

  @override
  String get share => 'Delen';

  @override
  String featuringArtist(String artistName) {
    return 'MET $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Huidig: $country';
  }

  @override
  String get queueTooltip => 'Wachtrij';

  @override
  String get searchHint => 'Zoek muziek, artiesten, albums...';

  @override
  String get language => 'Taal';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String get songsTab => 'Nummers';

  @override
  String get foldersTab => 'Mappen';

  @override
  String get artistsTab => 'Artiesten';

  @override
  String get albumsTab => 'Albums';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'Geen genres gevonden';

  @override
  String get playbackSpeed => 'Afspeelsnelheid';

  @override
  String get addMusic => 'Muziek toevoegen';

  @override
  String get addFiles => 'Bestanden toevoegen';

  @override
  String get addFolder => 'Map toevoegen';

  @override
  String get rescanLibrary => 'Bibliotheek opnieuw scannen';

  @override
  String get sortTitle => 'Titel';

  @override
  String get sortArtist => 'Artiest';

  @override
  String get sortAlbum => 'Album';

  @override
  String get sortDuration => 'Duur';

  @override
  String get sortDateAdded => 'Datum toegevoegd';

  @override
  String get sortBy => 'Sorteren op';

  @override
  String get trackInformation => 'Nummerinformatie';

  @override
  String get removeFromLibrary => 'Verwijderen uit bibliotheek';

  @override
  String get showInFolder => 'Toon in map';

  @override
  String get unknownArtist => 'Onbekende artiest';

  @override
  String get unknownAlbum => 'Onbekend album';

  @override
  String get importedFiles => 'Geïmporteerde bestanden';

  @override
  String get playFolder => 'Map afspelen';

  @override
  String get shuffleFolder => 'Map shufflen';

  @override
  String get playAll => 'Alles afspelen';

  @override
  String get includeSubfolders => 'Submappen opnemen';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
      zero: '0 nummers',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Geen lokale nummers geïmporteerd';

  @override
  String get searchLocalMusic => 'Lokaal zoeken';

  @override
  String get viewAsList => 'Weergeven als lijst';

  @override
  String get viewAsGrid => 'Weergeven als raster';

  @override
  String get trackInfoPath => 'Pad';

  @override
  String get trackInfoFormat => 'Formaat';

  @override
  String get trackInfoDuration => 'Duur';

  @override
  String get aboutDescription => 'Een gratis open-source mediaspeler.';

  @override
  String get aboutApp => 'Over PPPlayer';

  @override
  String get appTagline => 'Jouw muziek. Jouw manier.';

  @override
  String get exploreApp => 'Ontdek PPPlayer';

  @override
  String get viewSource => 'Bekijk broncode';

  @override
  String get seeWhatsNew => 'Bekijk wat er nieuw is';

  @override
  String get getHelp => 'Krijg hulp';

  @override
  String versionInfo(Object version, Object build) {
    return 'Versie $version (Build $build)';
  }

  @override
  String get createdBy => 'Gemaakt door Lucas Coelho';

  @override
  String get website => 'Website';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Release-opmerkingen';

  @override
  String get support => 'Ondersteuning';

  @override
  String get license => 'Licentie';

  @override
  String get acknowledgments => 'Dankbetuigingen';

  @override
  String get close => 'Sluiten';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer medewerkers';
  }

  @override
  String get goodMorning => 'Goedemorgen';

  @override
  String get goodAfternoon => 'Goedemiddag';

  @override
  String get goodEvening => 'Goedenavond';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Je muziek wacht op je.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Jouw favorieten\nen nieuwe ontdekkingen';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Nieuwe muziek\nspeciaal voor jou';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Ontspan en kom tot rust';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Diepe focus\nen productiviteit';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'Alles';

  @override
  String get filterPlaylists => 'Afspeellijsten';

  @override
  String get filterArtists => 'Artiesten';

  @override
  String get filterAlbums => 'Albums';

  @override
  String get filterStations => 'Stations';

  @override
  String get filterStreams => 'Streams';

  @override
  String get localMusicCard => 'Lokale muziek';

  @override
  String get createPlaylistButton => 'Afspeellijst Maken';

  @override
  String get radioStations => 'Radiostations';

  @override
  String get discoverMusic => 'Ontdek Muziek';

  @override
  String get importLocalMusic => 'Lokale muziek importeren';

  @override
  String get importAudioFiles => 'Audiobestanden importeren';

  @override
  String get importFolder => 'Map importeren';

  @override
  String get importFolderSubtitle =>
      'Let op: Audiobestanden zijn verborgen in de mapkiezer. Dit is normaal.';

  @override
  String get importPlaylist => 'Afspeellijst importeren';

  @override
  String get importPlaylistSubtitle => '.m3u of .m3u8 bestanden importeren';

  @override
  String get exportPlaylist => 'Afspeellijst exporteren';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Niet-ondersteund formaat of beschadigd bestand';

  @override
  String get playbackErrorFileInaccessible =>
      'Bestand niet toegankelijk of niet gevonden';

  @override
  String get localVideosCard => 'Lokale video\'s';

  @override
  String get noLocalVideos => 'Geen video\'s gevonden';

  @override
  String get searchLocalVideos => 'Zoeken in lokale video\'s';

  @override
  String get addVideos => 'Video\'s toevoegen';

  @override
  String get subtitles => 'Ondertiteling';

  @override
  String get audioTracks => 'Audiosporen';

  @override
  String get loadSubtitleFile => 'Ondertitelingsbestand laden...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Fout bij laden ondertiteling: $error';
  }

  @override
  String get off => 'Uit';
}
