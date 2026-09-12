// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'PPPlayer';

  @override
  String titleSubtitle(Object title, Object subtitle) {
    return '$title, $subtitle';
  }

  @override
  String get albums => 'АЛЬБОМЫ';

  @override
  String get api => 'API';

  @override
  String get artists => 'ИСПОЛНИТЕЛИ';

  @override
  String get artwork => 'ОБЛОЖКА';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get artist => 'Исполнитель';

  @override
  String get artistsYouFollow => 'Исполнители, на которых вы подписаны';

  @override
  String get autoplay => 'Автовоспроизведение';

  @override
  String get becauseYouListenedTo => 'Потому что вы слушали';

  @override
  String get browseAll => 'Смотреть все';

  @override
  String get cancel => 'Отмена';

  @override
  String get clearAppCache => 'Очистить кэш приложения?';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get clearHistory => 'Очистить историю?';

  @override
  String get clearRecentlyPlayed => 'Очистить недавно прослушанное';

  @override
  String get contentMarket => 'Рынок контента';

  @override
  String get continueListening => 'Продолжить прослушивание';

  @override
  String get continueVideoPlaybackInASmallWindow =>
      'Продолжить воспроизведение видео в маленьком окне';

  @override
  String get create => 'Создать';

  @override
  String get createAPlaylistToGetStarted => 'Создайте плейлист, чтобы начать';

  @override
  String currentSelectedcountry(Object country) {
    return 'Текущий: $country';
  }

  @override
  String get deletePlaylist => 'Удалить плейлист';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String errorLoadingMarkets(Object err) {
    return 'Ошибка загрузки рынков: $err';
  }

  @override
  String error(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String explore(Object genre) {
    return 'Обзор $genre';
  }

  @override
  String get fansAlsoLike => 'ПОКЛОННИКАМ ТАКЖЕ НРАВИТСЯ';

  @override
  String featuringTouppercase(Object artist) {
    return 'ПРИ УЧАСТИИ $artist';
  }

  @override
  String get featuredPlaylists => 'Рекомендуемые плейлисты';

  @override
  String get followArtistsToSeeThemHere =>
      'Подпишитесь на исполнителей, чтобы видеть их здесь';

  @override
  String get followStationsToSeeThemHere =>
      'Подпишитесь на станции, чтобы видеть их здесь';

  @override
  String get forceAudioonlyStreamsToSaveData =>
      'Принудительно только аудио для экономии данных';

  @override
  String get freesUpSpaceAndForcesFreshDataOnNextLoad =>
      'Освобождает место и загружает новые данные при следующем запуске';

  @override
  String get fromYourFavorites => 'Из ваших избранных';

  @override
  String get goBack => 'Назад';

  @override
  String inspiredByName(Object name) {
    return 'Вдохновлено $name';
  }

  @override
  String get keepPlayingSimilarTracksWhenQueueEnds =>
      'Продолжать воспроизведение похожих треков, когда очередь заканчивается';

  @override
  String get library => 'Медиатека';

  @override
  String get likeAlbumsToSeeThemHere =>
      'Ставьте лайки альбомам, чтобы видеть их здесь';

  @override
  String get likedSongs => 'Любимые треки';

  @override
  String get lowDataMode => 'Экономия трафика';

  @override
  String get madeForYou => 'Специально для вас';

  @override
  String moreLikeName(Object name) {
    return 'Больше похожего на $name';
  }

  @override
  String get moreOptions => 'Больше параметров';

  @override
  String get nameYourMasterpiece => 'Назовите свой шедевр...';

  @override
  String get newPlaylist => 'Новый плейлист';

  @override
  String get newReleases => 'Новые релизы';

  @override
  String get next => 'Вперед';

  @override
  String get noAlbumsFound => 'Альбомы не найдены';

  @override
  String get noArtistsFollowed => 'Нет подписок на исполнителей';

  @override
  String get noArtistsFound => 'Исполнители не найдены';

  @override
  String get noLikedAlbums => 'Нет любимых альбомов';

  @override
  String get noPlaylistsFound => 'Плейлисты не найдены';

  @override
  String get noPlaylistsYet => 'Пока нет плейлистов';

  @override
  String get noResultsFound => 'Ничего не найдено';

  @override
  String get noStationsFollowed => 'Нет подписок на станции';

  @override
  String get noTrackPlaying => 'Ничего не воспроизводится';

  @override
  String get noTracksFound => 'Треки не найдены';

  @override
  String get playlists => 'ПЛЕЙЛИСТЫ';

  @override
  String get popular => 'ПОПУЛЯРНОЕ';

  @override
  String get permanentlyRemoveListeningHistory =>
      'Навсегда удалить историю прослушивания';

  @override
  String get pictureinpicturePip => 'Картинка в картинке (PiP)';

  @override
  String get popularAlbums => 'Популярные альбомы';

  @override
  String get popularArtists => 'Популярные исполнители';

  @override
  String get popularGenres => 'Популярные жанры';

  @override
  String get popularSongs => 'Популярные песни';

  @override
  String get popularTracks => 'Популярные треки';

  @override
  String get popularHitsRightNow => 'Популярные хиты прямо сейчас';

  @override
  String get previous => 'Назад';

  @override
  String get queue => 'ОЧЕРЕДЬ';

  @override
  String get recentSearches => 'Недавние поиски';

  @override
  String get recommendedForYou => 'Рекомендуется для вас';

  @override
  String get scraping => 'Сбор данных';

  @override
  String get search => 'Поиск';

  @override
  String get searchInAlbum => 'Поиск в альбоме...';

  @override
  String get searchInLibrary => 'Поиск в медиатеке...';

  @override
  String get searchInPlaylist => 'Поиск в плейлисте';

  @override
  String get searchLikedSongs => 'Поиск в любимых треках...';

  @override
  String get searchPopularSongs => 'Поиск популярных песен...';

  @override
  String get selectMarket => 'Выбрать рынок';

  @override
  String get settings => 'Настройки';

  @override
  String get showVideoPlayer => 'Показать видеоплеер';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get spotifyCredentials => 'Учетные данные Spotify';

  @override
  String get suggestedStations => 'Предлагаемые станции';

  @override
  String get tracks => 'ТРЕКИ';

  @override
  String get trending => 'В тренде';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get tryADifferentSearchTerm => 'Попробуйте другой поисковый запрос';

  @override
  String get useYoutubePlayerWhenAvailable =>
      'Использовать плеер YouTube, если доступен';

  @override
  String get video => 'ВИДЕО';

  @override
  String get whatDoYouWantToListenTo => 'Что вы хотите послушать?';

  @override
  String get youtubeCredentials => 'Учетные данные YouTube';

  @override
  String get yourLibrary => 'Ваша медиатека';

  @override
  String get playerscreenviewswitch => 'player_screen_view_switch';

  @override
  String get addToPlaylist => 'Добавить в плейлист';

  @override
  String get addToQueue => 'Добавить в очередь';

  @override
  String get copyId => 'Копировать ID';

  @override
  String get copyLink => 'Копировать ссылку';

  @override
  String get discover => 'Обзор';

  @override
  String get enterYourName => 'Введите ваше имя';

  @override
  String get favorites => 'Избранное';

  @override
  String get goToAlbum => 'Перейти к альбому';

  @override
  String get goToArtist => 'Перейти к исполнителю';

  @override
  String get goToArtistRadio => 'Перейти к радио исполнителя';

  @override
  String get goToPlaylist => 'Перейти к плейлисту';

  @override
  String get goToSongRadio => 'Перейти к радио песни';

  @override
  String get home => 'Главная';

  @override
  String get myAwesomePlaylist => 'Мой потрясающий плейлист';

  @override
  String get myPlaylist => 'Мой плейлист';

  @override
  String get newPlaylist1 => 'Новый плейлист';

  @override
  String get play => 'Воспроизвести';

  @override
  String get playStation => 'Включить станцию';

  @override
  String get playNext => 'Воспроизвести следующим';

  @override
  String get playlist => 'Плейлист';

  @override
  String get playlistName => 'Название плейлистом';

  @override
  String get playlists1 => 'Плейлисты';

  @override
  String get queue1 => 'Очередь';

  @override
  String get recentlyPlayed => 'Недавно прослушано';

  @override
  String get removeFromQueue => 'Удалить из очереди';

  @override
  String get retry => 'Повторить';

  @override
  String get searchMusicArtistsAlbums =>
      'Поиск музыки, исполнителей, альбомов...';

  @override
  String get share => 'Поделиться';

  @override
  String featuringArtist(String artistName) {
    return 'ПРИ УЧАСТИИ $artistName';
  }

  @override
  String currentCountry(String country) {
    return 'Текущий: $country';
  }

  @override
  String get queueTooltip => 'Очередь';

  @override
  String get searchHint => 'Поиск музыки, артистов, альбомов...';

  @override
  String get language => 'Язык';

  @override
  String get systemDefault => 'Системный по умолчанию';
}
