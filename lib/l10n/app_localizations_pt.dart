// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ÁLBUNS';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTAS';

  @override
  String get artwork => 'CAPA';

  @override
  String get appVersion => 'Versão do aplicativo';

  @override
  String get artist => 'Artista';

  @override
  String get artistsYouFollow => 'Artistas que você segue';

  @override
  String get autoplay => 'Reprodução automática';

  @override
  String get becauseYouListenedTo => 'Porque você ouviu';

  @override
  String get browseAll => 'Navegar por tudo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clearAppCache => 'Limpar cache do aplicativo?';

  @override
  String get clearCache => 'Limpar Cache';

  @override
  String get clearHistory => 'Limpar histórico?';

  @override
  String get clearRecentlyPlayed => 'Limpar reproduzidos recentemente';

  @override
  String get contentMarket => 'Mercado de Conteúdo';

  @override
  String get continueListening => 'Continuar ouvindo';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continuar reprodução de vídeo em janela pequena';

  @override
  String get create => 'Criar';

  @override
  String get createAPlaylistToGetStarted => 'Crie uma playlist para começar';

  @override
  String currentSelectedcountry(Object country) {
    return 'Atual: $country';
  }

  @override
  String get deletePlaylist => 'Excluir Playlist';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Erro ao carregar mercados: $err';
  }

  @override
  String error(Object error) {
    return 'Erro: $error';
  }

  @override
  String explore(Object genre) {
    return 'Explorar $genre';
  }

  @override
  String get fansAlsoLike => 'OS FÃS TAMBÉM GOSTAM';

  @override
  String featuringTouppercase(Object artist) {
    return 'COM $artist';
  }

  @override
  String get featuredPlaylists => 'Playlists em destaque';

  @override
  String get followArtistsToSeeThemHere => 'Siga artistas para vê-los aqui';

  @override
  String get followStationsToSeeThemHere => 'Siga estações para vê-las aqui';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forçar streams apenas de áudio para economizar dados';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Libera espaço e força dados novos no próximo carregamento';

  @override
  String get fromYourFavorites => 'Dos seus favoritos';

  @override
  String get goBack => 'Voltar';

  @override
  String inspiredByName(Object name) {
    return 'Inspirado em $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Continuar tocando faixas similares quando a fila acabar';

  @override
  String get library => 'Biblioteca';

  @override
  String get likeAlbumsToSeeThemHere => 'Curta álbuns para vê-los aqui';

  @override
  String get likedSongs => 'Músicas Curtidas';

  @override
  String get lowDataMode => 'Modo de Economia de Dados';

  @override
  String get madeForYou => 'Feito para você';

  @override
  String moreLikeName(Object name) {
    return 'Mais como $name';
  }

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get nameYourMasterpiece => 'Dê um nome à sua obra-prima...';

  @override
  String get newPlaylist => 'Nova Playlist';

  @override
  String get newReleases => 'Novos Lançamentos';

  @override
  String get next => 'Próximo';

  @override
  String get noAlbumsFound => 'Nenhum álbum encontrado';

  @override
  String get noArtistsFollowed => 'Nenhum artista seguido';

  @override
  String get noArtistsFound => 'Nenhum artista encontrado';

  @override
  String get noLikedAlbums => 'Nenhum álbum curtido';

  @override
  String get noPlaylistsFound => 'Nenhuma playlist encontrada';

  @override
  String get noPlaylistsYet => 'Nenhuma playlist ainda';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get noStationsFollowed => 'Nenhuma estação seguida';

  @override
  String get noTrackPlaying => 'Nenhuma faixa tocando';

  @override
  String get noTracksFound => 'Nenhuma faixa encontrada';

  @override
  String get playlists => 'PLAYLISTS';

  @override
  String get popular => 'POPULAR';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Remover histórico de escuta permanentemente';

  @override
  String get pictureinpicturePip => 'Imagem na imagem (PiP)';

  @override
  String get popularAlbums => 'Álbuns populares';

  @override
  String get popularArtists => 'Artistas populares';

  @override
  String get popularGenres => 'Gêneros populares';

  @override
  String get popularSongs => 'Músicas populares';

  @override
  String get popularTracks => 'Faixas populares';

  @override
  String get popularHitsRightNow => 'Sucessos populares agora';

  @override
  String get previous => 'Anterior';

  @override
  String get queue => 'FILA';

  @override
  String get recentSearches => 'Buscas recentes';

  @override
  String get recommendedForYou => 'Recomendado para você';

  @override
  String get scraping => 'Obtendo dados';

  @override
  String get search => 'Buscar';

  @override
  String get searchInAlbum => 'Buscar no álbum...';

  @override
  String get searchInLibrary => 'Buscar na biblioteca...';

  @override
  String get searchInPlaylist => 'Buscar na playlist';

  @override
  String get searchLikedSongs => 'Buscar nas músicas curtidas...';

  @override
  String get searchPopularSongs => 'Buscar músicas populares...';

  @override
  String get selectMarket => 'Selecionar mercado';

  @override
  String get settings => 'Configurações';

  @override
  String get showVideoPlayer => 'Mostrar player de vídeo';

  @override
  String get shuffle => 'Ordem Aleatória';

  @override
  String get spotifyCredentials => 'Credenciais do Spotify';

  @override
  String get suggestedStations => 'Estações Sugeridas';

  @override
  String get tracks => 'FAIXAS';

  @override
  String get trending => 'Em Alta';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get tryADifferentSearchTerm => 'Tente um termo de busca diferente';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Usar player do YouTube quando disponível';

  @override
  String get video => 'VÍDEO';

  @override
  String get whatDoYouWantToListenTo => 'O que você quer ouvir?';

  @override
  String get youtubeCredentials => 'Credenciais do YouTube';

  @override
  String get yourLibrary => 'Sua Biblioteca';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Adicionar à playlist';

  @override
  String get addToQueue => 'Adicionar à fila';

  @override
  String get copyId => 'Copiar ID';

  @override
  String get copyLink => 'Copiar link';

  @override
  String get discover => 'Descobrir';

  @override
  String get enterYourName => 'Digite seu nome';

  @override
  String get favorites => 'Favoritos';

  @override
  String get goToAlbum => 'Ir para o álbum';

  @override
  String get goToArtist => 'Ir para o artista';

  @override
  String get goToArtistRadio => 'Ir para a rádio do artista';

  @override
  String get goToPlaylist => 'Ir para a playlist';

  @override
  String get goToSongRadio => 'Ir para a rádio da música';

  @override
  String get home => 'Início';

  @override
  String get myAwesomePlaylist => 'Minha Playlist Incrível';

  @override
  String get myPlaylist => 'Minha Playlist';

  @override
  String get newPlaylist1 => 'Nova playlist';

  @override
  String get play => 'Tocar';

  @override
  String get playStation => 'Tocar estação';

  @override
  String get playNext => 'Tocar a seguir';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Nome da playlist';

  @override
  String get playlists1 => 'Playlists';

  @override
  String get queue1 => 'Fila';

  @override
  String get recentlyPlayed => 'Tocadas Recentemente';

  @override
  String get removeFromQueue => 'Remover da fila';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get searchMusicArtistsAlbums => 'Buscar músicas, artistas, álbuns...';

  @override
  String get share => 'Compartilhar';

  @override
  String featuringArtist(String artistName) {
    return 'COM $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Atual: $country';
  }

  @override
  String get queueTooltip => 'Fila';

  @override
  String get searchHint => 'Buscar música, artistas, álbuns...';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

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
