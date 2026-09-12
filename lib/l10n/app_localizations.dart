import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
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
  /// **'Made For You'**
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
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
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
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
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
