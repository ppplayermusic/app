// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

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
  String get artists => 'IZVOĐAČI';

  @override
  String get artwork => 'OMOT';

  @override
  String get appVersion => 'Verzija aplikacije';

  @override
  String get artist => 'Izvođač';

  @override
  String get artistsYouFollow => 'Izvođači koje pratite';

  @override
  String get autoplay => 'Automatska reprodukcija';

  @override
  String get becauseYouListenedTo => 'Zato što ste slušali';

  @override
  String get browseAll => 'Pregledaj sve';

  @override
  String get cancel => 'Odustani';

  @override
  String get clearAppCache => 'Očistiti predmemoriju aplikacije?';

  @override
  String get clearCache => 'Očisti predmemoriju';

  @override
  String get clearHistory => 'Očistiti povijest?';

  @override
  String get clearRecentlyPlayed => 'Očisti nedavno slušano';

  @override
  String get contentMarket => 'Tržište sadržaja';

  @override
  String get continueListening => 'Nastavi slušati';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Nastavi reprodukciju videa u malom prozoru';

  @override
  String get create => 'Stvori';

  @override
  String get createAPlaylistToGetStarted =>
      'Stvorite popis za reprodukciju za početak';

  @override
  String currentSelectedcountry(Object country) {
    return 'Trenutno: $country';
  }

  @override
  String get deletePlaylist => 'Izbriši popis za reprodukciju';

  @override
  String get editProfile => 'Uredi profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Greška pri učitavanju tržišta: $err';
  }

  @override
  String error(Object error) {
    return 'Greška: $error';
  }

  @override
  String explore(Object genre) {
    return 'Istraži $genre';
  }

  @override
  String get fansAlsoLike => 'OBOŽAVATELJI TAKOĐER VOLE';

  @override
  String featuringTouppercase(Object artist) {
    return 'SUDJELUJE $artist';
  }

  @override
  String get featuredPlaylists => 'Istaknuti popisi za reprodukciju';

  @override
  String get followArtistsToSeeThemHere =>
      'Pratite izvođače da biste ih vidjeli ovdje';

  @override
  String get followStationsToSeeThemHere =>
      'Pratite stanice da biste ih vidjeli ovdje';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forsiraj samo audio streamove za uštedu podataka';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Oslobađa prostor i forsira nove podatke';

  @override
  String get fromYourFavorites => 'Iz vaših favorita';

  @override
  String get goBack => 'Idi natrag';

  @override
  String inspiredByName(Object name) {
    return 'Inspirirano izvođačem $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Nastavi reproducirati slične pjesme kada završi red čekanja';

  @override
  String get library => 'Biblioteka';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Lajkajte albume da biste ih vidjeli ovdje';

  @override
  String get likedSongs => 'Lajkane pjesme';

  @override
  String get lowDataMode => 'Način rada s malo podataka';

  @override
  String get madeForYou => 'Napravljeno za vas';

  @override
  String moreLikeName(Object name) {
    return 'Više kao $name';
  }

  @override
  String get moreOptions => 'Više opcija';

  @override
  String get nameYourMasterpiece => 'Imenujte svoje remek-djelo...';

  @override
  String get newPlaylist => 'Novi popis za reprodukciju';

  @override
  String get newReleases => 'Nova izdanja';

  @override
  String get next => 'Sljedeće';

  @override
  String get noAlbumsFound => 'Nisu pronađeni albumi';

  @override
  String get noArtistsFollowed => 'Ne pratite nijednog izvođača';

  @override
  String get noArtistsFound => 'Nisu pronađeni izvođači';

  @override
  String get noLikedAlbums => 'Nema lajkanih albuma';

  @override
  String get noPlaylistsFound => 'Nisu pronađeni popisi za reprodukciju';

  @override
  String get noPlaylistsYet => 'Još nema popisa za reprodukciju';

  @override
  String get noResultsFound => 'Nema rezultata';

  @override
  String get noStationsFollowed => 'Ne pratite nijednu stanicu';

  @override
  String get noTrackPlaying => 'Niti jedna pjesma se ne reproducira';

  @override
  String get noTracksFound => 'Nisu pronađene pjesme';

  @override
  String get playlists => 'POPISI ZA REPRODUKCIJU';

  @override
  String get popular => 'POPULARNO';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Trajno ukloni povijest slušanja';

  @override
  String get pictureinpicturePip => 'Slika u slici (PiP)';

  @override
  String get popularAlbums => 'Popularni albumi';

  @override
  String get popularArtists => 'Popularni izvođači';

  @override
  String get popularGenres => 'Popularni žanrovi';

  @override
  String get popularSongs => 'Popularne pjesme';

  @override
  String get popularTracks => 'Popularne pjesme';

  @override
  String get popularHitsRightNow => 'Trenutno popularni hitovi';

  @override
  String get previous => 'Prethodno';

  @override
  String get queue => 'RED ČEKANJA';

  @override
  String get recentSearches => 'Nedavna pretraživanja';

  @override
  String get recommendedForYou => 'Preporučeno za vas';

  @override
  String get scraping => 'Dohvaćanje podataka';

  @override
  String get search => 'Pretraživanje';

  @override
  String get searchInAlbum => 'Pretraži u albumu...';

  @override
  String get searchInLibrary => 'Pretraži u biblioteci...';

  @override
  String get searchInPlaylist => 'Pretraži u popisu za reprodukciju';

  @override
  String get searchLikedSongs => 'Pretraži lajkane pjesme...';

  @override
  String get searchPopularSongs => 'Pretraži popularne pjesme...';

  @override
  String get selectMarket => 'Odaberi tržište';

  @override
  String get settings => 'Postavke';

  @override
  String get showVideoPlayer => 'Prikaži video player';

  @override
  String get shuffle => 'Nasumično';

  @override
  String get spotifyCredentials => 'Vjerodajnice za Spotify';

  @override
  String get suggestedStations => 'Predložene stanice';

  @override
  String get tracks => 'PJESME';

  @override
  String get trending => 'U trendu';

  @override
  String get tryAgain => 'Pokušaj ponovno';

  @override
  String get tryADifferentSearchTerm =>
      'Pokušajte s drugim pojmom za pretraživanje';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Koristi YouTube player kada je dostupan';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Što želite slušati?';

  @override
  String get youtubeCredentials => 'Vjerodajnice za YouTube';

  @override
  String get yourLibrary => 'Vaša biblioteka';

  @override
  String get playerscreenviewswitch => 'prebacivanje_prikaza_zaslona_sviraca';

  @override
  String get addToPlaylist => 'Dodaj na popis za reprodukciju';

  @override
  String get addToQueue => 'Dodaj u red čekanja';

  @override
  String get copyId => 'Kopiraj ID';

  @override
  String get copyLink => 'Kopiraj vezu';

  @override
  String get discover => 'Otkrij';

  @override
  String get enterYourName => 'Unesite svoje ime';

  @override
  String get favorites => 'Favoriti';

  @override
  String get goToAlbum => 'Idi na album';

  @override
  String get goToArtist => 'Idi na izvođača';

  @override
  String get goToArtistRadio => 'Idi na radio izvođača';

  @override
  String get goToPlaylist => 'Idi na popis za reprodukciju';

  @override
  String get goToSongRadio => 'Idi na radio pjesme';

  @override
  String get home => 'Početna';

  @override
  String get myAwesomePlaylist => 'Moj super popis za reprodukciju';

  @override
  String get myPlaylist => 'Moj popis za reprodukciju';

  @override
  String get newPlaylist1 => 'Novi popis za reprodukciju';

  @override
  String get play => 'Reproduciraj';

  @override
  String get playStation => 'Reproduciraj stanicu';

  @override
  String get playNext => 'Reproduciraj sljedeće';

  @override
  String get playlist => 'Popis za reprodukciju';

  @override
  String get playlistName => 'Naziv popisa za reprodukciju';

  @override
  String get playlists1 => 'Popisi za reprodukciju';

  @override
  String get queue1 => 'Red čekanja';

  @override
  String get recentlyPlayed => 'Nedavno slušano';

  @override
  String get removeFromQueue => 'Ukloni iz reda čekanja';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get searchMusicArtistsAlbums =>
      'Pretražite glazbu, izvođače, albume...';

  @override
  String get share => 'Dijeli';

  @override
  String featuringArtist(String artistName) {
    return 'SUDJELUJE $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Trenutno: $country';
  }

  @override
  String get queueTooltip => 'Red čekanja';

  @override
  String get searchHint => 'Pretražite glazbu, izvođače, albume...';

  @override
  String get language => 'Jezik';

  @override
  String get systemDefault => 'Zadano u sustavu';

  @override
  String get songsTab => 'Pjesme';

  @override
  String get foldersTab => 'Mape';

  @override
  String get artistsTab => 'Izvođači';

  @override
  String get albumsTab => 'Albumi';

  @override
  String get addMusic => 'Dodaj glazbu';

  @override
  String get addFiles => 'Dodaj datoteke';

  @override
  String get addFolder => 'Dodaj mapu';

  @override
  String get rescanLibrary => 'Ponovno skeniraj biblioteku';

  @override
  String get sortTitle => 'Poredaj po naslovu';

  @override
  String get sortArtist => 'Poredaj po izvođaču';

  @override
  String get sortAlbum => 'Poredaj po albumu';

  @override
  String get sortDuration => 'Poredaj po trajanju';

  @override
  String get sortDateAdded => 'Poredaj po datumu';

  @override
  String get trackInformation => 'Informacije o zapisu';

  @override
  String get removeFromLibrary => 'Ukloni iz biblioteke';

  @override
  String get showInFolder => 'Prikaži u mapi';

  @override
  String get unknownArtist => 'Nepoznat izvođač';

  @override
  String get unknownAlbum => 'Nepoznat album';

  @override
  String get importedFiles => 'Uvezene datoteke';

  @override
  String get playFolder => 'Pokreni mapu';

  @override
  String get shuffleFolder => 'Nasumično pokreni mapu';

  @override
  String get playAll => 'Pokreni sve';

  @override
  String get includeSubfolders => 'Uključi podmape';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zapisa',
      few: '$count zapisa',
      one: '1 zapis',
      zero: '0 zapisa',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Nema lokalnih pjesama';

  @override
  String get searchLocalMusic => 'Pretraži lokalnu glazbu...';

  @override
  String get viewAsList => 'Prikaži kao popis';

  @override
  String get viewAsGrid => 'Prikaži kao mrežu';

  @override
  String get trackInfoPath => 'Putanja';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Trajanje';

  @override
  String get aboutDescription => 'Besplatan glazbeni svirač otvorenog koda.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Verzija $version (Oznaka međuverzije $build)';
  }

  @override
  String get createdBy => 'Izradio Lucas Coelho';

  @override
  String get website => 'Web stranica';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Napomene o izdanju';

  @override
  String get support => 'Podrška';

  @override
  String get license => 'Licenca';

  @override
  String get acknowledgments => 'Zahvale';

  @override
  String get close => 'Zatvori';

  @override
  String copyright(Object year) {
    return '© $year Suradnici PPPlayer-a';
  }

  @override
  String get goodMorning => 'Dobro jutro';

  @override
  String get goodAfternoon => 'Dobar dan';

  @override
  String get goodEvening => 'Dobra večer';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Tvoja glazba te čeka.';

  @override
  String dailyMix(Object number, Object bad_placeholder) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries => 'Tvoji favoriti\ni nova otkrića';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Nova glazba\nsamo za tebe';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Opusti se i uživaj';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Duboki fokus\ni produktivnost';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'Sve';

  @override
  String get filterPlaylists => 'Popisi za reprodukciju';

  @override
  String get filterArtists => 'Izvođači';

  @override
  String get filterAlbums => 'Albumi';

  @override
  String get filterStations => 'Postaje';

  @override
  String get localMusicCard => 'Lokalna glazba';

  @override
  String get createPlaylistButton => 'Stvori popis za reprodukciju';

  @override
  String get radioStations => 'Radiopostaje';

  @override
  String get discoverMusic => 'Otkrij glazbu';

  @override
  String get importLocalMusic => 'Uvezi lokalnu glazbu';

  @override
  String get importAudioFiles => 'Uvezi audio datoteke';

  @override
  String get importFolder => 'Uvezi mapu';

  @override
  String get importFolderSubtitle =>
      'Odaberite mapu koja sadrži audio datoteke';
}
