// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ÁLBUMES';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTAS';

  @override
  String get artwork => 'CARÁTULA';

  @override
  String get appVersion => 'Versión de la app';

  @override
  String get artist => 'Artista';

  @override
  String get artistsYouFollow => 'Artistas que sigues';

  @override
  String get autoplay => 'Reproducción automática';

  @override
  String get becauseYouListenedTo => 'Porque escuchaste';

  @override
  String get browseAll => 'Explorar todo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clearAppCache => '¿Borrar caché de la aplicación?';

  @override
  String get clearCache => 'Borrar caché';

  @override
  String get clearHistory => '¿Borrar historial?';

  @override
  String get clearRecentlyPlayed => 'Borrar reproducidos recientemente';

  @override
  String get contentMarket => 'Mercado de contenido';

  @override
  String get continueListening => 'Continuar escuchando';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continuar reproducción de video en ventana pequeña';

  @override
  String get create => 'Crear';

  @override
  String get createAPlaylistToGetStarted => 'Crea una playlist para empezar';

  @override
  String currentSelectedcountry(Object country) {
    return 'Actual: $country';
  }

  @override
  String get deletePlaylist => 'Eliminar playlist';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Error cargando mercados: $err';
  }

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String explore(Object genre) {
    return 'Explorar $genre';
  }

  @override
  String get fansAlsoLike => 'A LOS FANS TAMBIÉN LES GUSTA';

  @override
  String featuringTouppercase(Object artist) {
    return 'CON $artist';
  }

  @override
  String get featuredPlaylists => 'Playlists destacadas';

  @override
  String get followArtistsToSeeThemHere => 'Sigue artistas para verlos aquí';

  @override
  String get followStationsToSeeThemHere => 'Sigue emisoras para verlas aquí';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forzar streams de solo audio para ahorrar datos';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Libera espacio y fuerza datos nuevos en la próxima carga';

  @override
  String get fromYourFavorites => 'De tus favoritos';

  @override
  String get goBack => 'Volver';

  @override
  String inspiredByName(Object name) {
    return 'Inspirado por $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Seguir reproduciendo pistas similares al terminar la cola';

  @override
  String get library => 'Tu biblioteca';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Dale me gusta a los álbumes para verlos aquí';

  @override
  String get likedSongs => 'Tus me gusta';

  @override
  String get lowDataMode => 'Modo de ahorro de datos';

  @override
  String get madeForYou => 'Hecho para ti';

  @override
  String moreLikeName(Object name) {
    return 'Más como $name';
  }

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get nameYourMasterpiece => 'Nombra tu obra maestra...';

  @override
  String get newPlaylist => 'Nueva playlist';

  @override
  String get newReleases => 'Nuevos lanzamientos';

  @override
  String get next => 'Siguiente';

  @override
  String get noAlbumsFound => 'No se encontraron álbumes';

  @override
  String get noArtistsFollowed => 'No sigues a ningún artista';

  @override
  String get noArtistsFound => 'No se encontraron artistas';

  @override
  String get noLikedAlbums => 'No hay álbumes que te gusten';

  @override
  String get noPlaylistsFound => 'No se encontraron playlists';

  @override
  String get noPlaylistsYet => 'Aún no hay playlists';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get noStationsFollowed => 'No sigues ninguna emisora';

  @override
  String get noTrackPlaying => 'No se está reproduciendo ninguna pista';

  @override
  String get noTracksFound => 'No se encontraron pistas';

  @override
  String get playlists => 'PLAYLISTS';

  @override
  String get popular => 'POPULAR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Eliminar historial de escucha de forma permanente';

  @override
  String get pictureinpicturePip => 'Imagen en imagen (PiP)';

  @override
  String get popularAlbums => 'Álbumes populares';

  @override
  String get popularArtists => 'Artistas populares';

  @override
  String get popularGenres => 'Géneros populares';

  @override
  String get popularSongs => 'Canciones populares';

  @override
  String get popularTracks => 'Pistas populares';

  @override
  String get popularHitsRightNow => 'Éxitos populares del momento';

  @override
  String get previous => 'Anterior';

  @override
  String get queue => 'COLA';

  @override
  String get recentSearches => 'Búsquedas recientes';

  @override
  String get recommendedForYou => 'Recomendado para ti';

  @override
  String get scraping => 'Obteniendo datos';

  @override
  String get search => 'Buscar';

  @override
  String get searchInAlbum => 'Buscar en el álbum...';

  @override
  String get searchInLibrary => 'Buscar en tu biblioteca...';

  @override
  String get searchInPlaylist => 'Buscar en la playlist';

  @override
  String get searchLikedSongs => 'Buscar en tus me gusta...';

  @override
  String get searchPopularSongs => 'Buscar canciones populares...';

  @override
  String get selectMarket => 'Seleccionar mercado';

  @override
  String get settings => 'Configuración';

  @override
  String get showVideoPlayer => 'Mostrar reproductor de video';

  @override
  String get shuffle => 'Aleatorio';

  @override
  String get spotifyCredentials => 'Credenciales de Spotify';

  @override
  String get suggestedStations => 'Emisoras sugeridas';

  @override
  String get tracks => 'PISTAS';

  @override
  String get trending => 'Tendencias';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get tryADifferentSearchTerm =>
      'Intenta con un término de búsqueda diferente';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Usar reproductor de YouTube cuando esté disponible';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => '¿Qué quieres escuchar?';

  @override
  String get youtubeCredentials => 'Credenciales de YouTube';

  @override
  String get yourLibrary => 'Tu biblioteca';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Añadir a playlist';

  @override
  String get addToQueue => 'Añadir a la cola';

  @override
  String get copyId => 'Copiar ID';

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get discover => 'Descubrir';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get favorites => 'Favoritos';

  @override
  String get goToAlbum => 'Ir al álbum';

  @override
  String get goToArtist => 'Ir al artista';

  @override
  String get goToArtistRadio => 'Ir a la radio del artista';

  @override
  String get goToPlaylist => 'Ir a la playlist';

  @override
  String get goToSongRadio => 'Ir a la radio de la canción';

  @override
  String get home => 'Inicio';

  @override
  String get myAwesomePlaylist => 'Mi playlist increíble';

  @override
  String get myPlaylist => 'Mi playlist';

  @override
  String get newPlaylist1 => 'Nueva playlist';

  @override
  String get play => 'Reproducir';

  @override
  String get playStation => 'Reproducir emisora';

  @override
  String get playNext => 'Reproducir a continuación';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Nombre de la playlist';

  @override
  String get playlists1 => 'Playlists';

  @override
  String get queue1 => 'Cola';

  @override
  String get recentlyPlayed => 'Escuchado recientemente';

  @override
  String get removeFromQueue => 'Eliminar de la cola';

  @override
  String get retry => 'Reintentar';

  @override
  String get searchMusicArtistsAlbums => 'Buscar música, artistas, álbumes...';

  @override
  String get share => 'Compartir';

  @override
  String featuringArtist(String artistName) {
    return 'CON $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Actual: $country';
  }

  @override
  String get queueTooltip => 'Cola';

  @override
  String get searchHint => 'Buscar música, artistas, álbumes...';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

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
