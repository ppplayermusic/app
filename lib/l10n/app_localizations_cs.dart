// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBA';

  @override
  String get api => 'API';

  @override
  String get artists => 'UMĚLCI';

  @override
  String get artwork => 'OBRÁZEK';

  @override
  String get appVersion => 'Verze aplikace';

  @override
  String get artist => 'Umělec';

  @override
  String get artistsYouFollow => 'Umělci, které sledujete';

  @override
  String get autoplay => 'Automatické přehrávání';

  @override
  String get becauseYouListenedTo => 'Protože jste poslouchali';

  @override
  String get browseAll => 'Procházet vše';

  @override
  String get cancel => 'Zrušit';

  @override
  String get clearAppCache => 'Vymazat mezipaměť aplikace?';

  @override
  String get clearCache => 'Vymazat mezipaměť';

  @override
  String get clearHistory => 'Vymazat historii?';

  @override
  String get clearRecentlyPlayed => 'Vymazat nedávno přehrané';

  @override
  String get contentMarket => 'Trh s obsahem';

  @override
  String get continueListening => 'Pokračovat v poslechu';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Pokračovat v přehrávání videa v malém okně';

  @override
  String get create => 'Vytvořit';

  @override
  String get createAPlaylistToGetStarted => 'Vytvořte playlist a začněte';

  @override
  String currentSelectedcountry(Object country) {
    return 'Aktuální: $country';
  }

  @override
  String get deletePlaylist => 'Smazat playlist';

  @override
  String get editProfile => 'Upravit profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Chyba při načítání trhů: $err';
  }

  @override
  String error(Object error) {
    return 'Chyba: $error';
  }

  @override
  String explore(Object genre) {
    return 'Prozkoumat $genre';
  }

  @override
  String get fansAlsoLike => 'FANOUŠKŮM SE TAKÉ LÍBÍ';

  @override
  String featuringTouppercase(Object artist) {
    return 'S ÚČASTÍ $artist';
  }

  @override
  String get featuredPlaylists => 'Doporučené playlisty';

  @override
  String get followArtistsToSeeThemHere =>
      'Sledujte umělce, abyste je zde viděli';

  @override
  String get followStationsToSeeThemHere =>
      'Sledujte stanice, abyste je zde viděli';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Vynutit pouze zvukové streamy pro úsporu dat';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Uvolní místo a vynutí nová data při dalším načtení';

  @override
  String get fromYourFavorites => 'Z vašich oblíbených';

  @override
  String get goBack => 'Jít zpět';

  @override
  String inspiredByName(Object name) {
    return 'Inspirováno $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Po skončení fronty pokračovat v přehrávání podobných skladeb';

  @override
  String get library => 'Knihovna';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Dejte to se mi líbí u alb, abyste je zde viděli';

  @override
  String get likedSongs => 'Oblíbené skladby';

  @override
  String get lowDataMode => 'Režim úspory dat';

  @override
  String get madeForYou => 'Vytvořeno pro vás';

  @override
  String moreLikeName(Object name) {
    return 'Více jako $name';
  }

  @override
  String get moreOptions => 'Další možnosti';

  @override
  String get nameYourMasterpiece => 'Pojmenujte své mistrovské dílo...';

  @override
  String get newPlaylist => 'Nový playlist';

  @override
  String get newReleases => 'Nová vydání';

  @override
  String get next => 'Další';

  @override
  String get noAlbumsFound => 'Nenalezena žádná alba';

  @override
  String get noArtistsFollowed => 'Nesledujete žádné umělce';

  @override
  String get noArtistsFound => 'Nenalezeni žádní umělci';

  @override
  String get noLikedAlbums => 'Žádná oblíbená alba';

  @override
  String get noPlaylistsFound => 'Nenalezeny žádné playlisty';

  @override
  String get noPlaylistsYet => 'Zatím žádné playlisty';

  @override
  String get noResultsFound => 'Nenalezeny žádné výsledky';

  @override
  String get noStationsFollowed => 'Nesledujete žádné stanice';

  @override
  String get noTrackPlaying => 'Nehraje žádná skladba';

  @override
  String get noTracksFound => 'Nenalezeny žádné skladby';

  @override
  String get playlists => 'PLAYLISTY';

  @override
  String get popular => 'POPULÁRNÍ';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Trvale odstranit historii poslechu';

  @override
  String get pictureinpicturePip => 'Obraz v obraze (PiP)';

  @override
  String get popularAlbums => 'Populární alba';

  @override
  String get popularArtists => 'Populární umělci';

  @override
  String get popularGenres => 'Populární žánry';

  @override
  String get popularSongs => 'Populární skladby';

  @override
  String get popularTracks => 'Populární skladby';

  @override
  String get popularHitsRightNow => 'Populární hity právě teď';

  @override
  String get previous => 'Předchozí';

  @override
  String get queue => 'FRONTA';

  @override
  String get recentSearches => 'Nedávná hledání';

  @override
  String get recommendedForYou => 'Doporučeno pro vás';

  @override
  String get scraping => 'Získávání dat';

  @override
  String get search => 'Hledat';

  @override
  String get searchInAlbum => 'Hledat v albu...';

  @override
  String get searchInLibrary => 'Hledat v knihovně...';

  @override
  String get searchInPlaylist => 'Hledat v playlistu';

  @override
  String get searchLikedSongs => 'Hledat v oblíbených skladbách...';

  @override
  String get searchPopularSongs => 'Hledat populární skladby...';

  @override
  String get selectMarket => 'Vybrat trh';

  @override
  String get settings => 'Nastavení';

  @override
  String get showVideoPlayer => 'Zobrazit videopřehrávač';

  @override
  String get shuffle => 'Náhodně';

  @override
  String get spotifyCredentials => 'Přihlašovací údaje Spotify';

  @override
  String get suggestedStations => 'Navrhované stanice';

  @override
  String get tracks => 'SKLADBY';

  @override
  String get trending => 'Trendy';

  @override
  String get tryAgain => 'Zkusit znovu';

  @override
  String get tryADifferentSearchTerm => 'Zkuste jiný hledaný výraz';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Použít přehrávač YouTube, když je k dispozici';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Co chcete poslouchat?';

  @override
  String get youtubeCredentials => 'Přihlašovací údaje YouTube';

  @override
  String get yourLibrary => 'Vaše knihovna';

  @override
  String get playerscreenviewswitch => 'prepinac_zobrazeni_prehravace';

  @override
  String get addToPlaylist => 'Přidat do playlistu';

  @override
  String get addToQueue => 'Přidat do fronty';

  @override
  String get copyId => 'Kopírovat ID';

  @override
  String get copyLink => 'Kopírovat odkaz';

  @override
  String get discover => 'Objevit';

  @override
  String get enterYourName => 'Zadejte své jméno';

  @override
  String get favorites => 'Oblíbené';

  @override
  String get goToAlbum => 'Přejít na album';

  @override
  String get goToArtist => 'Přejít na umělce';

  @override
  String get goToArtistRadio => 'Přejít na rádio umělce';

  @override
  String get goToPlaylist => 'Přejít na playlist';

  @override
  String get goToSongRadio => 'Přejít na rádio skladby';

  @override
  String get home => 'Domů';

  @override
  String get myAwesomePlaylist => 'Můj úžasný playlist';

  @override
  String get myPlaylist => 'Můj playlist';

  @override
  String get newPlaylist1 => 'Nový playlist';

  @override
  String get play => 'Přehrát';

  @override
  String get playStation => 'Přehrát stanici';

  @override
  String get playNext => 'Přehrát jako další';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Název playlistu';

  @override
  String get playlists1 => 'Playlisty';

  @override
  String get queue1 => 'Fronta';

  @override
  String get recentlyPlayed => 'Nedávno přehrané';

  @override
  String get removeFromQueue => 'Odebrat z fronty';

  @override
  String get retry => 'Opakovat';

  @override
  String get searchMusicArtistsAlbums => 'Hledat hudbu, umělce, alba...';

  @override
  String get share => 'Sdílet';

  @override
  String featuringArtist(String artistName) {
    return 'S ÚČASTÍ $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Aktuální: $country';
  }

  @override
  String get queueTooltip => 'Fronta';

  @override
  String get searchHint => 'Hledat hudbu, umělce, alba...';

  @override
  String get language => 'Jazyk';

  @override
  String get systemDefault => 'Výchozí systémový';

  @override
  String get songsTab => 'Skladby';

  @override
  String get foldersTab => 'Složky';

  @override
  String get artistsTab => 'Umělci';

  @override
  String get albumsTab => 'Alba';

  @override
  String get addMusic => 'Přidat hudbu';

  @override
  String get addFiles => 'Přidat soubory';

  @override
  String get addFolder => 'Přidat složku';

  @override
  String get rescanLibrary => 'Znovu skenovat knihovnu';

  @override
  String get sortTitle => 'Seřadit podle názvu';

  @override
  String get sortArtist => 'Seřadit podle umělce';

  @override
  String get sortAlbum => 'Seřadit podle alba';

  @override
  String get sortDuration => 'Seřadit podle délky';

  @override
  String get sortDateAdded => 'Seřadit podle data přidání';

  @override
  String get trackInformation => 'Informace o skladbě';

  @override
  String get removeFromLibrary => 'Odebrat z knihovny';

  @override
  String get showInFolder => 'Zobrazit ve složce';

  @override
  String get unknownArtist => 'Neznámý umělec';

  @override
  String get unknownAlbum => 'Neznámé album';

  @override
  String get importedFiles => 'Importované soubory';

  @override
  String get playFolder => 'Přehrát složku';

  @override
  String get shuffleFolder => 'Náhodně přehrát složku';

  @override
  String get playAll => 'Přehrát vše';

  @override
  String get includeSubfolders => 'Zahrnout podsložky';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '1 skladba',
      zero: '0 skladeb',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Nenalezeny žádné místní skladby';

  @override
  String get searchLocalMusic => 'Hledat místní hudbu...';

  @override
  String get viewAsList => 'Zobrazit jako seznam';

  @override
  String get viewAsGrid => 'Zobrazit jako mřížku';

  @override
  String get trackInfoPath => 'Cesta';

  @override
  String get trackInfoFormat => 'Formát';

  @override
  String get trackInfoDuration => 'Délka';

  @override
  String get aboutDescription => 'Bezplatný, open-source hudební přehrávač.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Verze $version (Sestavení $build)';
  }

  @override
  String get createdBy => 'Vytvořil Lucas Coelho';

  @override
  String get website => 'Webová stránka';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Poznámky k vydání';

  @override
  String get support => 'Podpora';

  @override
  String get license => 'Licence';

  @override
  String get acknowledgments => 'Poděkování';

  @override
  String get close => 'Zavřít';

  @override
  String copyright(Object year) {
    return '© $year Přispěvatelé PPPlayer';
  }

  @override
  String get goodMorning => 'Dobré ráno';

  @override
  String get goodAfternoon => 'Dobré odpoledne';

  @override
  String get goodEvening => 'Dobrý večer';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Vaše hudba čeká.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries => 'Vaše oblíbené\na nové objevy';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Nová hudba\njen pro vás';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Relaxujte a odpočívejte';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Hluboké soustředění\na produktivita';

  @override
  String artistRadio(Object artist) {
    return '$artist Rádio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Rádio';
  }

  @override
  String get filterAll => 'Vše';

  @override
  String get filterPlaylists => 'Playlisty';

  @override
  String get filterArtists => 'Umělci';

  @override
  String get filterAlbums => 'Alba';

  @override
  String get filterStations => 'Stanice';

  @override
  String get localMusicCard => 'Místní hudba';

  @override
  String get createPlaylistButton => 'Vytvořit playlist';

  @override
  String get radioStations => 'Rádiové stanice';

  @override
  String get discoverMusic => 'Objevovat hudbu';

  @override
  String get importLocalMusic => 'Importovat místní hudbu';

  @override
  String get importAudioFiles => 'Importovat zvukové soubory';

  @override
  String get importFolder => 'Importovat složku';

  @override
  String get importFolderSubtitle =>
      'Note: Audio files are hidden in the folder picker. This is normal.';
}
