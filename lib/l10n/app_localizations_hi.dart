// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'एल्बम';

  @override
  String get api => 'API';

  @override
  String get artists => 'कलाकार';

  @override
  String get artwork => 'आर्टवर्क';

  @override
  String get appVersion => 'ऐप वर्ज़न';

  @override
  String get artist => 'कलाकार';

  @override
  String get artistsYouFollow => 'कलाकार जिन्हें आप फॉलो करते हैं';

  @override
  String get autoplay => 'ऑटोप्ले';

  @override
  String get becauseYouListenedTo => 'क्योंकि आपने सुना';

  @override
  String get browseAll => 'सभी ब्राउज़ करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get clearAppCache => 'ऐप कैश साफ़ करें?';

  @override
  String get clearCache => 'कैश साफ़ करें';

  @override
  String get clearHistory => 'इतिहास साफ़ करें?';

  @override
  String get clearRecentlyPlayed => 'हाल ही में चलाए गए साफ़ करें';

  @override
  String get contentMarket => 'कंटेंट मार्केट';

  @override
  String get continueListening => 'सुनना जारी रखें';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'छोटी विंडो में वीडियो प्लेबैक जारी रखें';

  @override
  String get create => 'बनाएं';

  @override
  String get createAPlaylistToGetStarted =>
      'शुरू करने के लिए एक प्लेलिस्ट बनाएं';

  @override
  String currentSelectedcountry(Object country) {
    return 'वर्तमान: $country';
  }

  @override
  String get deletePlaylist => 'प्लेलिस्ट हटाएं';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String errorLoadingMarkets(Object err) {
    return 'बाज़ार लोड करने में त्रुटि: $err';
  }

  @override
  String error(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String explore(Object genre) {
    return '$genre एक्सप्लोर करें';
  }

  @override
  String get fansAlsoLike => 'प्रशंसकों को यह भी पसंद है';

  @override
  String featuringTouppercase(Object artist) {
    return '$artist की विशेषता';
  }

  @override
  String get featuredPlaylists => 'विशेष प्लेलिस्ट';

  @override
  String get followArtistsToSeeThemHere =>
      'कलाकारों को यहां देखने के लिए उन्हें फॉलो करें';

  @override
  String get followStationsToSeeThemHere =>
      'स्टेशनों को यहां देखने के लिए उन्हें फॉलो करें';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'डेटा बचाने के लिए केवल ऑडियो स्ट्रीम को फ़ोर्स करें';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'स्थान खाली करता है और अगले लोड पर ताज़ा डेटा को फ़ोर्स करता है';

  @override
  String get fromYourFavorites => 'आपके पसंदीदा से';

  @override
  String get goBack => 'वापस जाएं';

  @override
  String inspiredByName(Object name) {
    return '$name से प्रेरित';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'कतार समाप्त होने पर समान ट्रैक बजाना जारी रखें';

  @override
  String get library => 'लाइब्रेरी';

  @override
  String get likeAlbumsToSeeThemHere =>
      'एल्बम को यहां देखने के लिए उन्हें पसंद करें';

  @override
  String get likedSongs => 'पसंद किए गए गाने';

  @override
  String get lowDataMode => 'लो डेटा मोड';

  @override
  String get madeForYou => 'आपके लिए बनाया गया';

  @override
  String moreLikeName(Object name) {
    return '$name के समान और';
  }

  @override
  String get moreOptions => 'अधिक विकल्प';

  @override
  String get nameYourMasterpiece => 'अपनी उत्कृष्ट कृति का नाम दें...';

  @override
  String get newPlaylist => 'नई प्लेलिस्ट';

  @override
  String get newReleases => 'नई रिलीज़';

  @override
  String get next => 'अगला';

  @override
  String get noAlbumsFound => 'कोई एल्बम नहीं मिला';

  @override
  String get noArtistsFollowed => 'किसी भी कलाकार को फॉलो नहीं किया गया';

  @override
  String get noArtistsFound => 'कोई कलाकार नहीं मिला';

  @override
  String get noLikedAlbums => 'कोई पसंदीदा एल्बम नहीं';

  @override
  String get noPlaylistsFound => 'कोई प्लेलिस्ट नहीं मिली';

  @override
  String get noPlaylistsYet => 'अभी तक कोई प्लेलिस्ट नहीं';

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला';

  @override
  String get noStationsFollowed => 'किसी भी स्टेशन को फॉलो नहीं किया गया';

  @override
  String get noTrackPlaying => 'कोई ट्रैक नहीं चल रहा है';

  @override
  String get noTracksFound => 'कोई ट्रैक नहीं मिला';

  @override
  String get playlists => 'प्लेलिस्ट';

  @override
  String get popular => 'लोकप्रिय';

  @override
  String get permanentlyRemoveListeningHistory =>
      'सुनने का इतिहास स्थायी रूप से निकालें';

  @override
  String get pictureinpicturePip => 'पिक्चर-इन-पिक्चर (PiP)';

  @override
  String get popularAlbums => 'लोकप्रिय एल्बम';

  @override
  String get popularArtists => 'लोकप्रिय कलाकार';

  @override
  String get popularGenres => 'लोकप्रिय शैलियां';

  @override
  String get popularSongs => 'लोकप्रिय गाने';

  @override
  String get popularTracks => 'लोकप्रिय ट्रैक';

  @override
  String get popularHitsRightNow => 'अभी के लोकप्रिय हिट';

  @override
  String get previous => 'पिछला';

  @override
  String get queue => 'कतार';

  @override
  String get recentSearches => 'हाल की खोजें';

  @override
  String get recommendedForYou => 'आपके लिए अनुशंसित';

  @override
  String get scraping => 'स्क्रैपिंग';

  @override
  String get search => 'खोजें';

  @override
  String get searchInAlbum => 'एल्बम में खोजें...';

  @override
  String get searchInLibrary => 'लाइब्रेरी में खोजें...';

  @override
  String get searchInPlaylist => 'प्लेलिस्ट में खोजें';

  @override
  String get searchLikedSongs => 'पसंद किए गए गानों में खोजें...';

  @override
  String get searchPopularSongs => 'लोकप्रिय गानों में खोजें...';

  @override
  String get selectMarket => 'बाज़ार चुनें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get showVideoPlayer => 'वीडियो प्लेयर दिखाएं';

  @override
  String get shuffle => 'शफ़ल करें';

  @override
  String get spotifyCredentials => 'स्पॉटिफ़ाई क्रेडेंशियल';

  @override
  String get suggestedStations => 'सुझाए गए स्टेशन';

  @override
  String get tracks => 'ट्रैक';

  @override
  String get trending => 'ट्रेंडिंग';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get tryADifferentSearchTerm => 'एक अलग खोज शब्द आज़माएं';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'उपलब्ध होने पर YouTube प्लेयर का उपयोग करें';

  @override
  String get video => 'वीडियो';

  @override
  String get whatDoYouWantToListenTo => 'आप क्या सुनना चाहते हैं?';

  @override
  String get youtubeCredentials => 'यूट्यूब क्रेडेंशियल';

  @override
  String get yourLibrary => 'आपकी लाइब्रेरी';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'प्लेलिस्ट में जोड़ें';

  @override
  String get addToQueue => 'कतार में जोड़ें';

  @override
  String get copyId => 'ID कॉपी करें';

  @override
  String get copyLink => 'लिंक कॉपी करें';

  @override
  String get discover => 'खोजें';

  @override
  String get enterYourName => 'अपना नाम दर्ज करें';

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get goToAlbum => 'एल्बम पर जाएं';

  @override
  String get goToArtist => 'कलाकार पर जाएं';

  @override
  String get goToArtistRadio => 'कलाकार रेडियो पर जाएं';

  @override
  String get goToPlaylist => 'प्लेलिस्ट पर जाएं';

  @override
  String get goToSongRadio => 'गाना रेडियो पर जाएं';

  @override
  String get home => 'होम';

  @override
  String get myAwesomePlaylist => 'मेरी शानदार प्लेलिस्ट';

  @override
  String get myPlaylist => 'मेरी प्लेलिस्ट';

  @override
  String get newPlaylist1 => 'नई प्लेलिस्ट';

  @override
  String get play => 'चलाएं';

  @override
  String get playStation => 'स्टेशन चलाएं';

  @override
  String get playNext => 'अगला चलाएं';

  @override
  String get playlist => 'प्लेलिस्ट';

  @override
  String get playlistName => 'प्लेलिस्ट का नाम';

  @override
  String get playlists1 => 'प्लेलिस्ट';

  @override
  String get queue1 => 'कतार';

  @override
  String get recentlyPlayed => 'हाल ही में चलाए गए';

  @override
  String get removeFromQueue => 'कतार से निकालें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get searchMusicArtistsAlbums => 'संगीत, कलाकार, एल्बम खोजें...';

  @override
  String get share => 'साझा करें';

  @override
  String featuringArtist(String artistName) {
    return '$artistName की विशेषता';
  }

  @override
  String currentCountry(String country) {
    return 'वर्तमान: $country';
  }

  @override
  String get queueTooltip => 'कतार';

  @override
  String get searchHint => 'संगीत, कलाकार, एल्बम खोजें...';

  @override
  String get language => 'भाषा';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

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
