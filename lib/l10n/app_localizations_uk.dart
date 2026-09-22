// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'АЛЬБОМИ';

  @override
  String get api => 'API';

  @override
  String get artists => 'ВИКОНАВЦІ';

  @override
  String get artwork => 'ОБКЛАДИНКА';

  @override
  String get appVersion => 'Версія програми';

  @override
  String get artist => 'Виконавець';

  @override
  String get artistsYouFollow => 'Виконавці, за якими ви стежите';

  @override
  String get autoplay => 'Автозапуск';

  @override
  String get becauseYouListenedTo => 'Оскільки ви слухали';

  @override
  String get browseAll => 'Переглянути все';

  @override
  String get cancel => 'Скасувати';

  @override
  String get clearAppCache => 'Очистити кеш програми?';

  @override
  String get clearCache => 'Очистити кеш';

  @override
  String get clearHistory => 'Очистити історію?';

  @override
  String get clearRecentlyPlayed => 'Очистити нещодавно відтворене';

  @override
  String get contentMarket => 'Ринок контенту';

  @override
  String get continueListening => 'Продовжити слухати';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Продовжити відтворення відео в маленькому вікні';

  @override
  String get create => 'Створити';

  @override
  String get createAPlaylistToGetStarted =>
      'Створіть список відтворення, щоб почати';

  @override
  String currentSelectedcountry(Object country) {
    return 'Поточна: $country';
  }

  @override
  String get deletePlaylist => 'Видалити список відтворення';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Помилка завантаження ринків: $err';
  }

  @override
  String error(Object error) {
    return 'Помилка: $error';
  }

  @override
  String explore(Object genre) {
    return 'Огляд: $genre';
  }

  @override
  String get fansAlsoLike => 'ШАНУВАЛЬНИКАМ ТАКОЖ ПОДОБАЄТЬСЯ';

  @override
  String featuringTouppercase(Object artist) {
    return 'ЗА УЧАСТЮ $artist';
  }

  @override
  String get featuredPlaylists => 'Рекомендовані списки відтворення';

  @override
  String get followArtistsToSeeThemHere =>
      'Стежте за виконавцями, щоб бачити їх тут';

  @override
  String get followStationsToSeeThemHere =>
      'Стежте за станціями, щоб бачити їх тут';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Примусово використовувати аудіопотоки для економії даних';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Звільняє місце та примусово завантажує нові дані наступного разу';

  @override
  String get fromYourFavorites => 'З ваших улюблених';

  @override
  String get goBack => 'Назад';

  @override
  String inspiredByName(Object name) {
    return 'Натхненно $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Продовжувати відтворення схожих треків, коли черга закінчується';

  @override
  String get library => 'Медіатека';

  @override
  String get likeAlbumsToSeeThemHere => 'Вподобайте альбоми, щоб бачити їх тут';

  @override
  String get likedSongs => 'Улюблені пісні';

  @override
  String get lowDataMode => 'Режим економії даних';

  @override
  String get madeForYou => 'Створено для вас';

  @override
  String moreLikeName(Object name) {
    return 'Більше схожого на $name';
  }

  @override
  String get moreOptions => 'Більше опцій';

  @override
  String get nameYourMasterpiece => 'Назвіть свій шедевр...';

  @override
  String get newPlaylist => 'Новий список відтворення';

  @override
  String get newReleases => 'Нові випуски';

  @override
  String get next => 'Далі';

  @override
  String get noAlbumsFound => 'Альбомів не знайдено';

  @override
  String get noArtistsFollowed => 'Немає виконавців, за якими ви стежите';

  @override
  String get noArtistsFound => 'Виконавців не знайдено';

  @override
  String get noLikedAlbums => 'Немає улюблених альбомів';

  @override
  String get noPlaylistsFound => 'Списків відтворення не знайдено';

  @override
  String get noPlaylistsYet => 'Поки немає списків відтворення';

  @override
  String get noResultsFound => 'Результатів не знайдено';

  @override
  String get noStationsFollowed => 'Немає станцій, за якими ви стежите';

  @override
  String get noTrackPlaying => 'Трек не відтворюється';

  @override
  String get noTracksFound => 'Треків не знайдено';

  @override
  String get playlists => 'СПИСКИ ВІДТВОРЕННЯ';

  @override
  String get popular => 'ПОПУЛЯРНЕ';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Назавжди видалити історію прослуховування';

  @override
  String get pictureinpicturePip => 'Картинка в картинці (PiP)';

  @override
  String get popularAlbums => 'Популярні альбоми';

  @override
  String get popularArtists => 'Популярні виконавці';

  @override
  String get popularGenres => 'Популярні жанри';

  @override
  String get popularSongs => 'Популярні пісні';

  @override
  String get popularTracks => 'Популярні треки';

  @override
  String get popularHitsRightNow => 'Популярні хіти зараз';

  @override
  String get previous => 'Попередній';

  @override
  String get queue => 'ЧЕРГА';

  @override
  String get recentSearches => 'Останні пошуки';

  @override
  String get recommendedForYou => 'Рекомендовано для вас';

  @override
  String get scraping => 'Збір даних';

  @override
  String get search => 'Пошук';

  @override
  String get searchInAlbum => 'Шукати в альбомі...';

  @override
  String get searchInLibrary => 'Шукати в медіатеці...';

  @override
  String get searchInPlaylist => 'Шукати в списку відтворення';

  @override
  String get searchLikedSongs => 'Шукати в улюблених піснях...';

  @override
  String get searchPopularSongs => 'Шукати популярні пісні...';

  @override
  String get selectMarket => 'Вибрати ринок';

  @override
  String get settings => 'Налаштування';

  @override
  String get showVideoPlayer => 'Показати відеоплеєр';

  @override
  String get shuffle => 'У випадковому порядку';

  @override
  String get spotifyCredentials => 'Облікові дані Spotify';

  @override
  String get suggestedStations => 'Пропоновані станції';

  @override
  String get tracks => 'ТРЕКИ';

  @override
  String get trending => 'У тренді';

  @override
  String get tryAgain => 'Спробувати ще раз';

  @override
  String get tryADifferentSearchTerm => 'Спробуйте інший пошуковий запит';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Використовувати плеєр YouTube, якщо доступно';

  @override
  String get video => 'ВІДЕО';

  @override
  String get whatDoYouWantToListenTo => 'Що ви хочете послухати?';

  @override
  String get youtubeCredentials => 'Облікові дані YouTube';

  @override
  String get yourLibrary => 'Ваша медіатека';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Додати до списку відтворення';

  @override
  String get addToQueue => 'Додати до черги';

  @override
  String get copyId => 'Копіювати ID';

  @override
  String get copyLink => 'Копіювати посилання';

  @override
  String get discover => 'Огляд';

  @override
  String get enterYourName => 'Введіть своє ім\'я';

  @override
  String get favorites => 'Улюблене';

  @override
  String get goToAlbum => 'Перейти до альбому';

  @override
  String get goToArtist => 'Перейти до виконавця';

  @override
  String get goToArtistRadio => 'Перейти до радіо виконавця';

  @override
  String get goToPlaylist => 'Перейти до списку відтворення';

  @override
  String get goToSongRadio => 'Перейти до радіо пісні';

  @override
  String get home => 'Головна';

  @override
  String get myAwesomePlaylist => 'Мій чудовий список відтворення';

  @override
  String get myPlaylist => 'Мій список відтворення';

  @override
  String get newPlaylist1 => 'Новий список відтворення';

  @override
  String get play => 'Відтворити';

  @override
  String get playStation => 'Увімкнути станцію';

  @override
  String get playNext => 'Відтворити далі';

  @override
  String get playlist => 'Список відтворення';

  @override
  String get playlistName => 'Назва списку відтворення';

  @override
  String get playlists1 => 'Списки відтворення';

  @override
  String get queue1 => 'Черга';

  @override
  String get recentlyPlayed => 'Нещодавно відтворене';

  @override
  String get removeFromQueue => 'Видалити з черги';

  @override
  String get retry => 'Спробувати ще раз';

  @override
  String get searchMusicArtistsAlbums =>
      'Пошук музики, виконавців, альбомів...';

  @override
  String get share => 'Поділитися';

  @override
  String featuringArtist(String artistName) {
    return 'ЗА УЧАСТЮ $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Поточна: $country';
  }

  @override
  String get queueTooltip => 'Черга';

  @override
  String get searchHint => 'Пошук музики, виконавців, альбомів...';

  @override
  String get language => 'Мова';

  @override
  String get systemDefault => 'Системна за замовчуванням';

  @override
  String get songsTab => 'Пісні';

  @override
  String get foldersTab => 'Папки';

  @override
  String get artistsTab => 'Виконавці';

  @override
  String get albumsTab => 'Альбоми';

  @override
  String get genresTab => 'Жанри';

  @override
  String get noLocalGenres => 'Жанрів не знайдено';

  @override
  String get playbackSpeed => 'Швидкість відтворення';

  @override
  String get addMusic => 'Додати музику';

  @override
  String get addFiles => 'Додати файли';

  @override
  String get addFolder => 'Додати папку';

  @override
  String get rescanLibrary => 'Повторно сканувати медіатеку';

  @override
  String get sortTitle => 'За назвою';

  @override
  String get sortArtist => 'За виконавцем';

  @override
  String get sortAlbum => 'За альбомом';

  @override
  String get sortDuration => 'За тривалістю';

  @override
  String get sortDateAdded => 'За датою додавання';

  @override
  String get sortBy => 'Сортувати за';

  @override
  String get trackInformation => 'Інформація про трек';

  @override
  String get removeFromLibrary => 'Видалити з медіатеки';

  @override
  String get showInFolder => 'Показати в папці';

  @override
  String get unknownArtist => 'Невідомий виконавець';

  @override
  String get unknownAlbum => 'Невідомий альбом';

  @override
  String get importedFiles => 'Імпортовані файли';

  @override
  String get playFolder => 'Відтворити папку';

  @override
  String get shuffleFolder => 'Відтворити папку випадково';

  @override
  String get playAll => 'Відтворити все';

  @override
  String get includeSubfolders => 'Включити вкладені папки';

  @override
  String trackCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      two: '2 треки',
      one: '1 трек',
      zero: '0 треків',
    );
    return '$_temp0';
  }

  @override
  String get noLocalSongs => 'Немає імпортованих локальних пісень';

  @override
  String get searchLocalMusic => 'Пошук локальної музики';

  @override
  String get viewAsList => 'Перегляд списком';

  @override
  String get viewAsGrid => 'Перегляд сіткою';

  @override
  String get trackInfoPath => 'Шлях';

  @override
  String get trackInfoFormat => 'Формат';

  @override
  String get trackInfoDuration => 'Тривалість';

  @override
  String get aboutDescription =>
      'Безкоштовний медіаплеєр з відкритим вихідним кодом.';

  @override
  String get aboutApp => 'Про PPPlayer';

  @override
  String get appTagline => 'Ваша музика. Ваш вибір.';

  @override
  String get exploreApp => 'Огляд PPPlayer';

  @override
  String get viewSource => 'Переглянути вихідний код';

  @override
  String get seeWhatsNew => 'Що нового';

  @override
  String get getHelp => 'Отримати допомогу';

  @override
  String versionInfo(Object version, Object build) {
    return 'Версія $version (Збірка $build)';
  }

  @override
  String get createdBy => 'Створено Lucas Coelho';

  @override
  String get website => 'Вебсайт';

  @override
  String get github => 'GitHub';

  @override
  String get releaseNotes => 'Примітки до випуску';

  @override
  String get support => 'Підтримка';

  @override
  String get license => 'Ліцензія';

  @override
  String get acknowledgments => 'Подяки';

  @override
  String get close => 'Закрити';

  @override
  String copyright(Object year) {
    return '© $year Учасники PPPlayer';
  }

  @override
  String get goodMorning => 'Доброго ранку';

  @override
  String get goodAfternoon => 'Доброго дня';

  @override
  String get goodEvening => 'Доброго вечора';

  @override
  String greetingWithName(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String get yourMusicIsWaiting => 'Ваша музика чекає.';

  @override
  String dailyMix(Object number) {
    return 'Щоденний мікс $number';
  }

  @override
  String get yourFavoritesAndNewDiscoveries =>
      'Ваше улюблене\nта нові відкриття';

  @override
  String get discoverWeekly => 'Відкриття тижня';

  @override
  String get releaseRadar => 'Радар новинок';

  @override
  String get newMusicJustForYou => 'Нова музика\nспеціально для вас';

  @override
  String get chillMix => 'Чіл мікс';

  @override
  String get relaxAndUnwind => 'Розслабтеся і відпочиньте';

  @override
  String get focusMix => 'Мікс для фокусування';

  @override
  String get deepFocusAndProductivity => 'Глибокий фокус\nта продуктивність';

  @override
  String artistRadio(Object artist) {
    return 'Радіо: $artist';
  }

  @override
  String genreRadio(Object genre) {
    return 'Радіо: $genre';
  }

  @override
  String get filterAll => 'Усі';

  @override
  String get filterPlaylists => 'Списки відтворення';

  @override
  String get filterArtists => 'Виконавці';

  @override
  String get filterAlbums => 'Альбоми';

  @override
  String get filterStations => 'Станції';

  @override
  String get filterStreams => 'Потоки';

  @override
  String get localMusicCard => 'Локальна музика';

  @override
  String get createPlaylistButton => 'Створити список відтворення';

  @override
  String get radioStations => 'Радіостанції';

  @override
  String get discoverMusic => 'Знайти музику';

  @override
  String get importLocalMusic => 'Імпортувати локальну музику';

  @override
  String get importAudioFiles => 'Імпортувати аудіофайли';

  @override
  String get importFolder => 'Імпортувати папку';

  @override
  String get importFolderSubtitle =>
      'Примітка: Аудіофайли приховані в засобі вибору папок. Це нормально.';

  @override
  String get importPlaylist => 'Імпортувати список відтворення';

  @override
  String get importPlaylistSubtitle => 'Імпортувати файли .m3u або .m3u8';

  @override
  String get exportPlaylist => 'Експортувати список відтворення';

  @override
  String get playbackErrorUnsupportedFormat =>
      'Непідтримуваний формат або пошкоджений файл';

  @override
  String get playbackErrorFileInaccessible =>
      'Файл недоступний або не знайдений';

  @override
  String get localVideosCard => 'Локальні відео';

  @override
  String get noLocalVideos => 'Відео не знайдено';

  @override
  String get searchLocalVideos => 'Шукати локальні відео';

  @override
  String get addVideos => 'Додати відео';

  @override
  String get subtitles => 'Субтитри';

  @override
  String get audioTracks => 'Аудіодоріжки';

  @override
  String get loadSubtitleFile => 'Завантажити файл субтитрів...';

  @override
  String errorLoadingSubtitle(String error) {
    return 'Помилка завантаження субтитрів: $error';
  }

  @override
  String get off => 'Вимкнено';
}
