// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'MGA ALBUM';

  @override
  String get api => 'API';

  @override
  String get artists => 'MGA ARTISTA';

  @override
  String get artwork => 'ARTWORK';

  @override
  String get appVersion => 'Bersyon ng app';

  @override
  String get artist => 'Artista';

  @override
  String get artistsYouFollow => 'Mga artistang sinusundan mo';

  @override
  String get autoplay => 'Autoplay';

  @override
  String get becauseYouListenedTo => 'Dahil nakikinig ka sa';

  @override
  String get browseAll => 'Tingnan lahat';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get clearAppCache => 'I-clear ang App Cache?';

  @override
  String get clearCache => 'I-clear ang Cache';

  @override
  String get clearHistory => 'I-clear ang Kasaysayan?';

  @override
  String get clearRecentlyPlayed => 'I-clear ang Kamakailan lang na Na-play';

  @override
  String get contentMarket => 'Content Market';

  @override
  String get continueListening => 'Ituloy ang pakikinig';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Ituloy ang video sa maliit na window';

  @override
  String get create => 'Lumikha';

  @override
  String get createAPlaylistToGetStarted => 'Gumawa ng playlist para magsimula';

  @override
  String currentSelectedcountry(Object country) {
    return 'Kasalukuyan: $country';
  }

  @override
  String get deletePlaylist => 'Burahin ang Playlist';

  @override
  String get editProfile => 'I-edit ang Profile';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Error sa pag-load ng mga market: $err';
  }

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String explore(Object genre) {
    return 'I-explore ang $genre';
  }

  @override
  String get fansAlsoLike => 'GUSTO RIN NG MGA FAN';

  @override
  String featuringTouppercase(Object artist) {
    return 'KASAMA SI $artist';
  }

  @override
  String get featuredPlaylists => 'Mga Featured na Playlist';

  @override
  String get followArtistsToSeeThemHere =>
      'Sundan ang mga artista para makita sila dito';

  @override
  String get followStationsToSeeThemHere =>
      'Sundan ang mga istasyon para makita sila dito';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Piliting mag-stream ng audio lamang para makatipid ng data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Nagpapalaya ng espasyo at nagfo-force ng bagong data sa susunod na load';

  @override
  String get fromYourFavorites => 'Mula sa iyong mga paborito';

  @override
  String get goBack => 'Bumalik';

  @override
  String inspiredByName(Object name) {
    return 'Inspirado ni $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Patuloy na mag-play ng katulad na mga kanta kapag natapos ang queue';

  @override
  String get library => 'Library';

  @override
  String get likeAlbumsToSeeThemHere => 'I-like ang mga album para makita dito';

  @override
  String get likedSongs => 'Mga Liked na Kanta';

  @override
  String get lowDataMode => 'Low Data Mode';

  @override
  String get madeForYou => 'Para sa Iyo';

  @override
  String moreLikeName(Object name) {
    return 'Higit pang tulad ni $name';
  }

  @override
  String get moreOptions => 'Higit pang mga pagpipilian';

  @override
  String get nameYourMasterpiece => 'Pangalanan ang iyong obra maestra...';

  @override
  String get newPlaylist => 'Bagong Playlist';

  @override
  String get newReleases => 'Mga Bagong Labas';

  @override
  String get next => 'Susunod';

  @override
  String get noAlbumsFound => 'Walang nahanap na album';

  @override
  String get noArtistsFollowed => 'Walang sinundan na artista';

  @override
  String get noArtistsFound => 'Walang nahanap na artista';

  @override
  String get noLikedAlbums => 'Walang liked na album';

  @override
  String get noPlaylistsFound => 'Walang nahanap na playlist';

  @override
  String get noPlaylistsYet => 'Wala pang playlist';

  @override
  String get noResultsFound => 'Walang nahanap na resulta';

  @override
  String get noStationsFollowed => 'Walang sinundan na istasyon';

  @override
  String get noTrackPlaying => 'Walang kanta na nagpe-play';

  @override
  String get noTracksFound => 'Walang nahanap na kanta';

  @override
  String get playlists => 'MGA PLAYLIST';

  @override
  String get popular => 'SIKAT';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Permanenteng alisin ang kasaysayan ng pakikinig';

  @override
  String get pictureinpicturePip => 'Picture-in-Picture (PiP)';

  @override
  String get popularAlbums => 'Mga Sikat na Album';

  @override
  String get popularArtists => 'Mga Sikat na Artista';

  @override
  String get popularGenres => 'Mga Sikat na Genre';

  @override
  String get popularSongs => 'Mga Sikat na Kanta';

  @override
  String get popularTracks => 'Mga Sikat na Track';

  @override
  String get popularHitsRightNow => 'Mga sikat na hit ngayon';

  @override
  String get previous => 'Nakaraan';

  @override
  String get queue => 'QUEUE';

  @override
  String get recentSearches => 'Mga kamakailang paghahanap';

  @override
  String get recommendedForYou => 'Inirerekomenda para sa Iyo';

  @override
  String get scraping => 'Nangongolekta ng data';

  @override
  String get search => 'Maghanap';

  @override
  String get searchInAlbum => 'Maghanap sa album...';

  @override
  String get searchInLibrary => 'Maghanap sa library...';

  @override
  String get searchInPlaylist => 'Maghanap sa playlist';

  @override
  String get searchLikedSongs => 'Maghanap ng mga liked na kanta...';

  @override
  String get searchPopularSongs => 'Maghanap ng mga sikat na kanta...';

  @override
  String get selectMarket => 'Pumili ng Market';

  @override
  String get settings => 'Mga Setting';

  @override
  String get showVideoPlayer => 'Ipakita ang Video Player';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get spotifyCredentials => 'Mga Kredensyal ng Spotify';

  @override
  String get suggestedStations => 'Mga Mungkahing Istasyon';

  @override
  String get tracks => 'MGA TRACK';

  @override
  String get trending => 'Trending';

  @override
  String get tryAgain => 'Subukang muli';

  @override
  String get tryADifferentSearchTerm => 'Subukan ang ibang salitang panghanap';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Gamitin ang YouTube player kung available';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Ano ang gusto mong pakinggan?';

  @override
  String get youtubeCredentials => 'Mga Kredensyal ng YouTube';

  @override
  String get yourLibrary => 'Iyong Library';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Idagdag sa playlist';

  @override
  String get addToQueue => 'Idagdag sa queue';

  @override
  String get copyId => 'Kopyahin ang ID';

  @override
  String get copyLink => 'Kopyahin ang link';

  @override
  String get discover => 'Tuklasin';

  @override
  String get enterYourName => 'Ilagay ang iyong pangalan';

  @override
  String get favorites => 'Mga Paborito';

  @override
  String get goToAlbum => 'Pumunta sa album';

  @override
  String get goToArtist => 'Pumunta sa artista';

  @override
  String get goToArtistRadio => 'Pumunta sa artist radio';

  @override
  String get goToPlaylist => 'Pumunta sa playlist';

  @override
  String get goToSongRadio => 'Pumunta sa song radio';

  @override
  String get home => 'Home';

  @override
  String get myAwesomePlaylist => 'Aking Magandang Playlist';

  @override
  String get myPlaylist => 'Aking Playlist';

  @override
  String get newPlaylist1 => 'Bagong playlist';

  @override
  String get play => 'I-play';

  @override
  String get playStation => 'I-play ang Istasyon';

  @override
  String get playNext => 'I-play susunod';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Pangalan ng Playlist';

  @override
  String get playlists1 => 'Mga Playlist';

  @override
  String get queue1 => 'Queue';

  @override
  String get recentlyPlayed => 'Kamakailan lang na Na-play';

  @override
  String get removeFromQueue => 'Alisin sa queue';

  @override
  String get retry => 'Subukang muli';

  @override
  String get searchMusicArtistsAlbums =>
      'Maghanap ng musika, artista, album...';

  @override
  String get share => 'Ibahagi';

  @override
  String featuringArtist(String artistName) {
    return 'KASAMA SI $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Kasalukuyan: $country';
  }

  @override
  String get queueTooltip => 'Queue';

  @override
  String get searchHint => 'Maghanap ng musika, artista, album...';

  @override
  String get language => 'Wika';

  @override
  String get systemDefault => 'Default ng System';
}
