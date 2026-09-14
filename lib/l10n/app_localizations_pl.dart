// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMY';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTYŚCI';

  @override
  String get artwork => 'OKŁADKA';

  @override
  String get appVersion => 'Wersja aplikacji';

  @override
  String get artist => 'Artysta';

  @override
  String get artistsYouFollow => 'Artyści, których obserwujesz';

  @override
  String get autoplay => 'Autoodtwarzanie';

  @override
  String get becauseYouListenedTo => 'Ponieważ słuchałeś';

  @override
  String get browseAll => 'Przeglądaj wszystko';

  @override
  String get cancel => 'Anuluj';

  @override
  String get clearAppCache => 'Wyczyścić pamięć podręczną?';

  @override
  String get clearCache => 'Wyczyść pamięć podręczną';

  @override
  String get clearHistory => 'Wyczyścić historię?';

  @override
  String get clearRecentlyPlayed => 'Wyczyść ostatnio odtwarzane';

  @override
  String get contentMarket => 'Rynek zawartości';

  @override
  String get continueListening => 'Słuchaj dalej';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Odtwarzaj wideo w małym oknie';

  @override
  String get create => 'Utwórz';

  @override
  String get createAPlaylistToGetStarted => 'Utwórz playlistę, aby rozpocząć';

  @override
  String currentSelectedcountry(Object country) {
    return 'Obecnie: $country';
  }

  @override
  String get deletePlaylist => 'Usuń playlistę';

  @override
  String get editProfile => 'Edytuj profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Błąd ładowania rynków: $err';
  }

  @override
  String error(Object error) {
    return 'Błąd: $error';
  }

  @override
  String explore(Object genre) {
    return 'Odkryj $genre';
  }

  @override
  String get fansAlsoLike => 'FANI LUBIĄ TEŻ';

  @override
  String featuringTouppercase(Object artist) {
    return 'Z UDZIAŁEM $artist';
  }

  @override
  String get featuredPlaylists => 'Polecane playlisty';

  @override
  String get followArtistsToSeeThemHere =>
      'Obserwuj artystów, aby zobaczyć ich tutaj';

  @override
  String get followStationsToSeeThemHere =>
      'Obserwuj stacje, aby zobaczyć je tutaj';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Wymuś odtwarzanie tylko dźwięku, by oszczędzać dane';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Zwalnia miejsce i wymusza pobranie nowych danych';

  @override
  String get fromYourFavorites => 'Z Twoich ulubionych';

  @override
  String get goBack => 'Wróć';

  @override
  String inspiredByName(Object name) {
    return 'Zainspirowane $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Odtwarzaj podobne utwory po zakończeniu kolejki';

  @override
  String get library => 'Biblioteka';

  @override
  String get likeAlbumsToSeeThemHere => 'Polub albumy, aby zobaczyć je tutaj';

  @override
  String get likedSongs => 'Polubione utwory';

  @override
  String get lowDataMode => 'Oszczędzanie danych';

  @override
  String get madeForYou => 'Stworzone dla Ciebie';

  @override
  String moreLikeName(Object name) {
    return 'Więcej jak $name';
  }

  @override
  String get moreOptions => 'Więcej opcji';

  @override
  String get nameYourMasterpiece => 'Nazwij swoje arcydzieło...';

  @override
  String get newPlaylist => 'Nowa playlista';

  @override
  String get newReleases => 'Nowe wydania';

  @override
  String get next => 'Dalej';

  @override
  String get noAlbumsFound => 'Nie znaleziono albumów';

  @override
  String get noArtistsFollowed => 'Nie obserwujesz żadnych artystów';

  @override
  String get noArtistsFound => 'Nie znaleziono artystów';

  @override
  String get noLikedAlbums => 'Brak polubionych albumów';

  @override
  String get noPlaylistsFound => 'Nie znaleziono playlist';

  @override
  String get noPlaylistsYet => 'Brak playlist';

  @override
  String get noResultsFound => 'Brak wyników';

  @override
  String get noStationsFollowed => 'Nie obserwujesz żadnych stacji';

  @override
  String get noTrackPlaying => 'Brak odtwarzanego utworu';

  @override
  String get noTracksFound => 'Nie znaleziono utworów';

  @override
  String get playlists => 'PLAYLISTY';

  @override
  String get popular => 'POPULARNE';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Trwale usuń historię słuchania';

  @override
  String get pictureinpicturePip => 'Obraz w obrazie (PiP)';

  @override
  String get popularAlbums => 'Popularne albumy';

  @override
  String get popularArtists => 'Popularni artyści';

  @override
  String get popularGenres => 'Popularne gatunki';

  @override
  String get popularSongs => 'Popularne utwory';

  @override
  String get popularTracks => 'Popularne utwory';

  @override
  String get popularHitsRightNow => 'Obecne hity';

  @override
  String get previous => 'Wstecz';

  @override
  String get queue => 'KOLEJKA';

  @override
  String get recentSearches => 'Ostatnie wyszukiwania';

  @override
  String get recommendedForYou => 'Polecane dla Ciebie';

  @override
  String get scraping => 'Pobieranie';

  @override
  String get search => 'Szukaj';

  @override
  String get searchInAlbum => 'Szukaj w albumie...';

  @override
  String get searchInLibrary => 'Szukaj w bibliotece...';

  @override
  String get searchInPlaylist => 'Szukaj w playliście...';

  @override
  String get searchLikedSongs => 'Szukaj w polubionych utworach...';

  @override
  String get searchPopularSongs => 'Szukaj w popularnych utworach...';

  @override
  String get selectMarket => 'Wybierz rynek';

  @override
  String get settings => 'Ustawienia';

  @override
  String get showVideoPlayer => 'Pokaż odtwarzacz wideo';

  @override
  String get shuffle => 'Losowo';

  @override
  String get spotifyCredentials => 'Dane uwierzytelniające Spotify';

  @override
  String get suggestedStations => 'Sugerowane stacje';

  @override
  String get tracks => 'UTWORY';

  @override
  String get trending => 'Na czasie';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get tryADifferentSearchTerm => 'Spróbuj innych słów';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Używaj odtwarzacza YouTube, gdy dostępny';

  @override
  String get video => 'WIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Czego chcesz posłuchać?';

  @override
  String get youtubeCredentials => 'Dane uwierzytelniające YouTube';

  @override
  String get yourLibrary => 'Twoja biblioteka';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Dodaj do playlisty';

  @override
  String get addToQueue => 'Dodaj do kolejki';

  @override
  String get copyId => 'Kopiuj ID';

  @override
  String get copyLink => 'Kopiuj link';

  @override
  String get discover => 'Odkrywaj';

  @override
  String get enterYourName => 'Wpisz swoje imię';

  @override
  String get favorites => 'Ulubione';

  @override
  String get goToAlbum => 'Przejdź do albumu';

  @override
  String get goToArtist => 'Przejdź do artysty';

  @override
  String get goToArtistRadio => 'Przejdź do radia artysty';

  @override
  String get goToPlaylist => 'Przejdź do playlisty';

  @override
  String get goToSongRadio => 'Przejdź do radia utworu';

  @override
  String get home => 'Strona główna';

  @override
  String get myAwesomePlaylist => 'Moja świetna playlista';

  @override
  String get myPlaylist => 'Moja playlista';

  @override
  String get newPlaylist1 => 'Nowa playlista';

  @override
  String get play => 'Odtwórz';

  @override
  String get playStation => 'Odtwórz stację';

  @override
  String get playNext => 'Odtwórz następne';

  @override
  String get playlist => 'Playlista';

  @override
  String get playlistName => 'Nazwa playlisty';

  @override
  String get playlists1 => 'Playlisty';

  @override
  String get queue1 => 'Kolejka';

  @override
  String get recentlyPlayed => 'Ostatnio odtwarzane';

  @override
  String get removeFromQueue => 'Usuń z kolejki';

  @override
  String get retry => 'Ponów';

  @override
  String get searchMusicArtistsAlbums => 'Szukaj muzyki, artystów, albumów...';

  @override
  String get share => 'Udostępnij';

  @override
  String featuringArtist(String artistName) {
    return 'Z UDZIAŁEM $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Obecnie: $country';
  }

  @override
  String get queueTooltip => 'Kolejka';

  @override
  String get searchHint => 'Szukaj muzyki, artystów, albumów...';

  @override
  String get language => 'Język';

  @override
  String get systemDefault => 'Domyślny systemowy';

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

  @override
  String get aboutDescription =>
      'Darmowy odtwarzacz muzyki o otwartym kodzie źródłowym.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Wersja $version (Kompilacja $build)';
  }

  @override
  String get createdBy => 'Stworzone przez Lucas Coelho';

  @override
  String get website => 'Strona internetowa';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Informacje o wydaniu';

  @override
  String get support => 'Wsparcie';

  @override
  String get license => 'Licencja';

  @override
  String get acknowledgments => 'Podziękowania';

  @override
  String get close => 'Zamknij';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
  }
}
