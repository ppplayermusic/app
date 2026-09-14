// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUMS';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTISTES';

  @override
  String get artwork => 'POCHETTE';

  @override
  String get appVersion => 'Version de l\'application';

  @override
  String get artist => 'Artiste';

  @override
  String get artistsYouFollow => 'Artistes que vous suivez';

  @override
  String get autoplay => 'Lecture automatique';

  @override
  String get becauseYouListenedTo => 'Parce que vous avez écouté';

  @override
  String get browseAll => 'Tout parcourir';

  @override
  String get cancel => 'Annuler';

  @override
  String get clearAppCache => 'Effacer le cache de l\'application ?';

  @override
  String get clearCache => 'Effacer le cache';

  @override
  String get clearHistory => 'Effacer l\'historique ?';

  @override
  String get clearRecentlyPlayed => 'Effacer les écoutes récentes';

  @override
  String get contentMarket => 'Marché du contenu';

  @override
  String get continueListening => 'Continuer l\'écoute';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Continuer la lecture vidéo dans une petite fenêtre';

  @override
  String get create => 'Créer';

  @override
  String get createAPlaylistToGetStarted => 'Créez une playlist pour commencer';

  @override
  String currentSelectedcountry(Object country) {
    return 'Actuel : $country';
  }

  @override
  String get deletePlaylist => 'Supprimer la playlist';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Erreur lors du chargement des marchés : $err';
  }

  @override
  String error(Object error) {
    return 'Erreur : $error';
  }

  @override
  String explore(Object genre) {
    return 'Explorer $genre';
  }

  @override
  String get fansAlsoLike => 'LES FANS AIMENT AUSSI';

  @override
  String featuringTouppercase(Object artist) {
    return 'AVEC $artist';
  }

  @override
  String get featuredPlaylists => 'Playlists en vedette';

  @override
  String get followArtistsToSeeThemHere =>
      'Suivez des artistes pour les voir ici';

  @override
  String get followStationsToSeeThemHere =>
      'Suivez des stations pour les voir ici';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Forcer les flux audio uniquement pour économiser les données';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Libère de l\'espace et force les nouvelles données au prochain chargement';

  @override
  String get fromYourFavorites => 'De vos favoris';

  @override
  String get goBack => 'Retour';

  @override
  String inspiredByName(Object name) {
    return 'Inspiré par $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Continuer à lire des titres similaires à la fin de la file d\'attente';

  @override
  String get library => 'Bibliothèque';

  @override
  String get likeAlbumsToSeeThemHere => 'Aimez des albums pour les voir ici';

  @override
  String get likedSongs => 'Titres likés';

  @override
  String get lowDataMode => 'Mode économie de données';

  @override
  String get madeForYou => 'Fait pour vous';

  @override
  String moreLikeName(Object name) {
    return 'Plus comme $name';
  }

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get nameYourMasterpiece => 'Nommez votre chef-d\'œuvre...';

  @override
  String get newPlaylist => 'Nouvelle playlist';

  @override
  String get newReleases => 'Nouvelles sorties';

  @override
  String get next => 'Suivant';

  @override
  String get noAlbumsFound => 'Aucun album trouvé';

  @override
  String get noArtistsFollowed => 'Aucun artiste suivi';

  @override
  String get noArtistsFound => 'Aucun artiste trouvé';

  @override
  String get noLikedAlbums => 'Aucun album liké';

  @override
  String get noPlaylistsFound => 'Aucune playlist trouvée';

  @override
  String get noPlaylistsYet => 'Pas encore de playlist';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get noStationsFollowed => 'Aucune station suivie';

  @override
  String get noTrackPlaying => 'Aucun titre en cours de lecture';

  @override
  String get noTracksFound => 'Aucun titre trouvé';

  @override
  String get playlists => 'LISTES DE LECTURE';

  @override
  String get popular => 'POPULAIRE';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Supprimer définitivement l\'historique d\'écoute';

  @override
  String get pictureinpicturePip => 'Image dans l\'image (PiP)';

  @override
  String get popularAlbums => 'Albums populaires';

  @override
  String get popularArtists => 'Artistes populaires';

  @override
  String get popularGenres => 'Genres populaires';

  @override
  String get popularSongs => 'Chansons populaires';

  @override
  String get popularTracks => 'Titres populaires';

  @override
  String get popularHitsRightNow => 'Hits populaires du moment';

  @override
  String get previous => 'Précédent';

  @override
  String get queue => 'FILE D\'ATTENTE';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get recommendedForYou => 'Recommandé pour vous';

  @override
  String get scraping => 'Récupération en cours';

  @override
  String get search => 'Rechercher';

  @override
  String get searchInAlbum => 'Rechercher dans l\'album...';

  @override
  String get searchInLibrary => 'Rechercher dans la bibliothèque...';

  @override
  String get searchInPlaylist => 'Rechercher dans la playlist';

  @override
  String get searchLikedSongs => 'Rechercher dans les titres likés...';

  @override
  String get searchPopularSongs => 'Rechercher des chansons populaires...';

  @override
  String get selectMarket => 'Sélectionner le marché';

  @override
  String get settings => 'Paramètres';

  @override
  String get showVideoPlayer => 'Afficher le lecteur vidéo';

  @override
  String get shuffle => 'Aléatoire';

  @override
  String get spotifyCredentials => 'Identifiants Spotify';

  @override
  String get suggestedStations => 'Stations suggérées';

  @override
  String get tracks => 'TITRES';

  @override
  String get trending => 'Tendances';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get tryADifferentSearchTerm => 'Essayez un autre terme de recherche';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Utiliser le lecteur YouTube si disponible';

  @override
  String get video => 'VIDÉO';

  @override
  String get whatDoYouWantToListenTo => 'Que voulez-vous écouter ?';

  @override
  String get youtubeCredentials => 'Identifiants YouTube';

  @override
  String get yourLibrary => 'Votre bibliothèque';

  @override
  String get playerscreenviewswitch => 'basculer_vue_ecran_joueur';

  @override
  String get addToPlaylist => 'Ajouter à la playlist';

  @override
  String get addToQueue => 'Ajouter à la file d\'attente';

  @override
  String get copyId => 'Copier l\'ID';

  @override
  String get copyLink => 'Copier le lien';

  @override
  String get discover => 'Découvrir';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get favorites => 'Favoris';

  @override
  String get goToAlbum => 'Aller à l\'album';

  @override
  String get goToArtist => 'Aller à l\'artiste';

  @override
  String get goToArtistRadio => 'Aller à la radio de l\'artiste';

  @override
  String get goToPlaylist => 'Aller à la playlist';

  @override
  String get goToSongRadio => 'Aller à la radio de la chanson';

  @override
  String get home => 'Accueil';

  @override
  String get myAwesomePlaylist => 'Ma super playlist';

  @override
  String get myPlaylist => 'Ma playlist';

  @override
  String get newPlaylist1 => 'Nouvelle playlist';

  @override
  String get play => 'Lecture';

  @override
  String get playStation => 'Lire la station';

  @override
  String get playNext => 'Lire ensuite';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Nom de la playlist';

  @override
  String get playlists1 => 'Listes de lecture';

  @override
  String get queue1 => 'File d\'attente';

  @override
  String get recentlyPlayed => 'Écoutés récemment';

  @override
  String get removeFromQueue => 'Retirer de la file';

  @override
  String get retry => 'Réessayer';

  @override
  String get searchMusicArtistsAlbums =>
      'Rechercher musique, artistes, albums...';

  @override
  String get share => 'Partager';

  @override
  String featuringArtist(String artistName) {
    return 'AVEC $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Actuel: $country';
  }

  @override
  String get queueTooltip => 'File d\'attente';

  @override
  String get searchHint =>
      'Rechercher de la musique, des artistes, des albums...';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get songsTab => 'Chansons';

  @override
  String get foldersTab => 'Dossiers';

  @override
  String get artistsTab => 'Artistes';

  @override
  String get albumsTab => 'Albums';

  @override
  String get addMusic => 'Ajouter de la musique';

  @override
  String get addFiles => 'Ajouter des fichiers';

  @override
  String get addFolder => 'Ajouter un dossier';

  @override
  String get rescanLibrary => 'Réanalyser la bibliothèque';

  @override
  String get sortTitle => 'Trier par titre';

  @override
  String get sortArtist => 'Trier par artiste';

  @override
  String get sortAlbum => 'Trier par album';

  @override
  String get sortDuration => 'Trier par durée';

  @override
  String get sortDateAdded => 'Trier par date d\'ajout';

  @override
  String get trackInformation => 'Informations sur la piste';

  @override
  String get removeFromLibrary => 'Supprimer de la bibliothèque';

  @override
  String get showInFolder => 'Afficher dans le dossier';

  @override
  String get unknownArtist => 'Artiste inconnu';

  @override
  String get unknownAlbum => 'Album inconnu';

  @override
  String get importedFiles => 'Fichiers importés';

  @override
  String get playFolder => 'Lire le dossier';

  @override
  String get shuffleFolder => 'Lecture aléatoire du dossier';

  @override
  String get playAll => 'Tout lire';

  @override
  String get includeSubfolders => 'Inclure les sous-dossiers';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes',
      one: '1 piste',
      zero: '0 piste',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Aucune chanson locale trouvée';

  @override
  String get searchLocalMusic => 'Rechercher de la musique locale...';

  @override
  String get viewAsList => 'Afficher en liste';

  @override
  String get viewAsGrid => 'Afficher en grille';

  @override
  String get trackInfoPath => 'Chemin';

  @override
  String get trackInfoFormat => 'Format';

  @override
  String get trackInfoDuration => 'Durée';

  @override
  String get aboutDescription =>
      'Un lecteur de musique gratuit et open-source.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get createdBy => 'Créé par Lucas Coelho';

  @override
  String get website => 'Site web';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Notes de version';

  @override
  String get support => 'Assistance';

  @override
  String get license => 'Licence';

  @override
  String get acknowledgments => 'Remerciements';

  @override
  String get close => 'Fermer';

  @override
  String copyright(Object year) {
    return '© $year Contributeurs de PPPlayer';
  }

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Votre musique vous attend.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Vos favoris\net de nouvelles découvertes';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'De la nouvelle musique\nrien que pour vous';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Détente et relaxation';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity =>
      'Concentration profonde\net productivité';

  @override
  String artistRadio(Object artist) {
    return 'Radio $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'Radio $genre';
  }

  @override
  String get filterAll => 'Tout';

  @override
  String get filterPlaylists => 'Playlists';

  @override
  String get filterArtists => 'Artistes';

  @override
  String get filterAlbums => 'Albums';

  @override
  String get filterStations => 'Stations';

  @override
  String get localMusicCard => 'Musique locale';

  @override
  String get createPlaylistButton => 'Créer une playlist';

  @override
  String get radioStations => 'Stations de radio';

  @override
  String get discoverMusic => 'Découvrir la musique';

  @override
  String get importLocalMusic => 'Importer de la musique locale';

  @override
  String get importAudioFiles => 'Importer des fichiers audio';

  @override
  String get importFolder => 'Importer un dossier';
}
