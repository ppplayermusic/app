// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'অ্যালবাম';

  @override
  String get api => 'API';

  @override
  String get artists => 'শিল্পী';

  @override
  String get artwork => 'প্রচ্ছদ';

  @override
  String get appVersion => 'অ্যাপ সংস্করণ';

  @override
  String get artist => 'শিল্পী';

  @override
  String get artistsYouFollow => 'আপনি যেসব শিল্পী অনুসরণ করেন';

  @override
  String get autoplay => 'স্বয়ংক্রিয় প্লে';

  @override
  String get becauseYouListenedTo => 'কারণ আপনি শুনেছিলেন';

  @override
  String get browseAll => 'সব দেখুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get clearAppCache => 'অ্যাপ ক্যাশ মুছবেন?';

  @override
  String get clearCache => 'ক্যাশ মুছুন';

  @override
  String get clearHistory => 'ইতিহাস মুছবেন?';

  @override
  String get clearRecentlyPlayed => 'সম্প্রতি বাজানো মুছুন';

  @override
  String get contentMarket => 'কন্টেন্ট মার্কেট';

  @override
  String get continueListening => 'শোনা চালিয়ে যান';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'ছোট উইন্ডোতে ভিডিও চালিয়ে যান';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get createAPlaylistToGetStarted =>
      'শুরু করতে একটি প্লেলিস্ট তৈরি করুন';

  @override
  String currentSelectedcountry(Object country) {
    return 'বর্তমান: $country';
  }

  @override
  String get deletePlaylist => 'প্লেলিস্ট মুছুন';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String errorLoadingMarkets(Object err) {
    return 'মার্কেট লোড করতে ত্রুটি: $err';
  }

  @override
  String error(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String explore(Object genre) {
    return '$genre অন্বেষণ করুন';
  }

  @override
  String get fansAlsoLike => 'ভক্তরাও পছন্দ করেন';

  @override
  String featuringTouppercase(Object artist) {
    return 'বিশেষ অতিথি $artist';
  }

  @override
  String get featuredPlaylists => 'বৈশিষ্ট্যযুক্ত প্লেলিস্ট';

  @override
  String get followArtistsToSeeThemHere =>
      'শিল্পী অনুসরণ করুন, তারা এখানে দেখাবে';

  @override
  String get followStationsToSeeThemHere =>
      'স্টেশন অনুসরণ করুন, তারা এখানে দেখাবে';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'ডেটা সাশ্রয়ে শুধু অডিও স্ট্রিম বাধ্য করুন';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'জায়গা খালি করে এবং পরবর্তী লোডে নতুন ডেটা আনে';

  @override
  String get fromYourFavorites => 'আপনার পছন্দের থেকে';

  @override
  String get goBack => 'পিছনে যান';

  @override
  String inspiredByName(Object name) {
    return '$name দ্বারা অনুপ্রাণিত';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'সারি শেষ হলে একই ধরনের গান বাজাতে থাকুন';

  @override
  String get library => 'লাইব্রেরি';

  @override
  String get likeAlbumsToSeeThemHere => 'অ্যালবাম পছন্দ করুন, এখানে দেখাবে';

  @override
  String get likedSongs => 'পছন্দের গান';

  @override
  String get lowDataMode => 'কম ডেটা মোড';

  @override
  String get madeForYou => 'আপনার জন্য তৈরি';

  @override
  String moreLikeName(Object name) {
    return '$name-এর মতো আরও';
  }

  @override
  String get moreOptions => 'আরও বিকল্প';

  @override
  String get nameYourMasterpiece => 'আপনার মাস্টারপিসের নাম দিন...';

  @override
  String get newPlaylist => 'নতুন প্লেলিস্ট';

  @override
  String get newReleases => 'নতুন প্রকাশনা';

  @override
  String get next => 'পরবর্তী';

  @override
  String get noAlbumsFound => 'কোনো অ্যালবাম পাওয়া যায়নি';

  @override
  String get noArtistsFollowed => 'কোনো শিল্পী অনুসরণ করা হয়নি';

  @override
  String get noArtistsFound => 'কোনো শিল্পী পাওয়া যায়নি';

  @override
  String get noLikedAlbums => 'পছন্দের কোনো অ্যালবাম নেই';

  @override
  String get noPlaylistsFound => 'কোনো প্লেলিস্ট পাওয়া যায়নি';

  @override
  String get noPlaylistsYet => 'এখনও কোনো প্লেলিস্ট নেই';

  @override
  String get noResultsFound => 'কোনো ফলাফল পাওয়া যায়নি';

  @override
  String get noStationsFollowed => 'কোনো স্টেশন অনুসরণ করা হয়নি';

  @override
  String get noTrackPlaying => 'কোনো গান বাজছে না';

  @override
  String get noTracksFound => 'কোনো গান পাওয়া যায়নি';

  @override
  String get playlists => 'প্লেলিস্ট';

  @override
  String get popular => 'জনপ্রিয়';

  @override
  String get permanentlyRemoveListeningHistory =>
      'শোনার ইতিহাস স্থায়ীভাবে মুছুন';

  @override
  String get pictureinpicturePip => 'পিকচার-ইন-পিকচার (PiP)';

  @override
  String get popularAlbums => 'জনপ্রিয় অ্যালবাম';

  @override
  String get popularArtists => 'জনপ্রিয় শিল্পী';

  @override
  String get popularGenres => 'জনপ্রিয় ঘরানা';

  @override
  String get popularSongs => 'জনপ্রিয় গান';

  @override
  String get popularTracks => 'জনপ্রিয় ট্র্যাক';

  @override
  String get popularHitsRightNow => 'এখন জনপ্রিয় হিট';

  @override
  String get previous => 'আগেরটি';

  @override
  String get queue => 'সারি';

  @override
  String get recentSearches => 'সাম্প্রতিক অনুসন্ধান';

  @override
  String get recommendedForYou => 'আপনার জন্য প্রস্তাবিত';

  @override
  String get scraping => 'ডেটা সংগ্রহ হচ্ছে';

  @override
  String get search => 'অনুসন্ধান';

  @override
  String get searchInAlbum => 'অ্যালবামে অনুসন্ধান করুন...';

  @override
  String get searchInLibrary => 'লাইব্রেরিতে অনুসন্ধান করুন...';

  @override
  String get searchInPlaylist => 'প্লেলিস্টে অনুসন্ধান করুন';

  @override
  String get searchLikedSongs => 'পছন্দের গান অনুসন্ধান করুন...';

  @override
  String get searchPopularSongs => 'জনপ্রিয় গান অনুসন্ধান করুন...';

  @override
  String get selectMarket => 'মার্কেট নির্বাচন করুন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get showVideoPlayer => 'ভিডিও প্লেয়ার দেখান';

  @override
  String get shuffle => 'শাফল';

  @override
  String get spotifyCredentials => 'Spotify পরিচয়পত্র';

  @override
  String get suggestedStations => 'প্রস্তাবিত স্টেশন';

  @override
  String get tracks => 'ট্র্যাক';

  @override
  String get trending => 'ট্রেন্ডিং';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get tryADifferentSearchTerm => 'ভিন্ন অনুসন্ধান শব্দ চেষ্টা করুন';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'উপলব্ধ হলে YouTube প্লেয়ার ব্যবহার করুন';

  @override
  String get video => 'ভিডিও';

  @override
  String get whatDoYouWantToListenTo => 'আপনি কী শুনতে চান?';

  @override
  String get youtubeCredentials => 'YouTube পরিচয়পত্র';

  @override
  String get yourLibrary => 'আপনার লাইব্রেরি';

  @override
  String get playerscreenviewswitch => 'প্লেয়ার_স্ক্রিন_ভিউ_সুইচ';

  @override
  String get addToPlaylist => 'প্লেলিস্টে যোগ করুন';

  @override
  String get addToQueue => 'সারিতে যোগ করুন';

  @override
  String get copyId => 'আইডি কপি করুন';

  @override
  String get copyLink => 'লিঙ্ক কপি করুন';

  @override
  String get discover => 'আবিষ্কার করুন';

  @override
  String get enterYourName => 'আপনার নাম লিখুন';

  @override
  String get favorites => 'পছন্দের গান';

  @override
  String get goToAlbum => 'অ্যালবামে যান';

  @override
  String get goToArtist => 'শিল্পীর কাছে যান';

  @override
  String get goToArtistRadio => 'শিল্পী রেডিওতে যান';

  @override
  String get goToPlaylist => 'প্লেলিস্টে যান';

  @override
  String get goToSongRadio => 'গান রেডিওতে যান';

  @override
  String get home => 'হোম';

  @override
  String get myAwesomePlaylist => 'আমার দারুণ প্লেলিস্ট';

  @override
  String get myPlaylist => 'আমার প্লেলিস্ট';

  @override
  String get newPlaylist1 => 'নতুন প্লেলিস্ট';

  @override
  String get play => 'বাজান';

  @override
  String get playStation => 'স্টেশন বাজান';

  @override
  String get playNext => 'পরবর্তীতে বাজান';

  @override
  String get playlist => 'প্লেলিস্ট';

  @override
  String get playlistName => 'প্লেলিস্টের নাম';

  @override
  String get playlists1 => 'প্লেলিস্ট';

  @override
  String get queue1 => 'সারি';

  @override
  String get recentlyPlayed => 'সম্প্রতি বাজানো';

  @override
  String get removeFromQueue => 'সারি থেকে সরান';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get searchMusicArtistsAlbums => 'সঙ্গীত, শিল্পী, অ্যালবাম...';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String featuringArtist(String artistName) {
    return 'বিশেষ অতিথি $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'বর্তমান: $country';
  }

  @override
  String get queueTooltip => 'সারি';

  @override
  String get searchHint => 'সঙ্গীত, শিল্পী, অ্যালবাম...';

  @override
  String get language => 'ভাষা';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get songsTab => 'গান';

  @override
  String get foldersTab => 'ফোল্ডার';

  @override
  String get artistsTab => 'শিল্পী';

  @override
  String get albumsTab => 'অ্যালবাম';

  @override
  String get genresTab => 'জনরা';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'প্লেব্যাক স্পিড';

  @override
  String get addMusic => 'মিউজিক যোগ করুন';

  @override
  String get addFiles => 'ফাইল যোগ করুন';

  @override
  String get addFolder => 'ফোল্ডার যোগ করুন';

  @override
  String get rescanLibrary => 'লাইব্রেরি আবার স্ক্যান করুন';

  @override
  String get sortTitle => 'শিরোনাম অনুযায়ী সাজান';

  @override
  String get sortArtist => 'শিল্পী অনুযায়ী সাজান';

  @override
  String get sortAlbum => 'অ্যালবাম অনুযায়ী সাজান';

  @override
  String get sortDuration => 'সময়কাল অনুযায়ী সাজান';

  @override
  String get sortDateAdded => 'যোগ করার তারিখ অনুযায়ী সাজান';

  @override
  String get sortBy => 'সাজান';

  @override
  String get trackInformation => 'ট্র্যাকের তথ্য';

  @override
  String get removeFromLibrary => 'লাইব্রেরি থেকে সরান';

  @override
  String get showInFolder => 'ফোল্ডারে দেখান';

  @override
  String get unknownArtist => 'অজানা শিল্পী';

  @override
  String get unknownAlbum => 'অজানা অ্যালবাম';

  @override
  String get importedFiles => 'আমদানিকৃত ফাইল';

  @override
  String get playFolder => 'ফোল্ডার চালান';

  @override
  String get shuffleFolder => 'ফোল্ডার শাফেল করুন';

  @override
  String get playAll => 'সব চালান';

  @override
  String get includeSubfolders => 'সাবফোল্ডার অন্তর্ভুক্ত করুন';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ট্র্যাক',
      one: '1 ট্র্যাক',
      zero: '0 ট্র্যাক',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'কোনো লোকাল গান পাওয়া যায়নি';

  @override
  String get searchLocalMusic => 'লোকাল মিউজিক খুঁজুন...';

  @override
  String get viewAsList => 'তালিকা হিসেবে দেখুন';

  @override
  String get viewAsGrid => 'গ্রিড হিসেবে দেখুন';

  @override
  String get trackInfoPath => 'পথ';

  @override
  String get trackInfoFormat => 'ফরম্যাট';

  @override
  String get trackInfoDuration => 'সময়কাল';

  @override
  String get aboutDescription =>
      'একটি বিনামূল্যের এবং ওপেন সোর্স মিডিয়া প্লেয়ার।';

  @override
  String get aboutApp => 'PPPlayer সম্পর্কে';

  @override
  String get appTagline => 'আপনার মিউজিক। আপনার মতো করে।';

  @override
  String get exploreApp => 'PPPlayer অন্বেষণ করুন';

  @override
  String get viewSource => 'সোর্স দেখুন';

  @override
  String get seeWhatsNew => 'নতুন কী আছে দেখুন';

  @override
  String get getHelp => 'সাহায্য পান';

  @override
  String versionInfo(Object version, Object build) {
    return 'সংস্করণ $version (বিল্ড $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho দ্বারা তৈরি';

  @override
  String get website => 'ওয়েবসাইট';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'রিলিজ নোট';

  @override
  String get support => 'সমর্থন';

  @override
  String get license => 'লাইসেন্স';

  @override
  String get acknowledgments => 'স্বীকৃতি';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer অবদানকারী';
  }

  @override
  String get goodMorning => 'শুভ সকাল';

  @override
  String get goodAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get goodEvening => 'শুভ সন্ধ্যা';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'আপনার গান আপনার জন্য অপেক্ষা করছে।';

  @override
  String dailyMix(Object number) {
    return 'ডেইলি মিক্স $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'আপনার প্রিয়\nএবং নতুন আবিষ্কার';

  @override
  String get discoverWeekly => 'ডিসকভার উইকলি';

  @override
  String get releaseRadar => 'রিলিজ রাডার';

  @override
  String get newMusicJustForYou => 'আপনার জন্য\nনতুন গান';

  @override
  String get chillMix => 'চিল মিক্স';

  @override
  String get relaxAndUnwind => 'আরাম করুন';

  @override
  String get focusMix => 'ফোকাস মিক্স';

  @override
  String get deepFocusAndProductivity => 'গভীর মনোযোগ\nএবং কর্মক্ষমতা';

  @override
  String artistRadio(Object artist) {
    return '$artist রেডিও';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre রেডিও';
  }

  @override
  String get filterAll => 'সব';

  @override
  String get filterPlaylists => 'প্লেলিস্ট';

  @override
  String get filterArtists => 'শিল্পীরা';

  @override
  String get filterAlbums => 'অ্যালবাম';

  @override
  String get filterStations => 'স্টেশন';

  @override
  String get filterStreams => 'স্ট্রিম';

  @override
  String get localMusicCard => 'স্থানীয় সঙ্গীত';

  @override
  String get createPlaylistButton => 'প্লেলিস্ট তৈরি করুন';

  @override
  String get radioStations => 'রেডিও স্টেশন';

  @override
  String get discoverMusic => 'সঙ্গীত আবিষ্কার করুন';

  @override
  String get importLocalMusic => 'স্থানীয় সঙ্গীত আমদানি করুন';

  @override
  String get importAudioFiles => 'অডিও ফাইল আমদানি করুন';

  @override
  String get importFolder => 'ফোল্ডার আমদানি করুন';

  @override
  String get importFolderSubtitle =>
      'অডিও ফাইল ধারণকারী একটি ফোল্ডার চয়ন করুন';

  @override
  String get importPlaylist => 'প্লেলিস্ট ইমপোর্ট করুন';

  @override
  String get importPlaylistSubtitle => '.m3u বা .m3u8 ফাইল ইমপোর্ট করুন';

  @override
  String get exportPlaylist => 'প্লেলিস্ট এক্সপোর্ট করুন';

  @override
  String get playbackErrorUnsupportedFormat => 'অসমর্থিত বিন্যাস বা দূষিত ফাইল';

  @override
  String get playbackErrorFileInaccessible =>
      'ফাইল অ্যাক্সেসযোগ্য নয় বা পাওয়া যায় নি';

  @override
  String get localVideosCard => 'লোকাল ভিডিও';

  @override
  String get noLocalVideos => 'কোনো ভিডিও পাওয়া যায়নি';

  @override
  String get searchLocalVideos => 'লোকাল ভিডিও খুঁজুন';

  @override
  String get addVideos => 'ভিডিও যোগ করুন';

  @override
  String get subtitles => 'সাবটাইটেল';

  @override
  String get audioTracks => 'অডিও ট্র্যাক';

  @override
  String get loadSubtitleFile => 'সাবটাইটেল ফাইল লোড করুন...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'সাবটাইটেল লোড করতে ত্রুটি: $error';
  }

  @override
  String get off => 'বন্ধ';
}
