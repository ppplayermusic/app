// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'ALBUM';

  @override
  String get api => 'API';

  @override
  String get artists => 'ARTIS';

  @override
  String get artwork => 'SAMPUL';

  @override
  String get appVersion => 'Versi aplikasi';

  @override
  String get artist => 'Artis';

  @override
  String get artistsYouFollow => 'Artis yang Anda ikuti';

  @override
  String get autoplay => 'Putar Otomatis';

  @override
  String get becauseYouListenedTo => 'Karena Anda mendengarkan';

  @override
  String get browseAll => 'Jelajahi semua';

  @override
  String get cancel => 'Batal';

  @override
  String get clearAppCache => 'Hapus Cache Aplikasi?';

  @override
  String get clearCache => 'Hapus Cache';

  @override
  String get clearHistory => 'Hapus Riwayat?';

  @override
  String get clearRecentlyPlayed => 'Hapus yang Baru Diputar';

  @override
  String get contentMarket => 'Pasar Konten';

  @override
  String get continueListening => 'Lanjutkan Mendengarkan';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Lanjutkan pemutaran video di jendela kecil';

  @override
  String get create => 'Buat';

  @override
  String get createAPlaylistToGetStarted => 'Buat playlist untuk memulai';

  @override
  String currentSelectedcountry(Object country) {
    return 'Saat ini: $country';
  }

  @override
  String get deletePlaylist => 'Hapus Playlist';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Kesalahan memuat pasar: $err';
  }

  @override
  String error(Object error) {
    return 'Kesalahan: $error';
  }

  @override
  String explore(Object genre) {
    return 'Jelajahi $genre';
  }

  @override
  String get fansAlsoLike => 'PENGGEMAR JUGA MENYUKAI';

  @override
  String featuringTouppercase(Object artist) {
    return 'MENAMPILKAN $artist';
  }

  @override
  String get featuredPlaylists => 'Playlist Unggulan';

  @override
  String get followArtistsToSeeThemHere =>
      'Ikuti artis untuk melihat mereka di sini';

  @override
  String get followStationsToSeeThemHere =>
      'Ikuti stasiun untuk melihat mereka di sini';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Paksa streaming audio saja untuk menghemat data';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Membebaskan ruang dan memaksa pemuatan data baru';

  @override
  String get fromYourFavorites => 'Dari favorit Anda';

  @override
  String get goBack => 'Kembali';

  @override
  String inspiredByName(Object name) {
    return 'Terinspirasi oleh $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Terus putar lagu serupa saat antrean berakhir';

  @override
  String get library => 'Koleksi';

  @override
  String get likeAlbumsToSeeThemHere => 'Sukai album untuk melihatnya di sini';

  @override
  String get likedSongs => 'Lagu yang Disukai';

  @override
  String get lowDataMode => 'Mode Hemat Data';

  @override
  String get madeForYou => 'Dibuat Untuk Anda';

  @override
  String moreLikeName(Object name) {
    return 'Lebih mirip $name';
  }

  @override
  String get moreOptions => 'Opsi lainnya';

  @override
  String get nameYourMasterpiece => 'Beri nama mahakarya Anda...';

  @override
  String get newPlaylist => 'Playlist Baru';

  @override
  String get newReleases => 'Rilisan Baru';

  @override
  String get next => 'Berikutnya';

  @override
  String get noAlbumsFound => 'Album tidak ditemukan';

  @override
  String get noArtistsFollowed => 'Tidak ada artis yang diikuti';

  @override
  String get noArtistsFound => 'Artis tidak ditemukan';

  @override
  String get noLikedAlbums => 'Tidak ada album yang disukai';

  @override
  String get noPlaylistsFound => 'Playlist tidak ditemukan';

  @override
  String get noPlaylistsYet => 'Belum ada playlist';

  @override
  String get noResultsFound => 'Hasil tidak ditemukan';

  @override
  String get noStationsFollowed => 'Tidak ada stasiun yang diikuti';

  @override
  String get noTrackPlaying => 'Tidak ada lagu yang diputar';

  @override
  String get noTracksFound => 'Lagu tidak ditemukan';

  @override
  String get playlists => 'PLAYLIST';

  @override
  String get popular => 'POPULER';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Hapus riwayat mendengarkan secara permanen';

  @override
  String get pictureinpicturePip => 'Gambar-dalam-Gambar (PiP)';

  @override
  String get popularAlbums => 'Album Populer';

  @override
  String get popularArtists => 'Artis Populer';

  @override
  String get popularGenres => 'Genre Populer';

  @override
  String get popularSongs => 'Lagu Populer';

  @override
  String get popularTracks => 'Lagu Populer';

  @override
  String get popularHitsRightNow => 'Lagu hit populer saat ini';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get queue => 'ANTREAN';

  @override
  String get recentSearches => 'Pencarian terbaru';

  @override
  String get recommendedForYou => 'Direkomendasikan untuk Anda';

  @override
  String get scraping => 'Scraping';

  @override
  String get search => 'Cari';

  @override
  String get searchInAlbum => 'Cari dalam album...';

  @override
  String get searchInLibrary => 'Cari dalam koleksi...';

  @override
  String get searchInPlaylist => 'Cari dalam playlist';

  @override
  String get searchLikedSongs => 'Cari lagu yang disukai...';

  @override
  String get searchPopularSongs => 'Cari lagu populer...';

  @override
  String get selectMarket => 'Pilih Pasar';

  @override
  String get settings => 'Pengaturan';

  @override
  String get showVideoPlayer => 'Tampilkan Pemutar Video';

  @override
  String get shuffle => 'Acak';

  @override
  String get spotifyCredentials => 'Kredensial Spotify';

  @override
  String get suggestedStations => 'Stasiun yang Disarankan';

  @override
  String get tracks => 'LAGU';

  @override
  String get trending => 'Sedang Tren';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get tryADifferentSearchTerm => 'Coba istilah pencarian yang berbeda';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Gunakan pemutar YouTube jika tersedia';

  @override
  String get video => 'VIDEO';

  @override
  String get whatDoYouWantToListenTo => 'Apa yang ingin Anda dengarkan?';

  @override
  String get youtubeCredentials => 'Kredensial YouTube';

  @override
  String get yourLibrary => 'Koleksi Anda';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Tambahkan ke playlist';

  @override
  String get addToQueue => 'Tambahkan ke antrean';

  @override
  String get copyId => 'Salin ID';

  @override
  String get copyLink => 'Salin tautan';

  @override
  String get discover => 'Temukan';

  @override
  String get enterYourName => 'Masukkan nama Anda';

  @override
  String get favorites => 'Favorit';

  @override
  String get goToAlbum => 'Buka album';

  @override
  String get goToArtist => 'Buka artis';

  @override
  String get goToArtistRadio => 'Buka radio artis';

  @override
  String get goToPlaylist => 'Buka playlist';

  @override
  String get goToSongRadio => 'Buka radio lagu';

  @override
  String get home => 'Beranda';

  @override
  String get myAwesomePlaylist => 'Playlist Luar Biasa Saya';

  @override
  String get myPlaylist => 'Playlist Saya';

  @override
  String get newPlaylist1 => 'Playlist baru';

  @override
  String get play => 'Putar';

  @override
  String get playStation => 'Putar Stasiun';

  @override
  String get playNext => 'Putar selanjutnya';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistName => 'Nama Playlist';

  @override
  String get playlists1 => 'Playlist';

  @override
  String get queue1 => 'Antrean';

  @override
  String get recentlyPlayed => 'Baru Diputar';

  @override
  String get removeFromQueue => 'Hapus dari antrean';

  @override
  String get retry => 'Coba lagi';

  @override
  String get searchMusicArtistsAlbums => 'Cari musik, artis, album...';

  @override
  String get share => 'Bagikan';

  @override
  String featuringArtist(String artistName) {
    return 'MENAMPILKAN $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Saat ini: $country';
  }

  @override
  String get queueTooltip => 'Antrean';

  @override
  String get searchHint => 'Cari musik, artis, album...';

  @override
  String get language => 'Bahasa';

  @override
  String get systemDefault => 'Default Sistem';

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
