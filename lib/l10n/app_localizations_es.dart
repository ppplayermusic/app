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
  String get playlists => 'LISTAS DE REPRODUCCIÓN';

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
  String get playerscreenviewswitch => 'cambiar_vista_pantalla_jugador';

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
  String get playlists1 => 'Listas de reproducción';

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
  String get songsTab => 'Canciones';

  @override
  String get foldersTab => 'Carpetas';

  @override
  String get artistsTab => 'Artistas';

  @override
  String get albumsTab => 'Álbumes';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get addMusic => 'Añadir música';

  @override
  String get addFiles => 'Añadir archivos';

  @override
  String get addFolder => 'Añadir carpeta';

  @override
  String get rescanLibrary => 'Volver a escanear biblioteca';

  @override
  String get sortTitle => 'Ordenar por título';

  @override
  String get sortArtist => 'Ordenar por artista';

  @override
  String get sortAlbum => 'Ordenar por álbum';

  @override
  String get sortDuration => 'Ordenar por duración';

  @override
  String get sortDateAdded => 'Ordenar por fecha';

  @override
  String get sortBy => 'Sort by';

  @override
  String get trackInformation => 'Información de la pista';

  @override
  String get removeFromLibrary => 'Eliminar de la biblioteca';

  @override
  String get showInFolder => 'Mostrar en carpeta';

  @override
  String get unknownArtist => 'Artista desconocido';

  @override
  String get unknownAlbum => 'Álbum desconocido';

  @override
  String get importedFiles => 'Archivos importados';

  @override
  String get playFolder => 'Reproducir carpeta';

  @override
  String get shuffleFolder => 'Reproducir carpeta en orden aleatorio';

  @override
  String get playAll => 'Reproducir todo';

  @override
  String get includeSubfolders => 'Incluir subcarpetas';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '1 pista',
      zero: '0 pistas',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'No se encontraron canciones locales';

  @override
  String get searchLocalMusic => 'Buscar música local...';

  @override
  String get viewAsList => 'Ver como lista';

  @override
  String get viewAsGrid => 'Ver como cuadrícula';

  @override
  String get trackInfoPath => 'Ruta';

  @override
  String get trackInfoFormat => 'Formato';

  @override
  String get trackInfoDuration => 'Duración';

  @override
  String get aboutDescription =>
      'Un reproductor de música gratuito y de código abierto.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Versión $version (Compilación $build)';
  }

  @override
  String get createdBy => 'Creado por Lucas Coelho';

  @override
  String get website => 'Sitio web';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Notas de la versión';

  @override
  String get support => 'Soporte';

  @override
  String get license => 'Licencia';

  @override
  String get acknowledgments => 'Agradecimientos';

  @override
  String get close => 'Cerrar';

  @override
  String copyright(Object year) {
    return '© $year Colaboradores de PPPlayer';
  }

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Tu música te espera.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Tus favoritos\ny nuevos descubrimientos';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'Música nueva\nsolo para ti';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Relájate y desconecta';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity =>
      'Concentración profunda\ny productividad';

  @override
  String artistRadio(Object artist) {
    return 'Radio de $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'Radio de $genre';
  }

  @override
  String get filterAll => 'Todo';

  @override
  String get filterPlaylists => 'Listas';

  @override
  String get filterArtists => 'Artistas';

  @override
  String get filterAlbums => 'Álbumes';

  @override
  String get filterStations => 'Estaciones';

  @override
  String get filterStreams => 'Streams';

  @override
  String get localMusicCard => 'Música local';

  @override
  String get createPlaylistButton => 'Crear lista';

  @override
  String get radioStations => 'Estaciones de radio';

  @override
  String get discoverMusic => 'Descubrir música';

  @override
  String get importLocalMusic => 'Importar música local';

  @override
  String get importAudioFiles => 'Importar archivos';

  @override
  String get importFolder => 'Importar carpeta';

  @override
  String get importFolderSubtitle =>
      'Elige una carpeta que contenga archivos de audio';

  @override
  String get importPlaylist => 'Import Playlist';

  @override
  String get importPlaylistSubtitle => 'Import .m3u or .m3u8 files';

  @override
  String get exportPlaylist => 'Export Playlist';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Unsupported format or corrupted file';

  @override
  String get playbackErrorFileInaccessible => 'File inaccessible or not found';

  @override
  String get localVideosCard => 'Local Videos';

  @override
  String get noLocalVideos => 'No videos found';

  @override
  String get searchLocalVideos => 'Search local videos';

  @override
  String get addVideos => 'Add Videos';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get audioTracks => 'Audio Tracks';

  @override
  String get loadSubtitleFile => 'Load subtitle file...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Error al cargar los subtítulos: $error';
  }

  @override
  String get off => 'Off';
}
