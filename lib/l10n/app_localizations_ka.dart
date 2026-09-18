// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ალბომები';

  @override
  String get api => 'API';

  @override
  String get artists => 'შემსრულებლები';

  @override
  String get artwork => 'ყდა';

  @override
  String get appVersion => 'აპის ვერსია';

  @override
  String get artist => 'შემსრულებელი';

  @override
  String get artistsYouFollow => 'შემსრულებლები, რომლებსაც მიჰყვებით';

  @override
  String get autoplay => 'ავტომატური დაკვრა';

  @override
  String get becauseYouListenedTo => 'რადგან თქვენ უსმენდით';

  @override
  String get browseAll => 'ყველას დათვალიერება';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get clearAppCache => 'გასუფთავდეს აპის ქეში?';

  @override
  String get clearCache => 'ქეშის გასუფთავება';

  @override
  String get clearHistory => 'გასუფთავდეს ისტორია?';

  @override
  String get clearRecentlyPlayed => 'ახლახან დაკრულების გასუფთავება';

  @override
  String get contentMarket => 'კონტენტის ბაზარი';

  @override
  String get continueListening => 'მოსმენის გაგრძელება';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'ვიდეოს დაკვრის გაგრძელება პატარა ფანჯარაში';

  @override
  String get create => 'შექმნა';

  @override
  String get createAPlaylistToGetStarted => 'შექმენით დასაკრავი სია დასაწყებად';

  @override
  String currentSelectedcountry(Object country) {
    return 'მიმდინარე: $country';
  }

  @override
  String get deletePlaylist => 'დასაკრავი სიის წაშლა';

  @override
  String get editProfile => 'პროფილის რედაქტირება';

  @override
  String errorLoadingMarkets(Object err) {
    return 'ბაზრების ჩატვირთვის შეცდომა: $err';
  }

  @override
  String error(Object error) {
    return 'შეცდომა: $error';
  }

  @override
  String explore(Object genre) {
    return 'გამოიკვლიე $genre';
  }

  @override
  String get fansAlsoLike => 'ფანებს ასევე მოსწონთ';

  @override
  String featuringTouppercase(Object artist) {
    return 'მონაწილეობს $artist';
  }

  @override
  String get featuredPlaylists => 'რჩეული დასაკრავი სიები';

  @override
  String get followArtistsToSeeThemHere =>
      'მიჰყევით შემსრულებლებს, რომ ნახოთ ისინი აქ';

  @override
  String get followStationsToSeeThemHere =>
      'მიჰყევით სადგურებს, რომ ნახოთ ისინი აქ';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'მხოლოდ აუდიო ნაკადების იძულება მონაცემთა დაზოგვისთვის';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'ათავისუფლებს ადგილს და იძულებით ტვირთავს ახალ მონაცემებს';

  @override
  String get fromYourFavorites => 'თქვენი ფავორიტებიდან';

  @override
  String get goBack => 'უკან დაბრუნება';

  @override
  String inspiredByName(Object name) {
    return 'შთაგონებული $name-ით';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'მსგავსი ტრეკების დაკვრის გაგრძელება რიგის დასრულებისას';

  @override
  String get library => 'ბიბლიოთეკა';

  @override
  String get likeAlbumsToSeeThemHere => 'მოიწონეთ ალბომები, რომ ნახოთ ისინი აქ';

  @override
  String get likedSongs => 'მოწონებული სიმღერები';

  @override
  String get lowDataMode => 'მონაცემთა დაზოგვის რეჟიმი';

  @override
  String get madeForYou => 'შექმნილია თქვენთვის';

  @override
  String moreLikeName(Object name) {
    return 'მეტი, როგორც $name';
  }

  @override
  String get moreOptions => 'მეტი ვარიანტი';

  @override
  String get nameYourMasterpiece => 'დაარქვით სახელი თქვენს შედევრს...';

  @override
  String get newPlaylist => 'ახალი დასაკრავი სია';

  @override
  String get newReleases => 'ახალი გამოშვებები';

  @override
  String get next => 'შემდეგი';

  @override
  String get noAlbumsFound => 'ალბომები ვერ მოიძებნა';

  @override
  String get noArtistsFollowed => 'არ არის გამოწერილი შემსრულებლები';

  @override
  String get noArtistsFound => 'შემსრულებლები ვერ მოიძებნა';

  @override
  String get noLikedAlbums => 'არ არის მოწონებული ალბომები';

  @override
  String get noPlaylistsFound => 'დასაკრავი სიები ვერ მოიძებნა';

  @override
  String get noPlaylistsYet => 'დასაკრავი სიები ჯერ არ არის';

  @override
  String get noResultsFound => 'შედეგები ვერ მოიძებნა';

  @override
  String get noStationsFollowed => 'არ არის გამოწერილი სადგურები';

  @override
  String get noTrackPlaying => 'ტრეკი არ უკრავს';

  @override
  String get noTracksFound => 'ტრეკები ვერ მოიძებნა';

  @override
  String get playlists => 'დასაკრავი სიები';

  @override
  String get popular => 'პოპულარული';

  @override
  String get permanentlyRemoveListeningHistory =>
      'მოსმენის ისტორიის სამუდამოდ წაშლა';

  @override
  String get pictureinpicturePip => 'სურათი სურათში (PiP)';

  @override
  String get popularAlbums => 'პოპულარული ალბომები';

  @override
  String get popularArtists => 'პოპულარული შემსრულებლები';

  @override
  String get popularGenres => 'პოპულარული ჟანრები';

  @override
  String get popularSongs => 'პოპულარული სიმღერები';

  @override
  String get popularTracks => 'პოპულარული ტრეკები';

  @override
  String get popularHitsRightNow => 'პოპულარული ჰიტები ახლა';

  @override
  String get previous => 'წინა';

  @override
  String get queue => 'რიგი';

  @override
  String get recentSearches => 'ბოლო ძიებები';

  @override
  String get recommendedForYou => 'რეკომენდებულია თქვენთვის';

  @override
  String get scraping => 'მონაცემთა შეგროვება';

  @override
  String get search => 'ძიება';

  @override
  String get searchInAlbum => 'ძიება ალბომში...';

  @override
  String get searchInLibrary => 'ძიება ბიბლიოთეკაში...';

  @override
  String get searchInPlaylist => 'ძიება დასაკრავ სიაში';

  @override
  String get searchLikedSongs => 'ძიება მოწონებულ სიმღერებში...';

  @override
  String get searchPopularSongs => 'ძიება პოპულარულ სიმღერებში...';

  @override
  String get selectMarket => 'აირჩიეთ ბაზარი';

  @override
  String get settings => 'პარამეტრები';

  @override
  String get showVideoPlayer => 'ვიდეო პლეერის ჩვენება';

  @override
  String get shuffle => 'არევით დაკვრა';

  @override
  String get spotifyCredentials => 'Spotify სერთიფიკატები';

  @override
  String get suggestedStations => 'შემოთავაზებული სადგურები';

  @override
  String get tracks => 'ტრეკები';

  @override
  String get trending => 'ტრენდული';

  @override
  String get tryAgain => 'სცადეთ ხელახლა';

  @override
  String get tryADifferentSearchTerm => 'სცადეთ სხვა საძიებო სიტყვა';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'გამოიყენეთ YouTube პლეერი, როცა ხელმისაწვდომია';

  @override
  String get video => 'ვიდეო';

  @override
  String get whatDoYouWantToListenTo => 'რისი მოსმენა გსურთ?';

  @override
  String get youtubeCredentials => 'YouTube სერთიფიკატები';

  @override
  String get yourLibrary => 'თქვენი ბიბლიოთეკა';

  @override
  String get playerscreenviewswitch => 'მოთამაშის_ეკრანის_ნახვის_გადამრთველი';

  @override
  String get addToPlaylist => 'დასაკრავ სიაში დამატება';

  @override
  String get addToQueue => 'რიგში დამატება';

  @override
  String get copyId => 'ID-ის კოპირება';

  @override
  String get copyLink => 'ბმულის კოპირება';

  @override
  String get discover => 'აღმოჩენა';

  @override
  String get enterYourName => 'შეიყვანეთ თქვენი სახელი';

  @override
  String get favorites => 'ფავორიტები';

  @override
  String get goToAlbum => 'ალბომზე გადასვლა';

  @override
  String get goToArtist => 'შემსრულებელზე გადასვლა';

  @override
  String get goToArtistRadio => 'შემსრულებლის რადიოზე გადასვლა';

  @override
  String get goToPlaylist => 'დასაკრავ სიაზე გადასვლა';

  @override
  String get goToSongRadio => 'სიმღერის რადიოზე გადასვლა';

  @override
  String get home => 'მთავარი';

  @override
  String get myAwesomePlaylist => 'ჩემი მაგარი დასაკრავი სია';

  @override
  String get myPlaylist => 'ჩემი დასაკრავი სია';

  @override
  String get newPlaylist1 => 'ახალი დასაკრავი სია';

  @override
  String get play => 'დაკვრა';

  @override
  String get playStation => 'სადგურის დაკვრა';

  @override
  String get playNext => 'შემდეგის დაკვრა';

  @override
  String get playlist => 'დასაკრავი სია';

  @override
  String get playlistName => 'დასაკრავი სიის სახელი';

  @override
  String get playlists1 => 'დასაკრავი სიები';

  @override
  String get queue1 => 'რიგი';

  @override
  String get recentlyPlayed => 'ახლახან დაკრული';

  @override
  String get removeFromQueue => 'რიგიდან ამოღება';

  @override
  String get retry => 'ხელახლა ცდა';

  @override
  String get searchMusicArtistsAlbums =>
      'მოძებნეთ მუსიკა, შემსრულებლები, ალბომები...';

  @override
  String get share => 'გაზიარება';

  @override
  String featuringArtist(String artistName) {
    return 'მონაწილეობს $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'მიმდინარე: $country';
  }

  @override
  String get queueTooltip => 'რიგი';

  @override
  String get searchHint => 'მოძებნეთ მუსიკა, შემსრულებლები, ალბომები...';

  @override
  String get language => 'ენა';

  @override
  String get systemDefault => 'სისტემის ნაგულისხმევი';

  @override
  String get songsTab => 'სიმღერები';

  @override
  String get foldersTab => 'საქაღალდეები';

  @override
  String get artistsTab => 'შემსრულებლები';

  @override
  String get albumsTab => 'ალბომები';

  @override
  String get genresTab => 'Genres';

  @override
  String get noLocalGenres => 'No local genres found';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get addMusic => 'მუსიკის დამატება';

  @override
  String get addFiles => 'ფაილების დამატება';

  @override
  String get addFolder => 'საქაღალდის დამატება';

  @override
  String get rescanLibrary => 'ბიბლიოთეკის ხელახლა სკანირება';

  @override
  String get sortTitle => 'დალაგება სათაურის მიხედვით';

  @override
  String get sortArtist => 'დალაგება შემსრულებლის მიხედვით';

  @override
  String get sortAlbum => 'დალაგება ალბომის მიხედვით';

  @override
  String get sortDuration => 'დალაგება ხანგრძლივობის მიხედვით';

  @override
  String get sortDateAdded => 'დალაგება დამატების თარიღის მიხედვით';

  @override
  String get trackInformation => 'ტრეკის ინფორმაცია';

  @override
  String get removeFromLibrary => 'ბიბლიოთეკიდან ამოღება';

  @override
  String get showInFolder => 'საქაღალდეში ჩვენება';

  @override
  String get unknownArtist => 'უცნობი შემსრულებელი';

  @override
  String get unknownAlbum => 'უცნობი ალბომი';

  @override
  String get importedFiles => 'იმპორტირებული ფაილები';

  @override
  String get playFolder => 'საქაღალდის დაკვრა';

  @override
  String get shuffleFolder => 'საქაღალდის შემთხვევითი დაკვრა';

  @override
  String get playAll => 'ყველას დაკვრა';

  @override
  String get includeSubfolders => 'ქვესაქაღალდეების ჩართვა';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ტრეკი',
      one: '1 ტრეკი',
      zero: '0 ტრეკი',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'ლოკალური სიმღერები ვერ მოიძებნა';

  @override
  String get searchLocalMusic => 'ლოკალური მუსიკის ძიება...';

  @override
  String get viewAsList => 'სიის სახით ნახვა';

  @override
  String get viewAsGrid => 'ბადის სახით ნახვა';

  @override
  String get trackInfoPath => 'გზა';

  @override
  String get trackInfoFormat => 'ფორმატი';

  @override
  String get trackInfoDuration => 'ხანგრძლივობა';

  @override
  String get aboutDescription => 'უფასო, ღია კოდის მქონე მუსიკალური პლეერი.';

  @override
  String versionInfo(Object version, Object build) {
    return 'ვერსია $version (Build $build)';
  }

  @override
  String get createdBy => 'შექმნილია Lucas Coelho-ს მიერ';

  @override
  String get website => 'ვებგვერდი';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'გამოშვების შენიშვნები';

  @override
  String get support => 'მხარდაჭერა';

  @override
  String get license => 'ლიცენზია';

  @override
  String get acknowledgments => 'მადლობები';

  @override
  String get close => 'დახურვა';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer კონტრიბუტორები';
  }

  @override
  String get goodMorning => 'დილა მშვიდობისა';

  @override
  String get goodAfternoon => 'შუადღე მშვიდობისა';

  @override
  String get goodEvening => 'საღამო მშვიდობისა';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'შენი მუსიკა გელოდება.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'შენი ფავორიტები\nდა ახალი აღმოჩენები';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'ახალი მუსიკა\nმხოლოდ შენთვის';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'დაისვენე და განიტვირთე';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'ღრმა ფოკუსი\nდა პროდუქტიულობა';

  @override
  String artistRadio(Object artist) {
    return '$artist რადიო';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre რადიო';
  }

  @override
  String get filterAll => 'ყველა';

  @override
  String get filterPlaylists => 'დასაკრავი სიები';

  @override
  String get filterArtists => 'შემსრულებლები';

  @override
  String get filterAlbums => 'ალბომები';

  @override
  String get filterStations => 'სადგურები';

  @override
  String get localMusicCard => 'ლოკალური მუსიკა';

  @override
  String get createPlaylistButton => 'დასაკრავი სიის შექმნა';

  @override
  String get radioStations => 'რადიოსადგურები';

  @override
  String get discoverMusic => 'აღმოაჩინე მუსიკა';

  @override
  String get importLocalMusic => 'ლოკალური მუსიკის იმპორტი';

  @override
  String get importAudioFiles => 'აუდიო ფაილების იმპორტი';

  @override
  String get importFolder => 'საქაღალდის იმპორტი';

  @override
  String get importFolderSubtitle =>
      'აირჩიეთ საქაღალდე, რომელიც შეიცავს აუდიო ფაილებს';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Unsupported format or corrupted file';

  @override
  String get playbackErrorFileInaccessible => 'File inaccessible or not found';
}
