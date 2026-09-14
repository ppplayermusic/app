// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMID';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTID';

  @override
  String get artwork => 'KAANEPILT';

  @override
  String get appVersion => 'Rakenduse versioon';

  @override
  String get artist => 'Artist';

  @override
  String get artistsYouFollow => 'Artistid, keda jälgite';

  @override
  String get autoplay => 'Automaatne esitus';

  @override
  String get becauseYouListenedTo => 'Sest te kuulasite';

  @override
  String get browseAll => 'Sirvi kõiki';

  @override
  String get cancel => 'Tühista';

  @override
  String get clearAppCache => 'Tühjenda rakenduse vahemälu?';

  @override
  String get clearCache => 'Tühjenda vahemälu';

  @override
  String get clearHistory => 'Tühjenda ajalugu?';

  @override
  String get clearRecentlyPlayed => 'Tühjenda hiljuti mängitud';

  @override
  String get contentMarket => 'Sisuturg';

  @override
  String get continueListening => 'Jätka kuulamist';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Jätka video taasesitust väikeses aknas';

  @override
  String get create => 'Loo';

  @override
  String get createAPlaylistToGetStarted => 'Alustamiseks loo esitusloend';

  @override
  String currentSelectedcountry(Object country) {
    return 'Praegune: $country';
  }

  @override
  String get deletePlaylist => 'Kustuta esitusloend';

  @override
  String get editProfile => 'Muuda profiili';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Viga turgude laadimisel: $err';
  }

  @override
  String error(Object error) {
    return 'Viga: $error';
  }

  @override
  String explore(Object genre) {
    return 'Avasta $genre';
  }

  @override
  String get fansAlsoLike => 'FÄNNIDELE MEELDIB KA';

  @override
  String featuringTouppercase(Object artist) {
    return 'KAASATEGEV $artist';
  }

  @override
  String get featuredPlaylists => 'Esiletõstetud esitusloendid';

  @override
  String get followArtistsToSeeThemHere => 'Jälgi artiste, et näha neid siin';

  @override
  String get followStationsToSeeThemHere => 'Jälgi jaamu, et näha neid siin';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Sunni ainult heli voogesitus andmete säästmiseks';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Vabastab ruumi ja laeb uued andmed';

  @override
  String get fromYourFavorites => 'Sinu lemmikutest';

  @override
  String get goBack => 'Mine tagasi';

  @override
  String inspiredByName(Object name) {
    return 'Inspireeritud artistist $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Jätka sarnaste lugude mängimist, kui järjekord lõppeb';

  @override
  String get library => 'Raamatukogu';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Pane albumitele meeldib, et näha neid siin';

  @override
  String get likedSongs => 'Meeldinud lood';

  @override
  String get lowDataMode => 'Madala andmeside režiim';

  @override
  String get madeForYou => 'Teile tehtud';

  @override
  String moreLikeName(Object name) {
    return 'Rohkem nagu $name';
  }

  @override
  String get moreOptions => 'Rohkem valikuid';

  @override
  String get nameYourMasterpiece => 'Nime oma meistriteos...';

  @override
  String get newPlaylist => 'Uus esitusloend';

  @override
  String get newReleases => 'Uued väljalasked';

  @override
  String get next => 'Järgmine';

  @override
  String get noAlbumsFound => 'Albumeid ei leitud';

  @override
  String get noArtistsFollowed => 'Artiste ei jälgita';

  @override
  String get noArtistsFound => 'Artiste ei leitud';

  @override
  String get noLikedAlbums => 'Meeldinud albumeid pole';

  @override
  String get noPlaylistsFound => 'Esitusloendeid ei leitud';

  @override
  String get noPlaylistsYet => 'Esitusloendeid veel pole';

  @override
  String get noResultsFound => 'Tulemusi ei leitud';

  @override
  String get noStationsFollowed => 'Jaamu ei jälgita';

  @override
  String get noTrackPlaying => 'Ühtegi lugu ei mängi';

  @override
  String get noTracksFound => 'Lugusid ei leitud';

  @override
  String get playlists => 'ESITUSLOENDID';

  @override
  String get popular => 'POPULAARNE';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Eemalda kuulamisajalugu jäädavalt';

  @override
  String get pictureinpicturePip => 'Pilt pildis (PiP)';

  @override
  String get popularAlbums => 'Populaarsed albumid';

  @override
  String get popularArtists => 'Populaarsed artistid';

  @override
  String get popularGenres => 'Populaarsed žanrid';

  @override
  String get popularSongs => 'Populaarsed lood';

  @override
  String get popularTracks => 'Populaarsed lood';

  @override
  String get popularHitsRightNow => 'Populaarsed hitid praegu';

  @override
  String get previous => 'Eelmine';

  @override
  String get queue => 'JÄRJEKORD';

  @override
  String get recentSearches => 'Hiljutised otsingud';

  @override
  String get recommendedForYou => 'Sulle soovitatud';

  @override
  String get scraping => 'Andmete hankimine';

  @override
  String get search => 'Otsi';

  @override
  String get searchInAlbum => 'Otsi albumist...';

  @override
  String get searchInLibrary => 'Otsi raamatukogust...';

  @override
  String get searchInPlaylist => 'Otsi esitusloendist';

  @override
  String get searchLikedSongs => 'Otsi meeldinud lugudest...';

  @override
  String get searchPopularSongs => 'Otsi populaarseid lugusid...';

  @override
  String get selectMarket => 'Vali turg';

  @override
  String get settings => 'Seaded';

  @override
  String get showVideoPlayer => 'Näita videopleierit';

  @override
  String get shuffle => 'Juhuslik';

  @override
  String get spotifyCredentials => 'Spotify mandaadid';

  @override
  String get suggestedStations => 'Soovitatud jaamad';

  @override
  String get tracks => 'LOOD';

  @override
  String get trending => 'Trendikas';

  @override
  String get tryAgain => 'Proovi uuesti';

  @override
  String get tryADifferentSearchTerm => 'Proovige teist otsinguterminit';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Kasuta YouTube\'i mängijat, kui see on saadaval';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Mida te soovite kuulata?';

  @override
  String get youtubeCredentials => 'YouTube\'i mandaadid';

  @override
  String get yourLibrary => 'Teie raamatukogu';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Lisa esitusloendisse';

  @override
  String get addToQueue => 'Lisa järjekorda';

  @override
  String get copyId => 'Kopeeri ID';

  @override
  String get copyLink => 'Kopeeri link';

  @override
  String get discover => 'Avasta';

  @override
  String get enterYourName => 'Sisesta oma nimi';

  @override
  String get favorites => 'Lemmikud';

  @override
  String get goToAlbum => 'Mine albumisse';

  @override
  String get goToArtist => 'Mine artisti juurde';

  @override
  String get goToArtistRadio => 'Mine artisti raadiosse';

  @override
  String get goToPlaylist => 'Mine esitusloendisse';

  @override
  String get goToSongRadio => 'Mine loo raadiosse';

  @override
  String get home => 'Avaleht';

  @override
  String get myAwesomePlaylist => 'Minu äge esitusloend';

  @override
  String get myPlaylist => 'Minu esitusloend';

  @override
  String get newPlaylist1 => 'Uus esitusloend';

  @override
  String get play => 'Mängi';

  @override
  String get playStation => 'Mängi jaama';

  @override
  String get playNext => 'Mängi järgmisena';

  @override
  String get playlist => 'Esitusloend';

  @override
  String get playlistName => 'Esitusloendi nimi';

  @override
  String get playlists1 => 'Esitusloendid';

  @override
  String get queue1 => 'Järjekord';

  @override
  String get recentlyPlayed => 'Hiljuti mängitud';

  @override
  String get removeFromQueue => 'Eemalda järjekorrast';

  @override
  String get retry => 'Proovi uuesti';

  @override
  String get searchMusicArtistsAlbums => 'Otsi muusikat, artiste, albumeid...';

  @override
  String get share => 'Jaga';

  @override
  String featuringArtist(String artistName) {
    return 'KAASATEGEV $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Praegune: $country';
  }

  @override
  String get queueTooltip => 'Järjekord';

  @override
  String get searchHint => 'Otsi muusikat, artiste, albumeid...';

  @override
  String get language => 'Keel';

  @override
  String get systemDefault => 'Süsteemi vaikeväärtus';

  @override
  String get songsTab => 'Songs';

  @override
  String get foldersTab => 'Folders';

  @override
  String get artistsTab => 'Artists';

  @override
  String get albumsTab => 'Albums';

  @override
  String get addMusic => 'Add music';

  @override
  String get addFiles => 'Add files';

  @override
  String get addFolder => 'Add folder';

  @override
  String get rescanLibrary => 'Rescan library';

  @override
  String get sortTitle => 'Title';

  @override
  String get sortArtist => 'Artist';

  @override
  String get sortAlbum => 'Album';

  @override
  String get sortDuration => 'Duration';

  @override
  String get sortDateAdded => 'Date Added';

  @override
  String get trackInformation => 'Track Information';

  @override
  String get removeFromLibrary => 'Remove from library';

  @override
  String get showInFolder => 'Show in folder';

  @override
  String get unknownArtist => 'Unknown Artist';

  @override
  String get unknownAlbum => 'Unknown Album';

  @override
  String get importedFiles => 'Imported Files';

  @override
  String get playFolder => 'Play folder';

  @override
  String get shuffleFolder => 'Shuffle folder';

  @override
  String get playAll => 'Play all';

  @override
  String get includeSubfolders => 'Include subfolders';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '1 track',
      zero: '0 tracks',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'No local songs imported';

  @override
  String get searchLocalMusic => 'Search local music';

  @override
  String get viewAsList => 'View as list';

  @override
  String get viewAsGrid => 'View as grid';

  @override
  String get trackInfoPath => 'Path';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Duration';
}
