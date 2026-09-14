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
  String get playerscreenviewswitch => 'przelacznik_widoku_ekranu_gracza';

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
  String get songsTab => 'Utwory';

  @override
  String get foldersTab => 'Foldery';

  @override
  String get artistsTab => 'Wykonawcy';

  @override
  String get albumsTab => 'Albumy';

  @override
  String get addMusic => 'Dodaj muzykę';

  @override
  String get addFiles => 'Dodaj pliki';

  @override
  String get addFolder => 'Dodaj folder';

  @override
  String get rescanLibrary => 'Skanuj bibliotekę';

  @override
  String get sortTitle => 'Sortuj według tytułu';

  @override
  String get sortArtist => 'Sortuj według wykonawcy';

  @override
  String get sortAlbum => 'Sortuj według albumu';

  @override
  String get sortDuration => 'Sortuj według czasu';

  @override
  String get sortDateAdded => 'Sortuj według daty dodania';

  @override
  String get trackInformation => 'Informacje o utworze';

  @override
  String get removeFromLibrary => 'Usuń z biblioteki';

  @override
  String get showInFolder => 'Pokaż w folderze';

  @override
  String get unknownArtist => 'Nieznany wykonawca';

  @override
  String get unknownAlbum => 'Nieznany album';

  @override
  String get importedFiles => 'Zaimportowane pliki';

  @override
  String get playFolder => 'Odtwórz folder';

  @override
  String get shuffleFolder => 'Odtwarzaj folder losowo';

  @override
  String get playAll => 'Odtwórz wszystko';

  @override
  String get includeSubfolders => 'Uwzględnij podfoldery';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
      zero: '0 utworów',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Nie znaleziono lokalnych utworów';

  @override
  String get searchLocalMusic => 'Szukaj lokalnej muzyki...';

  @override
  String get viewAsList => 'Widok listy';

  @override
  String get viewAsGrid => 'Widok siatki';

  @override
  String get trackInfoPath => 'Ścieżka';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Czas trwania';

  @override
  String get aboutDescription =>
      'Darmowy odtwarzacz muzyki o otwartym kodzie źródłowym.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Wersja $version (Kompilacja $build)';
  }

  @override
  String get createdBy => 'Stworzony przez Lucas Coelho';

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
    return '© $year Współtwórcy PPPlayer';
  }

  @override
  String get goodMorning => 'Dzień dobry';

  @override
  String get goodAfternoon => 'Dzień dobry';

  @override
  String get goodEvening => 'Dobry wieczór';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Twoja muzyka czeka.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Twoje ulubione\ni nowe odkrycia';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Nowa muzyka\ntylko dla Ciebie';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Zrelaksuj się';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Głębokie skupienie\ni produktywność';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'Wszystko';

  @override
  String get filterPlaylists => 'Playlisty';

  @override
  String get filterArtists => 'Artyści';

  @override
  String get filterAlbums => 'Albumy';

  @override
  String get filterStations => 'Stacje';

  @override
  String get localMusicCard => 'Lokalna muzyka';

  @override
  String get createPlaylistButton => 'Utwórz playlistę';

  @override
  String get radioStations => 'Stacje radiowe';

  @override
  String get discoverMusic => 'Odkrywaj muzykę';

  @override
  String get importLocalMusic => 'Importuj lokalną muzykę';

  @override
  String get importAudioFiles => 'Importuj pliki audio';

  @override
  String get importFolder => 'Importuj folder';
}
