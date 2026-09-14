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
  String get playerscreenviewswitch => 'player_screen_view_switch';

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
      'Bezplatný hudební přehrávač s otevřeným zdrojovým kódem.';

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
    return '© $year PPPlayer contributors';
  }
}
