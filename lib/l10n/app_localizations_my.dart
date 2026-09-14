// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title၊ $subtitle';
  }

  @override
  String get albums => 'အယ်လ်ဘမ်များ';

  @override
  String get api => 'API';

  @override
  String get artists => 'အနုပညာရှင်များ';

  @override
  String get artwork => 'အနုပညာလက်ရာ';

  @override
  String get appVersion => 'အက်ပ်ဗားရှင်း';

  @override
  String get artist => 'အနုပညာရှင်';

  @override
  String get artistsYouFollow => 'သင် follow ထားသော အနုပညာရှင်များ';

  @override
  String get autoplay => 'အလိုအလျောက်ဖွင့်မည်';

  @override
  String get becauseYouListenedTo => 'သင်နားဆင်ခဲ့သောကြောင့်';

  @override
  String get browseAll => 'အားလုံးကိုရှာဖွေရန်';

  @override
  String get cancel => 'ပယ်ဖျက်မည်';

  @override
  String get clearAppCache => 'အက်ပ် ကက်ရှ်ကို ရှင်းလင်းမလား။';

  @override
  String get clearCache => 'ကက်ရှ်ကို ရှင်းမည်';

  @override
  String get clearHistory => 'မှတ်တမ်းကို ရှင်းလင်းမလား။';

  @override
  String get clearRecentlyPlayed => 'လတ်တလော ဖွင့်ထားသည်များကို ရှင်းမည်';

  @override
  String get contentMarket => 'အကြောင်းအရာ ဈေးကွက်';

  @override
  String get continueListening => 'ဆက်လက်နားဆင်ရန်';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'ဗီဒီယိုကို ပြတင်းပေါက်ငယ်တွင် ဆက်ဖွင့်မည်';

  @override
  String get create => 'ဖန်တီးရန်';

  @override
  String get createAPlaylistToGetStarted => 'စတင်ရန် ဖွင့်စာရင်း ဖန်တီးပါ';

  @override
  String currentSelectedcountry(Object country) {
    return 'လက်ရှိ: $country';
  }

  @override
  String get deletePlaylist => 'ဖွင့်စာရင်းကို ဖျက်မည်';

  @override
  String get editProfile => 'ပရိုဖိုင်ကို ပြင်ဆင်ရန်';

  @override
  String errorLoadingMarkets(Object err) {
    return 'ဈေးကွက်များ တင်ရာတွင် အမှားဖြစ်နေပါသည်: $err';
  }

  @override
  String error(Object error) {
    return 'အမှား: $error';
  }

  @override
  String explore(Object genre) {
    return '$genre ကို ရှာဖွေပါ';
  }

  @override
  String get fansAlsoLike => 'ပရိသတ်များလည်း နှစ်သက်သည်';

  @override
  String featuringTouppercase(Object artist) {
    return '$artist ပါဝင်သည်';
  }

  @override
  String get featuredPlaylists => 'အထူးပြု ဖွင့်စာရင်းများ';

  @override
  String get followArtistsToSeeThemHere =>
      'အနုပညာရှင်များကို ဤနေရာတွင် မြင်တွေ့ရန် ၎င်းတို့ကို follow လုပ်ပါ';

  @override
  String get followStationsToSeeThemHere =>
      'စတေရှင်များကို ဤနေရာတွင် မြင်တွေ့ရန် ၎င်းတို့ကို follow လုပ်ပါ';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'ဒေတာသက်သာရန် အသံသီးသန့် ဖွင့်မည်';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'နေရာလွတ်ရစေပြီး နောက်တစ်ကြိမ်ဖွင့်ပါက ဒေတာအသစ်ပြန်ယူမည်';

  @override
  String get fromYourFavorites => 'သင်၏ အကြိုက်ဆုံးများမှ';

  @override
  String get goBack => 'နောက်သို့';

  @override
  String inspiredByName(Object name) {
    return '$name မှ စိတ်ကူးရယူထားသည်';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'တန်းစီထားသည်များ ပြီးဆုံးပါက အလားတူသီချင်းများကို ဆက်ဖွင့်မည်';

  @override
  String get library => 'စာကြည့်တိုက်';

  @override
  String get likeAlbumsToSeeThemHere =>
      'အယ်လ်ဘမ်များကို ဤနေရာတွင် မြင်တွေ့ရန် ၎င်းတို့ကို Like လုပ်ပါ';

  @override
  String get likedSongs => 'Like လုပ်ထားသော သီချင်းများ';

  @override
  String get lowDataMode => 'ဒေတာအနည်းဆုံးမုဒ်';

  @override
  String get madeForYou => 'သင့်အတွက် ပြုလုပ်ထားသည်';

  @override
  String moreLikeName(Object name) {
    return '$name နှင့် အလားတူများ';
  }

  @override
  String get moreOptions => 'နောက်ထပ် ရွေးချယ်စရာများ';

  @override
  String get nameYourMasterpiece => 'သင်၏ လက်ရာကို အမည်ပေးပါ...';

  @override
  String get newPlaylist => 'ဖွင့်စာရင်းအသစ်';

  @override
  String get newReleases => 'အသစ်ထွက်ရှိမှုများ';

  @override
  String get next => 'ရှေ့သို့';

  @override
  String get noAlbumsFound => 'အယ်လ်ဘမ်များ မတွေ့ပါ';

  @override
  String get noArtistsFollowed => 'Follow လုပ်ထားသော အနုပညာရှင် မရှိပါ';

  @override
  String get noArtistsFound => 'အနုပညာရှင် မတွေ့ပါ';

  @override
  String get noLikedAlbums => 'Like လုပ်ထားသော အယ်လ်ဘမ် မရှိပါ';

  @override
  String get noPlaylistsFound => 'ဖွင့်စာရင်း မတွေ့ပါ';

  @override
  String get noPlaylistsYet => 'ဖွင့်စာရင်း မရှိသေးပါ';

  @override
  String get noResultsFound => 'ရလဒ်များ မတွေ့ပါ';

  @override
  String get noStationsFollowed => 'Follow လုပ်ထားသော စတေရှင် မရှိပါ';

  @override
  String get noTrackPlaying => 'ဖွင့်နေသော သီချင်း မရှိပါ';

  @override
  String get noTracksFound => 'သီချင်းများ မတွေ့ပါ';

  @override
  String get playlists => 'ဖွင့်စာရင်းများ';

  @override
  String get popular => 'ရေပန်းစားသော';

  @override
  String get permanentlyRemoveListeningHistory =>
      'နားဆင်မှု မှတ်တမ်းကို အပြီးတိုင် ဖယ်ရှားမည်';

  @override
  String get pictureinpicturePip => 'ရုပ်ပုံတွင်း-ရုပ်ပုံ (PiP)';

  @override
  String get popularAlbums => 'ရေပန်းစားသော အယ်လ်ဘမ်များ';

  @override
  String get popularArtists => 'ရေပန်းစားသော အနုပညာရှင်များ';

  @override
  String get popularGenres => 'ရေပန်းစားသော ဂီတအမျိုးအစားများ';

  @override
  String get popularSongs => 'ရေပန်းစားသော သီချင်းများ';

  @override
  String get popularTracks => 'ရေပန်းစားသော သီချင်းများ';

  @override
  String get popularHitsRightNow => 'လက်ရှိ ရေပန်းစားနေသော သီချင်းများ';

  @override
  String get previous => 'နောက်သို့';

  @override
  String get queue => 'တန်းစီစာရင်း';

  @override
  String get recentSearches => 'လတ်တလော ရှာဖွေမှုများ';

  @override
  String get recommendedForYou => 'သင့်အတွက် အကြံပြုချက်';

  @override
  String get scraping => 'ခြစ်ယူခြင်း';

  @override
  String get search => 'ရှာဖွေရန်';

  @override
  String get searchInAlbum => 'အယ်လ်ဘမ်ထဲတွင် ရှာရန်...';

  @override
  String get searchInLibrary => 'စာကြည့်တိုက်ထဲတွင် ရှာရန်...';

  @override
  String get searchInPlaylist => 'ဖွင့်စာရင်းထဲတွင် ရှာရန်';

  @override
  String get searchLikedSongs => 'Like လုပ်ထားသော သီချင်းများတွင် ရှာရန်...';

  @override
  String get searchPopularSongs => 'ရေပန်းစားသော သီချင်းများတွင် ရှာရန်...';

  @override
  String get selectMarket => 'ဈေးကွက်ကို ရွေးချယ်ပါ';

  @override
  String get settings => 'ဆက်တင်များ';

  @override
  String get showVideoPlayer => 'ဗီဒီယို ပလေယာကို ပြမည်';

  @override
  String get shuffle => 'ရောနှောဖွင့်မည်';

  @override
  String get spotifyCredentials => 'Spotify အထောက်အထားများ';

  @override
  String get suggestedStations => 'အကြံပြုထားသော စတေရှင်များ';

  @override
  String get tracks => 'သီချင်းများ';

  @override
  String get trending => 'ရေပန်းစားနေသော';

  @override
  String get tryAgain => 'ထပ်မံကြိုးစားပါ';

  @override
  String get tryADifferentSearchTerm => 'အခြား ရှာဖွေမှုဝေါဟာရကို စမ်းကြည့်ပါ';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'ရရှိနိုင်ပါက YouTube ပလေယာကို အသုံးပြုမည်';

  @override
  String get video => 'ဗီဒီယို';

  @override
  String get whatDoYouWantToListenTo => 'ဘာကို နားဆင်ချင်ပါသလဲ။';

  @override
  String get youtubeCredentials => 'YouTube အထောက်အထားများ';

  @override
  String get yourLibrary => 'သင်၏ စာကြည့်တိုက်';

  @override
  String get playerscreenviewswitch =>
      'ကစားသမား_မျက်နှာပြင်_မြင်ကွင်း_ပြောင်းရန်';

  @override
  String get addToPlaylist => 'ဖွင့်စာရင်းသို့ ထည့်မည်';

  @override
  String get addToQueue => 'တန်းစီစာရင်းသို့ ထည့်မည်';

  @override
  String get copyId => 'ID ကို ကူးယူမည်';

  @override
  String get copyLink => 'လင့်ခ်ကို ကူးယူမည်';

  @override
  String get discover => 'ရှာဖွေတွေ့ရှိရန်';

  @override
  String get enterYourName => 'သင့်အမည်ကို ထည့်ပါ';

  @override
  String get favorites => 'အကြိုက်ဆုံးများ';

  @override
  String get goToAlbum => 'အယ်လ်ဘမ်သို့ သွားမည်';

  @override
  String get goToArtist => 'အနုပညာရှင်ထံ သွားမည်';

  @override
  String get goToArtistRadio => 'အနုပညာရှင် ရေဒီယိုသို့ သွားမည်';

  @override
  String get goToPlaylist => 'ဖွင့်စာရင်းသို့ သွားမည်';

  @override
  String get goToSongRadio => 'သီချင်း ရေဒီယိုသို့ သွားမည်';

  @override
  String get home => 'ပင်မစာမျက်နှာ';

  @override
  String get myAwesomePlaylist => 'ကျွန်ုပ်၏ အမိုက်စား ဖွင့်စာရင်း';

  @override
  String get myPlaylist => 'ကျွန်ုပ်၏ ဖွင့်စာရင်း';

  @override
  String get newPlaylist1 => 'ဖွင့်စာရင်းအသစ်';

  @override
  String get play => 'ဖွင့်မည်';

  @override
  String get playStation => 'စတေရှင်ကို ဖွင့်မည်';

  @override
  String get playNext => 'နောက်တစ်ခုကို ဖွင့်မည်';

  @override
  String get playlist => 'ဖွင့်စာရင်း';

  @override
  String get playlistName => 'ဖွင့်စာရင်း အမည်';

  @override
  String get playlists1 => 'ဖွင့်စာရင်းများ';

  @override
  String get queue1 => 'တန်းစီစာရင်း';

  @override
  String get recentlyPlayed => 'လတ်တလော ဖွင့်ထားသည်များ';

  @override
  String get removeFromQueue => 'တန်းစီစာရင်းမှ ဖယ်ရှားမည်';

  @override
  String get retry => 'ထပ်မံကြိုးစားမည်';

  @override
  String get searchMusicArtistsAlbums =>
      'ဂီတ၊ အနုပညာရှင်၊ အယ်လ်ဘမ်များကို ရှာရန်...';

  @override
  String get share => 'မျှဝေရန်';

  @override
  String featuringArtist(String artistName) {
    return '$artistName ပါဝင်သည်';
  }

  @override
  String currentCountry(String country) {
    return 'လက်ရှိ: $country';
  }

  @override
  String get queueTooltip => 'တန်းစီစာရင်း';

  @override
  String get searchHint => 'ဂီတ၊ အနုပညာရှင်၊ အယ်လ်ဘမ်များကို ရှာရန်...';

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get systemDefault => 'စနစ် မူလသတ်မှတ်ချက်';

  @override
  String get songsTab => 'သီချင်းများ';

  @override
  String get foldersTab => 'ဖိုင်တွဲများ';

  @override
  String get artistsTab => 'အနုပညာရှင်များ';

  @override
  String get albumsTab => 'အယ်လ်ဘမ်များ';

  @override
  String get addMusic => 'တေးဂီတ ပေါင်းထည့်ရန်';

  @override
  String get addFiles => 'ဖိုင်များ ပေါင်းထည့်ရန်';

  @override
  String get addFolder => 'ဖိုင်တွဲ ပေါင်းထည့်ရန်';

  @override
  String get rescanLibrary => 'ဒစ်ဂျစ်တယ် စာကြည့်တိုက်ကို ပြန်လည်စကင်ဖတ်ရန်';

  @override
  String get sortTitle => 'ခေါင်းစဉ်အလိုက် စီရန်';

  @override
  String get sortArtist => 'အနုပညာရှင်အလိုက် စီရန်';

  @override
  String get sortAlbum => 'အယ်လ်ဘမ်အလိုက် စီရန်';

  @override
  String get sortDuration => 'ကြာချိန်အလိုက် စီရန်';

  @override
  String get sortDateAdded => 'ပေါင်းထည့်သည့်ရက်စွဲအလိုက် စီရန်';

  @override
  String get trackInformation => 'တေးသွား အချက်အလက်';

  @override
  String get removeFromLibrary => 'ဒစ်ဂျစ်တယ် စာကြည့်တိုက်မှ ဖယ်ရှားရန်';

  @override
  String get showInFolder => 'ဖိုင်တွဲတွင် ပြရန်';

  @override
  String get unknownArtist => 'အမည်မသိ အနုပညာရှင်';

  @override
  String get unknownAlbum => 'အမည်မသိ အယ်လ်ဘမ်';

  @override
  String get importedFiles => 'တင်သွင်းထားသော ဖိုင်များ';

  @override
  String get playFolder => 'ဖိုင်တွဲ ဖွင့်ရန်';

  @override
  String get shuffleFolder => 'ဖိုင်တွဲ ရောမွှေရန်';

  @override
  String get playAll => 'အားလုံး ဖွင့်ရန်';

  @override
  String get includeSubfolders => 'ဖိုင်တွဲခွဲများ ပါဝင်ရန်';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count တေးသွား',
      one: '1 တေးသွား',
      zero: '0 တေးသွား',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'ဒေသန္တရ သီချင်းများ မတွေ့ပါ';

  @override
  String get searchLocalMusic => 'ဒေသန္တရ တေးဂီတကို ရှာရန်...';

  @override
  String get viewAsList => 'စာရင်းအဖြစ် ကြည့်ရန်';

  @override
  String get viewAsGrid => 'ဇယားကွက်အဖြစ် ကြည့်ရန်';

  @override
  String get trackInfoPath => 'လမ်းကြောင်း';

  @override
  String get trackInfoFormat => 'ဖော်မတ်';

  @override
  String get trackInfoDuration => 'ကြာချိန်';

  @override
  String get aboutDescription =>
      'အခမဲ့ဖြစ်သော အလွယ်တကူရနိုင်သည့် တေးဂီတဖွင့်စက်။';

  @override
  String versionInfo(Object version, Object build) {
    return 'ဗားရှင်း $version (တည်ဆောက်မှု $build)';
  }

  @override
  String get createdBy => 'Lucas Coelho မှ ဖန်တီးသည်';

  @override
  String get website => 'ဝဘ်ဆိုက်';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'ထုတ်ဝေမှု မှတ်စုများ';

  @override
  String get support => 'ပံ့ပိုးမှု';

  @override
  String get license => 'လိုင်စင်';

  @override
  String get acknowledgments => 'အသိအမှတ်ပြုမှုများ';

  @override
  String get close => 'ပိတ်ရန်';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer ပါဝင်ကူညီသူများ';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Your music is waiting.';

  @override
  String dailyMix(Object number) {
    return 'Daily Mix $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Your favorites\nand new discoveries';

  @override
  String get discoverWeekly => 'Discover Weekly';

  @override
  String get releaseRadar => 'Release Radar';

  @override
  String get newMusicJustForYou => 'New music\njust for you';

  @override
  String get chillMix => 'Chill Mix';

  @override
  String get relaxAndUnwind => 'Relax and unwind';

  @override
  String get focusMix => 'Focus Mix';

  @override
  String get deepFocusAndProductivity => 'Deep focus\nand productivity';

  @override
  String artistRadio(Object artist) {
    return '$artist Radio';
  }

  @override
  String genreRadio(Object genre) {
    return '$genre Radio';
  }

  @override
  String get filterAll => 'အားလုံး';

  @override
  String get filterPlaylists => 'အစီအစဉ်များ';

  @override
  String get filterArtists => 'အနုပညာရှင်များ';

  @override
  String get filterAlbums => 'အယ်လ်ဘမ်များ';

  @override
  String get filterStations => 'စခန်းများ';

  @override
  String get localMusicCard => 'ပြည်တွင်းတေးဂီတ';

  @override
  String get createPlaylistButton => 'အစီအစဉ်ဖန်တီးရန်';

  @override
  String get radioStations => 'ရေဒီယိုစခန်းများ';

  @override
  String get discoverMusic => 'တေးဂီတရှာဖွေရန်';

  @override
  String get importLocalMusic => 'ပြည်တွင်းတေးဂီတသွင်းရန်';

  @override
  String get importAudioFiles => 'အသံဖိုင်များသွင်းရန်';

  @override
  String get importFolder => 'ဖိုင်တွဲသွင်းရန်';
}
