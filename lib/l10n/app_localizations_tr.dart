// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBÜMLER';

  @override
  String get api => 'API';

  @override
  String get artists => 'SANATÇILAR';

  @override
  String get artwork => 'KAPAK';

  @override
  String get appVersion => 'Uygulama sürümü';

  @override
  String get artist => 'Sanatçı';

  @override
  String get artistsYouFollow => 'Takip ettiğin sanatçılar';

  @override
  String get autoplay => 'Otomatik oynat';

  @override
  String get becauseYouListenedTo => 'Şunu dinlediğin için:';

  @override
  String get browseAll => 'Tümüne göz at';

  @override
  String get cancel => 'İptal';

  @override
  String get clearAppCache => 'Uygulama Önbelleğini Temizle?';

  @override
  String get clearCache => 'Önbelleği Temizle';

  @override
  String get clearHistory => 'Geçmişi Temizle?';

  @override
  String get clearRecentlyPlayed => 'Son Çalınanları Temizle';

  @override
  String get contentMarket => 'İçerik Pazarı';

  @override
  String get continueListening => 'Dinlemeye Devam Et';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Video oynatımına küçük bir pencerede devam et';

  @override
  String get create => 'Oluştur';

  @override
  String get createAPlaylistToGetStarted =>
      'Başlamak için bir çalma listesi oluşturun';

  @override
  String currentSelectedcountry(Object country) {
    return 'Mevcut: $country';
  }

  @override
  String get deletePlaylist => 'Çalma Listesini Sil';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Pazarlar yüklenirken hata oluştu: $err';
  }

  @override
  String error(Object error) {
    return 'Hata: $error';
  }

  @override
  String explore(Object genre) {
    return 'Keşfet: $genre';
  }

  @override
  String get fansAlsoLike => 'HAYRANLAR BUNLARI DA BEĞENDİ';

  @override
  String featuringTouppercase(Object artist) {
    return 'EŞLİK EDEN: $artist';
  }

  @override
  String get featuredPlaylists => 'Öne Çıkan Çalma Listeleri';

  @override
  String get followArtistsToSeeThemHere =>
      'Sanatçıları takip ederek burada görün';

  @override
  String get followStationsToSeeThemHere =>
      'İstasyonları takip ederek burada görün';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Veri tasarrufu için yalnızca ses akışını zorla';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Alan açar ve bir sonraki yüklemede verileri yenilemeye zorlar';

  @override
  String get fromYourFavorites => 'Favorilerinden';

  @override
  String get goBack => 'Geri Dön';

  @override
  String inspiredByName(Object name) {
    return '$name sanatçısından ilham alındı';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Kuyruk bittiğinde benzer parçaları çalmaya devam et';

  @override
  String get library => 'Kitaplık';

  @override
  String get likeAlbumsToSeeThemHere => 'Albümleri beğenerek burada görün';

  @override
  String get likedSongs => 'Beğenilen Şarkılar';

  @override
  String get lowDataMode => 'Düşük Veri Modu';

  @override
  String get madeForYou => 'Senin İçin Hazırlandı';

  @override
  String moreLikeName(Object name) {
    return '$name benzerleri';
  }

  @override
  String get moreOptions => 'Daha fazla seçenek';

  @override
  String get nameYourMasterpiece => 'Şaheserine bir isim ver...';

  @override
  String get newPlaylist => 'Yeni Çalma Listesi';

  @override
  String get newReleases => 'Yeni Çıkanlar';

  @override
  String get next => 'Sonraki';

  @override
  String get noAlbumsFound => 'Albüm bulunamadı';

  @override
  String get noArtistsFollowed => 'Takip edilen sanatçı yok';

  @override
  String get noArtistsFound => 'Sanatçı bulunamadı';

  @override
  String get noLikedAlbums => 'Beğenilen albüm yok';

  @override
  String get noPlaylistsFound => 'Çalma listesi bulunamadı';

  @override
  String get noPlaylistsYet => 'Henüz çalma listesi yok';

  @override
  String get noResultsFound => 'Sonuç bulunamadı';

  @override
  String get noStationsFollowed => 'Takip edilen istasyon yok';

  @override
  String get noTrackPlaying => 'Çalan parça yok';

  @override
  String get noTracksFound => 'Parça bulunamadı';

  @override
  String get playlists => 'ÇALMA LİSTELERİ';

  @override
  String get popular => 'POPÜLER';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Dinleme geçmişini kalıcı olarak kaldır';

  @override
  String get pictureinpicturePip => 'Resim İçinde Resim (PiP)';

  @override
  String get popularAlbums => 'Popüler Albümler';

  @override
  String get popularArtists => 'Popüler Sanatçılar';

  @override
  String get popularGenres => 'Popüler Türler';

  @override
  String get popularSongs => 'Popüler Şarkılar';

  @override
  String get popularTracks => 'Popüler Parçalar';

  @override
  String get popularHitsRightNow => 'Şu Anki Popüler Hit\'ler';

  @override
  String get previous => 'Önceki';

  @override
  String get queue => 'KUYRUK';

  @override
  String get recentSearches => 'Son aramalar';

  @override
  String get recommendedForYou => 'Senin İçin Önerilenler';

  @override
  String get scraping => 'Veri kazınıyor';

  @override
  String get search => 'Ara';

  @override
  String get searchInAlbum => 'Albümde ara...';

  @override
  String get searchInLibrary => 'Kitaplıkta ara...';

  @override
  String get searchInPlaylist => 'Çalma listesinde ara...';

  @override
  String get searchLikedSongs => 'Beğenilen şarkılarda ara...';

  @override
  String get searchPopularSongs => 'Popüler şarkılarda ara...';

  @override
  String get selectMarket => 'Pazar Seç';

  @override
  String get settings => 'Ayarlar';

  @override
  String get showVideoPlayer => 'Video Oynatıcıyı Göster';

  @override
  String get shuffle => 'Karışık Çal';

  @override
  String get spotifyCredentials => 'Spotify Kimlik Bilgileri';

  @override
  String get suggestedStations => 'Önerilen İstasyonlar';

  @override
  String get tracks => 'PARÇALAR';

  @override
  String get trending => 'Trend Olanlar';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get tryADifferentSearchTerm => 'Farklı bir arama terimi deneyin';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Mümkün olduğunda YouTube oynatıcısını kullan';

  @override
  String get video => 'VİDEO';

  @override
  String get whatDoYouWantToListenTo => 'Ne dinlemek istersin?';

  @override
  String get youtubeCredentials => 'YouTube Kimlik Bilgileri';

  @override
  String get yourLibrary => 'Kitaplığın';

  @override
  String get playerscreenviewswitch => 'oynatıcı_ekranı_görünüm_değiştiricisi';

  @override
  String get addToPlaylist => 'Çalma Listesine Ekle';

  @override
  String get addToQueue => 'Kuyruğa Ekle';

  @override
  String get copyId => 'ID\'yi Kopyala';

  @override
  String get copyLink => 'Bağlantıyı Kopyala';

  @override
  String get discover => 'Keşfet';

  @override
  String get enterYourName => 'İsmini gir';

  @override
  String get favorites => 'Favoriler';

  @override
  String get goToAlbum => 'Albüme Git';

  @override
  String get goToArtist => 'Sanatçıya Git';

  @override
  String get goToArtistRadio => 'Sanatçı Radyosuna Git';

  @override
  String get goToPlaylist => 'Çalma Listesine Git';

  @override
  String get goToSongRadio => 'Şarkı Radyosuna Git';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get myAwesomePlaylist => 'Harika Çalma Listem';

  @override
  String get myPlaylist => 'Çalma Listem';

  @override
  String get newPlaylist1 => 'Yeni Çalma Listesi';

  @override
  String get play => 'Çal';

  @override
  String get playStation => 'İstasyonu Çal';

  @override
  String get playNext => 'Sonrakini Çal';

  @override
  String get playlist => 'Çalma Listesi';

  @override
  String get playlistName => 'Çalma Listesi Adı';

  @override
  String get playlists1 => 'Çalma Listeleri';

  @override
  String get queue1 => 'Kuyruk';

  @override
  String get recentlyPlayed => 'Son Çalınanlar';

  @override
  String get removeFromQueue => 'Kuyruktan Kaldır';

  @override
  String get retry => 'Yeniden Dene';

  @override
  String get searchMusicArtistsAlbums => 'Müzik, sanatçı, albüm ara...';

  @override
  String get share => 'Paylaş';

  @override
  String featuringArtist(String artistName) {
    return 'EŞLİK EDEN: $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Mevcut: $country';
  }

  @override
  String get queueTooltip => 'Kuyruk';

  @override
  String get searchHint => 'Müzik, sanatçı, albüm ara...';

  @override
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

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

  @override
  String get aboutDescription => 'A free, open-source music player.';

  @override
  String versionInfo(Object version, Object build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get createdBy => 'Created by Lucas Coelho';

  @override
  String get website => 'Website';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get support => 'Support';

  @override
  String get license => 'License';

  @override
  String get acknowledgments => 'Acknowledgments';

  @override
  String get close => 'Close';

  @override
  String copyright(Object year) {
    return '© $year PPPlayer contributors';
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
  String get filterAll => 'All';

  @override
  String get filterPlaylists => 'Playlists';

  @override
  String get filterArtists => 'Artists';

  @override
  String get filterAlbums => 'Albums';

  @override
  String get filterStations => 'Stations';

  @override
  String get localMusicCard => 'Local Music';

  @override
  String get createPlaylistButton => 'Create Playlist';

  @override
  String get radioStations => 'Radio Stations';

  @override
  String get discoverMusic => 'Discover Music';

  @override
  String get importLocalMusic => 'Import Local Music';

  @override
  String get importAudioFiles => 'Import Audio Files';

  @override
  String get importFolder => 'Import Folder';

  @override
  String get importFolderSubtitle =>
      'Note: Audio files are hidden in the folder picker. This is normal.';
}
