import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gn.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_my.dart';
import 'app_localizations_pcm.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fil'),
    Locale('fr'),
    Locale('gn'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('kk'),
    Locale('ko'),
    Locale('lv'),
    Locale('ms'),
    Locale('my'),
    Locale('pcm'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uz'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PPPlayer'**
  String get appTitle;

  /// No description provided for @titleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{title}, {subtitle}'**
  String titleSubtitle(Object title, Object subtitle);

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'ALBUMS'**
  String get albums;

  /// No description provided for @api.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get api;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'ARTISTS'**
  String get artists;

  /// No description provided for @artwork.
  ///
  /// In en, this message translates to:
  /// **'ARTWORK'**
  String get artwork;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @artistsYouFollow.
  ///
  /// In en, this message translates to:
  /// **'Artists you follow'**
  String get artistsYouFollow;

  /// No description provided for @autoplay.
  ///
  /// In en, this message translates to:
  /// **'Autoplay'**
  String get autoplay;

  /// No description provided for @becauseYouListenedTo.
  ///
  /// In en, this message translates to:
  /// **'Because you listened to'**
  String get becauseYouListenedTo;

  /// No description provided for @browseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse all'**
  String get browseAll;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clearAppCache.
  ///
  /// In en, this message translates to:
  /// **'Clear App Cache?'**
  String get clearAppCache;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History?'**
  String get clearHistory;

  /// No description provided for @clearRecentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Clear Recently Played'**
  String get clearRecentlyPlayed;

  /// No description provided for @contentMarket.
  ///
  /// In en, this message translates to:
  /// **'Content Market'**
  String get contentMarket;

  /// No description provided for @continueListening.
  ///
  /// In en, this message translates to:
  /// **'Continue Listening'**
  String get continueListening;

  /// No description provided for @continueVideoPlaybackInASmallWindow.
  ///
  /// In en, this message translates to:
  /// **'Continue video playback in a small window'**
  String get continueVideoPlaybackInASmallWindow;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createAPlaylistToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist to get started'**
  String get createAPlaylistToGetStarted;

  /// No description provided for @currentSelectedcountry.
  ///
  /// In en, this message translates to:
  /// **'Current: {country}'**
  String currentSelectedcountry(Object country);

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @errorLoadingMarkets.
  ///
  /// In en, this message translates to:
  /// **'Error loading markets: {err}'**
  String errorLoadingMarkets(Object err);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore {genre}'**
  String explore(Object genre);

  /// No description provided for @fansAlsoLike.
  ///
  /// In en, this message translates to:
  /// **'FANS ALSO LIKE'**
  String get fansAlsoLike;

  /// No description provided for @featuringTouppercase.
  ///
  /// In en, this message translates to:
  /// **'FEATURING {artist}'**
  String featuringTouppercase(Object artist);

  /// No description provided for @featuredPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Featured Playlists'**
  String get featuredPlaylists;

  /// No description provided for @followArtistsToSeeThemHere.
  ///
  /// In en, this message translates to:
  /// **'Follow artists to see them here'**
  String get followArtistsToSeeThemHere;

  /// No description provided for @followStationsToSeeThemHere.
  ///
  /// In en, this message translates to:
  /// **'Follow stations to see them here'**
  String get followStationsToSeeThemHere;

  /// No description provided for @forceAudioonlyStreamsToSaveData.
  ///
  /// In en, this message translates to:
  /// **'Force audio-only streams to save data'**
  String get forceAudioonlyStreamsToSaveData;

  /// No description provided for @freesUpSpaceAndForcesFreshDataOnNextLoad.
  ///
  /// In en, this message translates to:
  /// **'Frees up space and forces fresh data on next load'**
  String get freesUpSpaceAndForcesFreshDataOnNextLoad;

  /// No description provided for @fromYourFavorites.
  ///
  /// In en, this message translates to:
  /// **'From your favorites'**
  String get fromYourFavorites;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @inspiredByName.
  ///
  /// In en, this message translates to:
  /// **'Inspired by {name}'**
  String inspiredByName(Object name);

  /// No description provided for @keepPlayingSimilarTracksWhenQueueEnds.
  ///
  /// In en, this message translates to:
  /// **'Keep playing similar tracks when queue ends'**
  String get keepPlayingSimilarTracksWhenQueueEnds;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @likeAlbumsToSeeThemHere.
  ///
  /// In en, this message translates to:
  /// **'Like albums to see them here'**
  String get likeAlbumsToSeeThemHere;

  /// No description provided for @likedSongs.
  ///
  /// In en, this message translates to:
  /// **'Liked Songs'**
  String get likedSongs;

  /// No description provided for @lowDataMode.
  ///
  /// In en, this message translates to:
  /// **'Low Data Mode'**
  String get lowDataMode;

  /// No description provided for @madeForYou.
  ///
  /// In en, this message translates to:
  /// **'Made for you'**
  String get madeForYou;

  /// No description provided for @moreLikeName.
  ///
  /// In en, this message translates to:
  /// **'More like {name}'**
  String moreLikeName(Object name);

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @nameYourMasterpiece.
  ///
  /// In en, this message translates to:
  /// **'Name your masterpiece...'**
  String get nameYourMasterpiece;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get newPlaylist;

  /// No description provided for @newReleases.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get newReleases;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noAlbumsFound.
  ///
  /// In en, this message translates to:
  /// **'No albums found'**
  String get noAlbumsFound;

  /// No description provided for @noArtistsFollowed.
  ///
  /// In en, this message translates to:
  /// **'No artists followed'**
  String get noArtistsFollowed;

  /// No description provided for @noArtistsFound.
  ///
  /// In en, this message translates to:
  /// **'No artists found'**
  String get noArtistsFound;

  /// No description provided for @noLikedAlbums.
  ///
  /// In en, this message translates to:
  /// **'No liked albums'**
  String get noLikedAlbums;

  /// No description provided for @noPlaylistsFound.
  ///
  /// In en, this message translates to:
  /// **'No playlists found'**
  String get noPlaylistsFound;

  /// No description provided for @noPlaylistsYet.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylistsYet;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noStationsFollowed.
  ///
  /// In en, this message translates to:
  /// **'No stations followed'**
  String get noStationsFollowed;

  /// No description provided for @noTrackPlaying.
  ///
  /// In en, this message translates to:
  /// **'No track playing'**
  String get noTrackPlaying;

  /// No description provided for @noTracksFound.
  ///
  /// In en, this message translates to:
  /// **'No tracks found'**
  String get noTracksFound;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'PLAYLISTS'**
  String get playlists;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popular;

  /// No description provided for @permanentlyRemoveListeningHistory.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove listening history'**
  String get permanentlyRemoveListeningHistory;

  /// No description provided for @pictureinpicturePip.
  ///
  /// In en, this message translates to:
  /// **'Picture-in-Picture (PiP)'**
  String get pictureinpicturePip;

  /// No description provided for @popularAlbums.
  ///
  /// In en, this message translates to:
  /// **'Popular Albums'**
  String get popularAlbums;

  /// No description provided for @popularArtists.
  ///
  /// In en, this message translates to:
  /// **'Popular Artists'**
  String get popularArtists;

  /// No description provided for @popularGenres.
  ///
  /// In en, this message translates to:
  /// **'Popular Genres'**
  String get popularGenres;

  /// No description provided for @popularSongs.
  ///
  /// In en, this message translates to:
  /// **'Popular Songs'**
  String get popularSongs;

  /// No description provided for @popularTracks.
  ///
  /// In en, this message translates to:
  /// **'Popular Tracks'**
  String get popularTracks;

  /// No description provided for @popularHitsRightNow.
  ///
  /// In en, this message translates to:
  /// **'Popular hits right now'**
  String get popularHitsRightNow;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'QUEUE'**
  String get queue;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @scraping.
  ///
  /// In en, this message translates to:
  /// **'Scraping'**
  String get scraping;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchInAlbum.
  ///
  /// In en, this message translates to:
  /// **'Search in album...'**
  String get searchInAlbum;

  /// No description provided for @searchInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Search in library...'**
  String get searchInLibrary;

  /// No description provided for @searchInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Search in playlist'**
  String get searchInPlaylist;

  /// No description provided for @searchLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'Search liked songs...'**
  String get searchLikedSongs;

  /// No description provided for @searchPopularSongs.
  ///
  /// In en, this message translates to:
  /// **'Search popular songs...'**
  String get searchPopularSongs;

  /// No description provided for @selectMarket.
  ///
  /// In en, this message translates to:
  /// **'Select Market'**
  String get selectMarket;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @showVideoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Show Video Player'**
  String get showVideoPlayer;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @spotifyCredentials.
  ///
  /// In en, this message translates to:
  /// **'Spotify Credentials'**
  String get spotifyCredentials;

  /// No description provided for @suggestedStations.
  ///
  /// In en, this message translates to:
  /// **'Suggested Stations'**
  String get suggestedStations;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'TRACKS'**
  String get tracks;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @tryADifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryADifferentSearchTerm;

  /// No description provided for @useYoutubePlayerWhenAvailable.
  ///
  /// In en, this message translates to:
  /// **'Use YouTube player when available'**
  String get useYoutubePlayerWhenAvailable;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'VIDEO'**
  String get video;

  /// No description provided for @whatDoYouWantToListenTo.
  ///
  /// In en, this message translates to:
  /// **'What do you want to listen to?'**
  String get whatDoYouWantToListenTo;

  /// No description provided for @youtubeCredentials.
  ///
  /// In en, this message translates to:
  /// **'YouTube Credentials'**
  String get youtubeCredentials;

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get yourLibrary;

  /// No description provided for @playerscreenviewswitch.
  ///
  /// In en, this message translates to:
  /// **'player_screen_view_switch'**
  String get playerscreenviewswitch;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @addToQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get addToQueue;

  /// No description provided for @copyId.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get copyId;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @goToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Go to album'**
  String get goToAlbum;

  /// No description provided for @goToArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to artist'**
  String get goToArtist;

  /// No description provided for @goToArtistRadio.
  ///
  /// In en, this message translates to:
  /// **'Go to artist radio'**
  String get goToArtistRadio;

  /// No description provided for @goToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Go to playlist'**
  String get goToPlaylist;

  /// No description provided for @goToSongRadio.
  ///
  /// In en, this message translates to:
  /// **'Go to song radio'**
  String get goToSongRadio;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myAwesomePlaylist.
  ///
  /// In en, this message translates to:
  /// **'My Awesome Playlist'**
  String get myAwesomePlaylist;

  /// No description provided for @myPlaylist.
  ///
  /// In en, this message translates to:
  /// **'My Playlist'**
  String get myPlaylist;

  /// No description provided for @newPlaylist1.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist1;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @playStation.
  ///
  /// In en, this message translates to:
  /// **'Play Station'**
  String get playStation;

  /// No description provided for @playNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get playNext;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistName;

  /// No description provided for @playlists1.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists1;

  /// No description provided for @queue1.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue1;

  /// No description provided for @recentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get recentlyPlayed;

  /// No description provided for @removeFromQueue.
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueue;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searchMusicArtistsAlbums.
  ///
  /// In en, this message translates to:
  /// **'Search music, artists, albums...'**
  String get searchMusicArtistsAlbums;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @featuringArtist.
  ///
  /// In en, this message translates to:
  /// **'FEATURING {artistName}'**
  String featuringArtist(String artistName);

  /// No description provided for @currentCountry.
  ///
  /// In en, this message translates to:
  /// **'Current: {country}'**
  String currentCountry(String country);

  /// No description provided for @queueTooltip.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queueTooltip;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search music, artists, albums...'**
  String get searchHint;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @songsTab.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songsTab;

  /// No description provided for @foldersTab.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get foldersTab;

  /// No description provided for @artistsTab.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artistsTab;

  /// No description provided for @albumsTab.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumsTab;

  /// No description provided for @genresTab.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genresTab;

  /// No description provided for @noLocalGenres.
  ///
  /// In en, this message translates to:
  /// **'No genres found'**
  String get noLocalGenres;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @addMusic.
  ///
  /// In en, this message translates to:
  /// **'Add music'**
  String get addMusic;

  /// No description provided for @addFiles.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get addFiles;

  /// No description provided for @addFolder.
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get addFolder;

  /// No description provided for @rescanLibrary.
  ///
  /// In en, this message translates to:
  /// **'Rescan library'**
  String get rescanLibrary;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortTitle;

  /// No description provided for @sortArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get sortArtist;

  /// No description provided for @sortAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get sortAlbum;

  /// No description provided for @sortDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sortDuration;

  /// No description provided for @sortDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get sortDateAdded;

  /// No description provided for @trackInformation.
  ///
  /// In en, this message translates to:
  /// **'Track Information'**
  String get trackInformation;

  /// No description provided for @removeFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get removeFromLibrary;

  /// No description provided for @showInFolder.
  ///
  /// In en, this message translates to:
  /// **'Show in folder'**
  String get showInFolder;

  /// No description provided for @unknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get unknownArtist;

  /// No description provided for @unknownAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unknown Album'**
  String get unknownAlbum;

  /// No description provided for @importedFiles.
  ///
  /// In en, this message translates to:
  /// **'Imported Files'**
  String get importedFiles;

  /// No description provided for @playFolder.
  ///
  /// In en, this message translates to:
  /// **'Play folder'**
  String get playFolder;

  /// No description provided for @shuffleFolder.
  ///
  /// In en, this message translates to:
  /// **'Shuffle folder'**
  String get shuffleFolder;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @includeSubfolders.
  ///
  /// In en, this message translates to:
  /// **'Include subfolders'**
  String get includeSubfolders;

  /// No description provided for @trackCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 tracks} =1{1 track} other{{count} tracks}}'**
  String trackCount(num count);

  /// No description provided for @noLocalSongs.
  ///
  /// In en, this message translates to:
  /// **'No local songs imported'**
  String get noLocalSongs;

  /// No description provided for @searchLocalMusic.
  ///
  /// In en, this message translates to:
  /// **'Search local music'**
  String get searchLocalMusic;

  /// No description provided for @viewAsList.
  ///
  /// In en, this message translates to:
  /// **'View as list'**
  String get viewAsList;

  /// No description provided for @viewAsGrid.
  ///
  /// In en, this message translates to:
  /// **'View as grid'**
  String get viewAsGrid;

  /// No description provided for @trackInfoPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get trackInfoPath;

  /// No description provided for @trackInfoFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get trackInfoFormat;

  /// No description provided for @trackInfoDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get trackInfoDuration;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A free, open-source music player.'**
  String get aboutDescription;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version {version} (Build {build})'**
  String versionInfo(Object version, Object build);

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by Lucas Coelho'**
  String get createdBy;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @releaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get releaseNotes;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @acknowledgments.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgments'**
  String get acknowledgments;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} PPPlayer contributors'**
  String copyright(Object year);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(Object greeting, Object name);

  /// No description provided for @yourMusicIsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your music is waiting.'**
  String get yourMusicIsWaiting;

  /// No description provided for @dailyMix.
  ///
  /// In en, this message translates to:
  /// **'Daily Mix {number}'**
  String dailyMix(Object number);

  /// No description provided for @yourFavoritesAndNewDiscoveries.
  ///
  /// In en, this message translates to:
  /// **'Your favorites\nand new discoveries'**
  String get yourFavoritesAndNewDiscoveries;

  /// No description provided for @discoverWeekly.
  ///
  /// In en, this message translates to:
  /// **'Discover Weekly'**
  String get discoverWeekly;

  /// No description provided for @releaseRadar.
  ///
  /// In en, this message translates to:
  /// **'Release Radar'**
  String get releaseRadar;

  /// No description provided for @newMusicJustForYou.
  ///
  /// In en, this message translates to:
  /// **'New music\njust for you'**
  String get newMusicJustForYou;

  /// No description provided for @chillMix.
  ///
  /// In en, this message translates to:
  /// **'Chill Mix'**
  String get chillMix;

  /// No description provided for @relaxAndUnwind.
  ///
  /// In en, this message translates to:
  /// **'Relax and unwind'**
  String get relaxAndUnwind;

  /// No description provided for @focusMix.
  ///
  /// In en, this message translates to:
  /// **'Focus Mix'**
  String get focusMix;

  /// No description provided for @deepFocusAndProductivity.
  ///
  /// In en, this message translates to:
  /// **'Deep focus\nand productivity'**
  String get deepFocusAndProductivity;

  /// No description provided for @artistRadio.
  ///
  /// In en, this message translates to:
  /// **'{artist} Radio'**
  String artistRadio(Object artist);

  /// No description provided for @genreRadio.
  ///
  /// In en, this message translates to:
  /// **'{genre} Radio'**
  String genreRadio(Object genre);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get filterPlaylists;

  /// No description provided for @filterArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get filterArtists;

  /// No description provided for @filterAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get filterAlbums;

  /// No description provided for @filterStations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get filterStations;

  /// No description provided for @localMusicCard.
  ///
  /// In en, this message translates to:
  /// **'Local Music'**
  String get localMusicCard;

  /// No description provided for @createPlaylistButton.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylistButton;

  /// No description provided for @radioStations.
  ///
  /// In en, this message translates to:
  /// **'Radio Stations'**
  String get radioStations;

  /// No description provided for @discoverMusic.
  ///
  /// In en, this message translates to:
  /// **'Discover Music'**
  String get discoverMusic;

  /// No description provided for @importLocalMusic.
  ///
  /// In en, this message translates to:
  /// **'Import Local Music'**
  String get importLocalMusic;

  /// No description provided for @importAudioFiles.
  ///
  /// In en, this message translates to:
  /// **'Import Audio Files'**
  String get importAudioFiles;

  /// No description provided for @importFolder.
  ///
  /// In en, this message translates to:
  /// **'Import Folder'**
  String get importFolder;

  /// No description provided for @importFolderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Note: Audio files are hidden in the folder picker. This is normal.'**
  String get importFolderSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'cs',
    'da',
    'de',
    'en',
    'es',
    'et',
    'fa',
    'fil',
    'fr',
    'gn',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ka',
    'kk',
    'ko',
    'lv',
    'ms',
    'my',
    'pcm',
    'pl',
    'pt',
    'ru',
    'sv',
    'tr',
    'uz',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fa':
      return AppLocalizationsFa();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'gn':
      return AppLocalizationsGn();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'ko':
      return AppLocalizationsKo();
    case 'lv':
      return AppLocalizationsLv();
    case 'ms':
      return AppLocalizationsMs();
    case 'my':
      return AppLocalizationsMy();
    case 'pcm':
      return AppLocalizationsPcm();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
    case 'uz':
      return AppLocalizationsUz();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
