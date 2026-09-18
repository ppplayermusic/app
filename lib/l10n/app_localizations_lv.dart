// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMI';

  @override
  String get api => 'API';

  @override
  String get artists => 'MĀKSLINIEKI';

  @override
  String get artwork => 'VĀKS';

  @override
  String get appVersion => 'Lietotnes versija';

  @override
  String get artist => 'Mākslinieks';

  @override
  String get artistsYouFollow => 'Mākslinieki, kurus sekojat';

  @override
  String get autoplay => 'Automātiskā atskaņošana';

  @override
  String get becauseYouListenedTo => 'Tāpēc, ka jūs klausījāties';

  @override
  String get browseAll => 'Skatīt visu';

  @override
  String get cancel => 'Atcelt';

  @override
  String get clearAppCache => 'Notīrīt lietotnes kešatmiņu?';

  @override
  String get clearCache => 'Notīrīt kešatmiņu';

  @override
  String get clearHistory => 'Notīrīt vēsturi?';

  @override
  String get clearRecentlyPlayed => 'Notīrīt nesen atskaņotos';

  @override
  String get contentMarket => 'Satura tirgus';

  @override
  String get continueListening => 'Turpināt klausīties';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Turpināt video atskaņošanu mazā logā';

  @override
  String get create => 'Izveidot';

  @override
  String get createAPlaylistToGetStarted =>
      'Izveidojiet atskaņošanas sarakstu, lai sāktu';

  @override
  String currentSelectedcountry(Object country) {
    return 'Pašreizējā: $country';
  }

  @override
  String get deletePlaylist => 'Dzēst atskaņošanas sarakstu';

  @override
  String get editProfile => 'Rediģēt profilu';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Kļūda ielādējot tirgus: $err';
  }

  @override
  String error(Object error) {
    return 'Kļūda: $error';
  }

  @override
  String explore(Object genre) {
    return 'Izpētīt $genre';
  }

  @override
  String get fansAlsoLike => 'FANIEM PATĪK ARĪ';

  @override
  String featuringTouppercase(Object artist) {
    return 'PIEDALĀS $artist';
  }

  @override
  String get featuredPlaylists => 'Ieteiktie atskaņošanas saraksti';

  @override
  String get followArtistsToSeeThemHere =>
      'Sekojiet māksliniekiem, lai redzētu tos šeit';

  @override
  String get followStationsToSeeThemHere =>
      'Sekojiet stacijām, lai redzētu tās šeit';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Piespiest tikai audio straumēšanu, lai taupītu datus';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Atbrīvo vietu un piespiež jaunus datus nākamajā ielādē';

  @override
  String get fromYourFavorites => 'No jūsu favorītiem';

  @override
  String get goBack => 'Atpakaļ';

  @override
  String inspiredByName(Object name) {
    return 'Iedvesmojies no $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Turpināt atskaņot līdzīgus ierakstus, kad rinda beidzas';

  @override
  String get library => 'Bibliotēka';

  @override
  String get likeAlbumsToSeeThemHere => 'Patīk albumi, lai redzētu tos šeit';

  @override
  String get likedSongs => 'Iecienītās dziesmas';

  @override
  String get lowDataMode => 'Zema datu režīms';

  @override
  String get madeForYou => 'Izveidots tev';

  @override
  String moreLikeName(Object name) {
    return 'Vairāk kā $name';
  }

  @override
  String get moreOptions => 'Vairāk iespēju';

  @override
  String get nameYourMasterpiece => 'Nosauciet savu šedevru...';

  @override
  String get newPlaylist => 'Jauns atskaņošanas saraksts';

  @override
  String get newReleases => 'Jaunākās izdošanas';

  @override
  String get next => 'Nākamais';

  @override
  String get noAlbumsFound => 'Nav atrasts neviens albums';

  @override
  String get noArtistsFollowed => 'Nav sekotu mākslinieku';

  @override
  String get noArtistsFound => 'Nav atrasts neviens mākslinieks';

  @override
  String get noLikedAlbums => 'Nav iecienītu albumu';

  @override
  String get noPlaylistsFound => 'Nav atrasti atskaņošanas saraksti';

  @override
  String get noPlaylistsYet => 'Vēl nav atskaņošanas sarakstu';

  @override
  String get noResultsFound => 'Nav atrasti rezultāti';

  @override
  String get noStationsFollowed => 'Nav sekotu staciju';

  @override
  String get noTrackPlaying => 'Netiek atskaņots neviens ieraksts';

  @override
  String get noTracksFound => 'Nav atrasti ieraksti';

  @override
  String get playlists => 'ATSKAŅOŠANAS SARAKSTI';

  @override
  String get popular => 'POPULĀRS';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Neatgriezeniski noņemt klausīšanās vēsturi';

  @override
  String get pictureinpicturePip => 'Attēls attēlā (PiP)';

  @override
  String get popularAlbums => 'Populāri albumi';

  @override
  String get popularArtists => 'Populāri mākslinieki';

  @override
  String get popularGenres => 'Populāri žanri';

  @override
  String get popularSongs => 'Populāras dziesmas';

  @override
  String get popularTracks => 'Populāri ieraksti';

  @override
  String get popularHitsRightNow => 'Populārie hiti šobrīd';

  @override
  String get previous => 'Iepriekšējais';

  @override
  String get queue => 'RINDA';

  @override
  String get recentSearches => 'Pēdējie meklējumi';

  @override
  String get recommendedForYou => 'Ieteikts tev';

  @override
  String get scraping => 'Iegūst datus';

  @override
  String get search => 'Meklēt';

  @override
  String get searchInAlbum => 'Meklēt albumā...';

  @override
  String get searchInLibrary => 'Meklēt bibliotēkā...';

  @override
  String get searchInPlaylist => 'Meklēt atskaņošanas sarakstā';

  @override
  String get searchLikedSongs => 'Meklēt iecienītās dziesmas...';

  @override
  String get searchPopularSongs => 'Meklēt populāras dziesmas...';

  @override
  String get selectMarket => 'Atlasīt tirgu';

  @override
  String get settings => 'Iestatījumi';

  @override
  String get showVideoPlayer => 'Rādīt video atskaņotāju';

  @override
  String get shuffle => 'Jaukt';

  @override
  String get spotifyCredentials => 'Spotify akreditācijas dati';

  @override
  String get suggestedStations => 'Ieteiktās stacijas';

  @override
  String get tracks => 'IERAKSTI';

  @override
  String get trending => 'Populārs';

  @override
  String get tryAgain => 'Mēģināt vēlreiz';

  @override
  String get tryADifferentSearchTerm => 'Mēģiniet citu meklēšanas terminu';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Izmantot YouTube atskaņotāju, ja pieejams';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Ko vēlaties klausīties?';

  @override
  String get youtubeCredentials => 'YouTube akreditācijas dati';

  @override
  String get yourLibrary => 'Jūsu bibliotēka';

  @override
  String get playerscreenviewswitch => 'speletaja_ekrana_skata_sledzis';

  @override
  String get addToPlaylist => 'Pievienot atskaņošanas sarakstam';

  @override
  String get addToQueue => 'Pievienot rindai';

  @override
  String get copyId => 'Kopēt ID';

  @override
  String get copyLink => 'Kopēt saiti';

  @override
  String get discover => 'Atklāt';

  @override
  String get enterYourName => 'Ievadiet savu vārdu';

  @override
  String get favorites => 'Favorīti';

  @override
  String get goToAlbum => 'Doties uz albumu';

  @override
  String get goToArtist => 'Doties uz mākslinieku';

  @override
  String get goToArtistRadio => 'Doties uz mākslinieka radio';

  @override
  String get goToPlaylist => 'Doties uz atskaņošanas sarakstu';

  @override
  String get goToSongRadio => 'Doties uz dziesmas radio';

  @override
  String get home => 'Sākums';

  @override
  String get myAwesomePlaylist => 'Mans lieliskais atskaņošanas saraksts';

  @override
  String get myPlaylist => 'Mans atskaņošanas saraksts';

  @override
  String get newPlaylist1 => 'Jauns atskaņošanas saraksts';

  @override
  String get play => 'Atskaņot';

  @override
  String get playStation => 'Atskaņot staciju';

  @override
  String get playNext => 'Atskaņot nākamo';

  @override
  String get playlist => 'Atskaņošanas saraksts';

  @override
  String get playlistName => 'Atskaņošanas saraksta nosaukums';

  @override
  String get playlists1 => 'Atskaņošanas saraksti';

  @override
  String get queue1 => 'Rinda';

  @override
  String get recentlyPlayed => 'Nesen atskaņotie';

  @override
  String get removeFromQueue => 'Noņemt no rindas';

  @override
  String get retry => 'Mēģināt vēlreiz';

  @override
  String get searchMusicArtistsAlbums =>
      'Meklēt mūziku, māksliniekus, albumus...';

  @override
  String get share => 'Kopīgot';

  @override
  String featuringArtist(String artistName) {
    return 'PIEDALĀS $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Pašreizējā: $country';
  }

  @override
  String get queueTooltip => 'Rinda';

  @override
  String get searchHint => 'Meklēt mūziku, māksliniekus, albumus...';

  @override
  String get language => 'Valoda';

  @override
  String get systemDefault => 'Sistēmas noklusējums';

  @override
  String get songsTab => 'Dziesmas';

  @override
  String get foldersTab => 'Mapes';

  @override
  String get artistsTab => 'Mākslinieki';

  @override
  String get albumsTab => 'Albumi';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get addMusic => 'Pievienot mūziku';

  @override
  String get addFiles => 'Pievienot failus';

  @override
  String get addFolder => 'Pievienot mapi';

  @override
  String get rescanLibrary => 'Atkārtoti skenēt bibliotēku';

  @override
  String get sortTitle => 'Kārtot pēc nosaukuma';

  @override
  String get sortArtist => 'Kārtot pēc mākslinieka';

  @override
  String get sortAlbum => 'Kārtot pēc albuma';

  @override
  String get sortDuration => 'Kārtot pēc ilguma';

  @override
  String get sortDateAdded => 'Kārtot pēc pievienošanas datuma';

  @override
  String get trackInformation => 'Sliežu ceļa informācija';

  @override
  String get removeFromLibrary => 'Noņemt no bibliotēkas';

  @override
  String get showInFolder => 'Rādīt mapē';

  @override
  String get unknownArtist => 'Nezināms mākslinieks';

  @override
  String get unknownAlbum => 'Nezināms albums';

  @override
  String get importedFiles => 'Importētie faili';

  @override
  String get playFolder => 'Atskaņot mapi';

  @override
  String get shuffleFolder => 'Jaukt mapi';

  @override
  String get playAll => 'Atskaņot visu';

  @override
  String get includeSubfolders => 'Iekļaut apakšmapes';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count celiņi',
      one: '1 celiņš',
      zero: '0 celiņi',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Vietējās dziesmas nav atrastas';

  @override
  String get searchLocalMusic => 'Meklēt vietējo mūziku...';

  @override
  String get viewAsList => 'Skatīt kā sarakstu';

  @override
  String get viewAsGrid => 'Skatīt kā režģi';

  @override
  String get trackInfoPath => 'Ceļš';

  @override
  String get trackInfoFormat => 'Formāts';

  @override
  String get trackInfoDuration => 'Ilgums';

  @override
  String get aboutDescription =>
      'Bezmaksas, atvērtā pirmkoda mūzikas atskaņotājs.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Versija $version (Būvējums $build)';
  }

  @override
  String get createdBy => 'Izveidoja Lucas Coelho';

  @override
  String get website => 'Tīmekļa vietne';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Laidiena piezīmes';

  @override
  String get support => 'Atbalsts';

  @override
  String get license => 'Licence';

  @override
  String get acknowledgments => 'Pateicības';

  @override
  String get close => 'Aizvērt';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer atbalstītāji';
  }

  @override
  String get goodMorning => 'Labrīt';

  @override
  String get goodAfternoon => 'Labdien';

  @override
  String get goodEvening => 'Labvakar';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Tava mūzika gaida.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Tavi iecienītākie\nun jauni atklājumi';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Jauna mūzika\ntikai tev';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Atpūties un relaksējies';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Dziļš fokuss\nun produktivitāte';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'Viss';

  @override
  String get filterPlaylists => 'Atskaņošanas saraksti';

  @override
  String get filterArtists => 'Mākslinieki';

  @override
  String get filterAlbums => 'Albumi';

  @override
  String get filterStations => 'Stacijas';

  @override
  String get localMusicCard => 'Vietējā mūzika';

  @override
  String get createPlaylistButton => 'Izveidot atskaņošanas sarakstu';

  @override
  String get radioStations => 'Radiostacijas';

  @override
  String get discoverMusic => 'Atklāt mūziku';

  @override
  String get importLocalMusic => 'Importēt vietējo mūziku';

  @override
  String get importAudioFiles => 'Importēt audio failus';

  @override
  String get importFolder => 'Importēt mapi';

  @override
  String get importFolderSubtitle => 'Izvēlieties mapi, kurā ir audio faili';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Unsupported format or corrupted file';

  @override
  String get playbackErrorFileInaccessible => 'File inaccessible or not found';
}
