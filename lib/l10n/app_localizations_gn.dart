// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Guarani (`gn`).
class AppLocalizationsGn extends AppLocalizations {
  AppLocalizationsGn([String locale = 'gn']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMKUÉRA';

  @override
  String get api => 'API';

  @override
  String get artists => 'PURAHEIHÁRAKUÉRA';

  @override
  String get artwork => 'IMAGEN';

  @override
  String get appVersion => 'Tembiaporã versión';

  @override
  String get artist => 'Puraheihára';

  @override
  String get artistsYouFollow => 'Puraheihára rehesa\'ỹjóva';

  @override
  String get autoplay => 'Mbopu Pochy\'ỹre';

  @override
  String get becauseYouListenedTo => 'Ehendu va\'erã';

  @override
  String get browseAll => 'Ehecha Paite';

  @override
  String get cancel => 'Mbotove';

  @override
  String get clearAppCache => 'Embogue Tembiaporã Caché?';

  @override
  String get clearCache => 'Embogue Caché';

  @override
  String get clearHistory => 'Embogue Tembiasakue?';

  @override
  String get clearRecentlyPlayed => 'Embogue Oñembopu Va\'ekue';

  @override
  String get contentMarket => 'Tembiporu Ñorairõ';

  @override
  String get continueListening => 'Eheñói Ehendu Hag̃ua';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Eheñói mbopu marandupy\'a michĩva-pe';

  @override
  String get create => 'Moñepyrũ';

  @override
  String get createAPlaylistToGetStarted => 'Emoñepyrũ tysýi ñepyrũ hag̃ua';

  @override
  String currentSelectedcountry(Object country) {
    return 'Ko\'ág̃a: $country';
  }

  @override
  String get deletePlaylist => 'Mboguete Tysýi';

  @override
  String get editProfile => 'Moambue Perfil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Javy oikuaa hag̃ua ñorairõ: $err';
  }

  @override
  String error(Object error) {
    return 'Javy: $error';
  }

  @override
  String explore(Object genre) {
    return 'Eikutu $genre';
  }

  @override
  String get fansAlsoLike => 'PURAHEIVÝVA OIPOTÁVA';

  @override
  String featuringTouppercase(Object artist) {
    return 'NDIVE $artist';
  }

  @override
  String get featuredPlaylists => 'Tysýi Ombojerapykuéva';

  @override
  String get followArtistsToSeeThemHere =>
      'Resa\'ỹjo puraheihára ehecha hag̃ua ko\'ápe';

  @override
  String get followStationsToSeeThemHere =>
      'Resa\'ỹjo emisoras ehecha hag̃ua ko\'ápe';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Mboipota audio-nte roinjévo datos monguerekohápe';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Embogue tenda ha moĩ datos pyahu oúvo';

  @override
  String get fromYourFavorites => 'Ne rembipotágui';

  @override
  String get goBack => 'Ei Tapykuépe';

  @override
  String inspiredByName(Object name) {
    return 'Inspirado $name ndive';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Eheñói mbopu pumbasy ojepaháramo tysýi';

  @override
  String get library => 'Ñemongeta';

  @override
  String get likeAlbumsToSeeThemHere => 'Eipota album ehecha hag̃ua ko\'ápe';

  @override
  String get likedSongs => 'Pumbasy Rembipota';

  @override
  String get lowDataMode => 'Datos Michĩ Modo';

  @override
  String get madeForYou => 'Ojejapo Ndéve';

  @override
  String moreLikeName(Object name) {
    return 'Oñemejãva $name';
  }

  @override
  String get moreOptions => 'Ambuéva tembiapokáva';

  @override
  String get nameYourMasterpiece => 'Eme\'ẽ réra ne mba\'e porãve...';

  @override
  String get newPlaylist => 'Tysýi Pyahu';

  @override
  String get newReleases => 'Oñemomba\'e Pyahu';

  @override
  String get next => 'Oúva';

  @override
  String get noAlbumsFound => 'Ndojejuhúi albumkuéra';

  @override
  String get noArtistsFollowed => 'Ndaipóri puraheihára rehesa\'ỹjóva';

  @override
  String get noArtistsFound => 'Ndojejuhúi puraheihára';

  @override
  String get noLikedAlbums => 'Ndaipóri album reipotáva';

  @override
  String get noPlaylistsFound => 'Ndojejuhúi tysýikuéra';

  @override
  String get noPlaylistsYet => 'Ndaipóri tysýi gueteri';

  @override
  String get noResultsFound => 'Ndojejuhúi mba\'eve';

  @override
  String get noStationsFollowed => 'Ndaipóri emisoras rehesa\'ỹjóva';

  @override
  String get noTrackPlaying => 'Ndaipóri pumbasy oñembopúva';

  @override
  String get noTracksFound => 'Ndojejuhúi pumbasykuéra';

  @override
  String get playlists => 'TYSÝIKUÉRA';

  @override
  String get popular => 'OJEPOUKAÁVA';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Mboguete mba\'eve tembiasakue ehendu va\'ekuégui';

  @override
  String get pictureinpicturePip => 'Imagen imagen-pe (PiP)';

  @override
  String get popularAlbums => 'Albumkuéra Ojepoukaáva';

  @override
  String get popularArtists => 'Puraheihárakuéra Ojepoukaáva';

  @override
  String get popularGenres => 'Géneros Ojepoukaáva';

  @override
  String get popularSongs => 'Pumbasykuéra Ojepoukaáva';

  @override
  String get popularTracks => 'Pumbasykuéra Ojepoukaáva';

  @override
  String get popularHitsRightNow => 'Hits Ojepoukaáva Ko\'ág̃a';

  @override
  String get previous => 'Tapykuégui';

  @override
  String get queue => 'TYSÝI';

  @override
  String get recentSearches => 'Ehekatéva';

  @override
  String get recommendedForYou => 'Rohechaukáva Ndéve';

  @override
  String get scraping => 'Oñembyaty Datos';

  @override
  String get search => 'Eheka';

  @override
  String get searchInAlbum => 'Eheka albumpe...';

  @override
  String get searchInLibrary => 'Eheka ñemongeta-pe...';

  @override
  String get searchInPlaylist => 'Eheka tysýipe';

  @override
  String get searchLikedSongs => 'Eheka pumbasy reipotáva...';

  @override
  String get searchPopularSongs => 'Eheka pumbasykuéra ojepoukaáva...';

  @override
  String get selectMarket => 'Eiporavo Ñorairõ';

  @override
  String get settings => 'Tembiporu';

  @override
  String get showVideoPlayer => 'Ehecha Marandupy\'a';

  @override
  String get shuffle => 'Ñemoheñói';

  @override
  String get spotifyCredentials => 'Spotify Credenciales';

  @override
  String get suggestedStations => 'Emisoras Rojapurahéiva';

  @override
  String get tracks => 'PUMBASYKUÉRA';

  @override
  String get trending => 'Ojepoukaáva';

  @override
  String get tryAgain => 'Ejejapo Jey';

  @override
  String get tryADifferentSearchTerm => 'Eikotevẽ ambuéva reheka hag̃ua';

  @override
  String get useYoutubePlayerWhenAvailable => 'Eiporu YouTube Player oĩramo';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Mba\'étapa rehendu potáva?';

  @override
  String get youtubeCredentials => 'YouTube Credenciales';

  @override
  String get yourLibrary => 'Ne Ñemongeta';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Moĩ Tysýipe';

  @override
  String get addToQueue => 'Moĩ Tysýipe Espera';

  @override
  String get copyId => 'Kopia ID';

  @override
  String get copyLink => 'Kopia Ñandutiresẽ';

  @override
  String get discover => 'Ejuhu';

  @override
  String get enterYourName => 'Emoinge nde réra';

  @override
  String get favorites => 'Ne Rembipota';

  @override
  String get goToAlbum => 'E\'u albumpe';

  @override
  String get goToArtist => 'E\'u puraheihárape';

  @override
  String get goToArtistRadio => 'E\'u puraheihára radiope';

  @override
  String get goToPlaylist => 'E\'u tysýipe';

  @override
  String get goToSongRadio => 'E\'u pumbasy radiope';

  @override
  String get home => 'Óga';

  @override
  String get myAwesomePlaylist => 'Che Tysýi Porã';

  @override
  String get myPlaylist => 'Che Tysýi';

  @override
  String get newPlaylist1 => 'Tysýi Pyahu';

  @override
  String get play => 'Mbopu';

  @override
  String get playStation => 'Mbopu Emisora';

  @override
  String get playNext => 'Mbopu Oúva';

  @override
  String get playlist => 'Tysýi';

  @override
  String get playlistName => 'Réra Tysýi';

  @override
  String get playlists1 => 'Tysýikuéra';

  @override
  String get queue1 => 'Tysýi';

  @override
  String get recentlyPlayed => 'Oñembopu Va\'ekue';

  @override
  String get removeFromQueue => 'Mboguete Tysýigui';

  @override
  String get retry => 'Ejejapo Jey';

  @override
  String get searchMusicArtistsAlbums =>
      'Eheka pumbasy, puraheihára, albumkuéra...';

  @override
  String get share => 'Mombe\'u';

  @override
  String featuringArtist(String artistName) {
    return 'NDIVE $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Ko\'ág̃a: $country';
  }

  @override
  String get queueTooltip => 'Tysýi';

  @override
  String get searchHint => 'Eheka pumbasy, puraheihára, albumkuéra...';

  @override
  String get language => 'Ñe\'ẽ';

  @override
  String get systemDefault => 'Sistema Régagua';
}
