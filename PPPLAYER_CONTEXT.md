# PPPLAYER_CONTEXT.md
## Architecture & Technical Discovery Document
**Generated:** 2026-09-04 | **Status:** Discovery Phase — No Code Modified

---

## 1. Product Overview

**PPPlayer** is a music streaming application described as *"Music player powered by Lucas Veneno."*

It is a **Flutter-based native application** (not a WebView app) that:

- Browses music metadata from the **Spotify API** (catalog, search, recommendations)
- Resolves and plays audio/video from **YouTube** (not Spotify audio streams — Spotify is used only for metadata and discovery)
- Displays a polished, animated music player UI with vinyl artwork, queue management, and video playback
- Caches play history, favorites, followed artists, liked albums, and playlists locally via a **SQLite (Drift)** database
- Runs system media notifications (lock screen / notification shade) via `audio_service`

### Primary User Flows

1. **Browse** — Home screen shows featured playlists, new releases, genres via Spotify API
2. **Search** — Full-text search across tracks, artists, albums via Spotify API
3. **Library** — Followed artists, liked albums, playlists (local + remote)
4. **Playback** — Select a track → resolve YouTube video ID → play via `youtube_player_iframe` embedded in the app → show in-app video or vinyl artwork view
5. **Queue & Radio** — Spotify-powered recommendations ("Radio") and manual queue management
6. **Settings** — Country/market selection, player view mode, performance mode, theme, video toggle

### What it plays/displays

- **Audio/Video content:** YouTube videos resolved from track metadata (artist + track name)
- **Artwork:** Album cover images from Spotify CDN
- **No DRM audio:** Does not use Spotify's audio streams; uses YouTube as the audio/video backend

### Application type

- **Native Flutter** with a **YouTube IFrame embedded widget** (`youtube_player_iframe`) for video playback
- Not a WebView app in the traditional sense — the YouTube IFrame is a platform-specific WebView spawned internally by the `youtube_player_iframe` package
- No custom WebView (`WebViewController`/`WebView`) is written directly in this codebase

---

## 2. Technology Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK ^3.7.0) |
| State management | Riverpod (`flutter_riverpod ^2.5.1`, `riverpod_annotation ^2.3.5`) |
| Navigation | `go_router ^13.2.5` |
| Video playback | `youtube_player_iframe ^5.2.2` (YouTube IFrame via WebView) |
| Native media | `media_kit ^1.2.6` + `media_kit_video ^2.0.1` (libmpv-based, not currently used for playback) |
| YouTube resolution | `youtube_explode_dart ^3.0.5` (declared, not confirmed used in runtime path), `youtube_explode_dart_plus ^1.0.3` |
| YouTube search | YouTube Data API v3 (via Dio) OR YouTube HTML scraping |
| Music metadata | Spotify Web API (Client Credentials, no user auth) |
| Background audio | `audio_service ^0.18.18` (system media controls, notification) |
| Audio session | `audio_session ^0.2.3` |
| Local database | Drift (`drift ^2.22.0`, `drift_flutter ^0.2.0`) → SQLite |
| Preferences | Hive CE (`hive_ce ^2.19.3`, `hive_ce_flutter ^2.3.4`) |
| Networking | Dio `^5.9.2` |
| Image caching | `cached_network_image ^3.4.1` |
| Ads | `google_mobile_ads ^7.0.0` |
| In-App Purchase | `in_app_purchase ^3.2.3` (declared, **not observed in any source code**) |
| Connectivity | `connectivity_plus ^7.0.0` |
| Code generation | `freezed`, `json_serializable`, `riverpod_generator`, `drift_dev`, `build_runner` |
| Android SDK | compileSdk/targetSdk from Flutter defaults (typically 34/35) |
| Min SDK | From Flutter defaults (declared `minSdk_android: 21` in launcher_icons config) |
| Kotlin | JVM target Java 17 |
| Permissions | `permission_handler ^11.3.1` |
| Environment | `flutter_dotenv ^6.0.0` (`.env` file) |

---

## 3. Project Structure

```
ppplayer/
├── .env                          # API keys: SPOTIFY_CLIENT_ID, YOUTUBE_API_KEY, YOUTUBE_SEARCH_METHOD
├── pubspec.yaml                  # App dependencies
├── android/
│   ├── app/
│   │   ├── build.gradle.kts      # Android build config (namespace: com.ppplayer.app)
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/com/ppplayer/app/
│   │           └── MainActivity.kt   # Extends AudioServiceActivity
├── ios/                          # Standard Flutter iOS project
├── macos/                        # macOS target (flutter run -d macos active)
├── lib/
│   ├── main.dart                 # App entry point
│   ├── main_test.dart            # Flutter Driver extension entry
│   ├── core/
│   │   ├── api/
│   │   │   ├── spotify_client.dart     # Spotify Web API client (Client Credentials)
│   │   │   ├── youtube_resolver.dart   # YouTube video ID resolver (API + scraping)
│   │   │   └── api_providers.dart      # Riverpod Dio provider
│   │   ├── db/
│   │   │   ├── app_database.dart       # Drift DB schema + queries (schema v6)
│   │   │   └── app_database.g.dart     # Generated Drift code
│   │   ├── models/
│   │   │   ├── track.dart              # Freezed Track model (Spotify metadata + youtubeVideoId)
│   │   │   ├── playback_queue.dart     # Pure queue logic (repeat, shuffle, prev/next)
│   │   │   ├── album.dart              # Freezed Album model
│   │   │   └── artist.dart             # Freezed Artist model
│   │   ├── playback/
│   │   │   ├── media_handler.dart      # AudioService bridge (PpPlayerAudioHandler)
│   │   │   ├── media_sync_service.dart # Syncs PlaybackStatus → system media controls
│   │   │   ├── playback_providers.dart # Riverpod: playbackControllerProvider, playbackStatusProvider
│   │   │   ├── playback_service.dart   # Domain service: resolve, cache, record, favorites
│   │   │   ├── resolver/               # EMPTY DIRECTORY
│   │   │   ├── engine/                 # EMPTY DIRECTORY
│   │   │   ├── models/                 # EMPTY DIRECTORY
│   │   │   └── packages/
│   │   │       └── pp_playback_engine/ # Local package (the actual playback engine)
│   │   │           ├── pubspec.yaml
│   │   │           └── lib/src/
│   │   │               ├── engine/
│   │   │               │   ├── playback_controller.dart        # Abstract interface
│   │   │               │   └── media_kit_playback_engine.dart  # Concrete implementation
│   │   │               ├── models/
│   │   │               │   ├── playback_status.dart
│   │   │               │   ├── playback_track.dart
│   │   │               │   └── playback_event.dart
│   │   │               └── ui/
│   │   │                   └── playback_view.dart              # PlaybackView widget
│   │   ├── player/
│   │   │   ├── player_provider.dart      # PlayerNotifier (Riverpod, main orchestrator)
│   │   │   └── video_layout_provider.dart# Layout tracking for floating video overlay
│   │   ├── providers/
│   │   │   └── genre_providers.dart      # FutureProviders for Spotify genre data
│   │   ├── router/
│   │   │   └── app_router.dart           # GoRouter configuration
│   │   ├── services/
│   │   │   ├── settings_provider.dart    # Hive-persisted settings (StateNotifier)
│   │   │   ├── favorites_provider.dart   # Favorites stream provider
│   │   │   └── ad_service.dart           # Google Mobile Ads service
│   │   └── theme/
│   │       └── app_theme.dart            # Material 3 dark theme
│   ├── features/
│   │   ├── home/
│   │   │   ├── home_screen.dart          # Featured playlists, new releases, genres
│   │   │   ├── recently_played_screen.dart
│   │   │   └── genre_details_screen.dart
│   │   ├── search/
│   │   │   └── search_screen.dart
│   │   ├── library/
│   │   │   ├── library_screen.dart       # Followed artists, liked albums, playlists
│   │   │   ├── liked_songs_screen.dart
│   │   │   ├── playlist_detail_screen.dart
│   │   │   └── remote_playlist_screen.dart
│   │   ├── player/
│   │   │   └── player_screen.dart        # Full-screen player (video/artwork/queue tabs)
│   │   ├── artist/
│   │   │   └── artist_screen.dart
│   │   ├── album/
│   │   │   └── album_screen.dart
│   │   ├── radio/
│   │   │   └── radio_details_screen.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   └── shared/widgets/
│       ├── scaffold_with_nav.dart    # Root shell: floating video overlay + mini-player + nav bar
│       ├── track_tile.dart
│       ├── tactile_buttons.dart
│       ├── adaptive_blur.dart
│       └── ...
├── assets/
│   └── logo.png
├── test/
│   └── playback_queue_test.dart    # 5 unit tests for PlaybackQueue logic
└── ppplayer-web/                   # Separate web project (not part of main app)
```

---

## 4. Architecture Map

```
PPPlayer App
 ├── UI Layer (Flutter Widgets)
 │    ├── HomeScreen, SearchScreen, LibraryScreen    (Spotify API data)
 │    ├── ArtistScreen, AlbumScreen, RadioScreen
 │    ├── PlayerScreen                               (3 tabs: Video / Artwork / Queue)
 │    ├── ScaffoldWithNav                            (mini-player bar + floating video overlay)
 │    └── ScaffoldWithNav > BottomNavBar             (Home / Search / Library)
 │
 ├── Navigation (go_router + ShellRoute)
 │    └── appRouterProvider → GoRouter (ShellRoute wraps all routes in ScaffoldWithNav)
 │
 ├── State Management (Riverpod)
 │    ├── playerProvider (PlayerNotifier) — queue, play/pause, skip, resolve
 │    ├── playbackStatusProvider (StreamProvider) — real-time engine status
 │    ├── playbackControllerProvider (Provider) — MediaKitPlaybackEngine singleton
 │    ├── settingsProvider (StateNotifier) — persisted to Hive
 │    ├── videoLayoutProvider (StateNotifier) — floating video layout tracking
 │    ├── appDatabaseProvider (Provider) — overridden in main() with AppDatabase instance
 │    └── audioHandlerProvider (Provider) — overridden in main() with PpPlayerAudioHandler
 │
 ├── Playback Engine (pp_playback_engine local package)
 │    ├── PlaybackController (abstract interface)
 │    ├── MediaKitPlaybackEngine (concrete implementation)
 │    │    ├── media_kit Player (initialized, streams wired, but NOT used for YouTube)
 │    │    └── YoutubePlayerController (youtube_player_iframe — primary YouTube path)
 │    └── PlaybackView (widget — renders YoutubePlayer OR media_kit Video)
 │
 ├── YouTube Resolution Pipeline
 │    ├── YoutubeResolver (YoutubeResolver.resolve())
 │    │    ├── Method A: YouTube Data API v3 (if YOUTUBE_SEARCH_METHOD=api)
 │    │    └── Method B: YouTube HTML scraping (if YOUTUBE_SEARCH_METHOD=scraping) ← ACTIVE
 │    └── AppDatabase.cacheYoutubeId() → stores resolved ID in SQLite
 │
 ├── Spotify API (SpotifyClient)
 │    └── Client Credentials OAuth (no user login)
 │
 ├── Persistence
 │    ├── Drift (SQLite) — tracks, artists, albums, playlists, radios, play history
 │    └── Hive CE — user settings (country, theme, playerView, performanceMode, etc.)
 │
 ├── Background Audio (audio_service + AudioSession)
 │    ├── PpPlayerAudioHandler — bridges player commands ↔ system
 │    └── MediaSyncService — syncs PlaybackStatus → PpPlayerAudioHandler
 │
 └── Android Platform
      ├── MainActivity (extends AudioServiceActivity)
      ├── AudioService (background foreground service, mediaPlayback type)
      └── MediaButtonReceiver
```

---

## 5. Application Entry Flow

**File:** [`lib/main.dart`](file:///Users/veneno/Projects/Apps/ppplayer/lib/main.dart)

```
main() [lib/main.dart]
  1. WidgetsFlutterBinding.ensureInitialized()
  2. MediaKit.ensureInitialized()          // media_kit native init
  3. dotenv.load('.env')                   // Load SPOTIFY_CLIENT_ID, YOUTUBE_API_KEY, etc.
  4. _requestNotificationPermission()      // Android 13+: POST_NOTIFICATIONS
  5. Hive.initFlutter()                    // Settings persistence
  6. MobileAds.instance.initialize()       // Delayed 10s on mobile
  7. AppDatabase()                         // Drift SQLite database
  8. ProviderContainer(overrides: [appDatabaseProvider]) // First container (for AudioService builder)
  9. AudioSession.configure(music())       // Audio focus configuration
  10. AudioService.init(                   // Start background audio service
        builder: () => PpPlayerAudioHandler(() => globalContainer)
      )
  11. globalContainer = ProviderContainer(  // Second container with all overrides
        overrides: [appDatabaseProvider, audioHandlerProvider]
      )
  12. runApp(UncontrolledProviderScope(container: globalContainer, child: PpPlayerApp()))
```

**Entry point class:** `PpPlayerApp` (ConsumerWidget, `lib/main.dart:97`)  
→ Builds `MaterialApp.router` with `appRouterProvider` (GoRouter, initial location `/home`)

> [!NOTE]
> `mediaSyncServiceProvider` is **declared** in `media_sync_service.dart` but is **never consumed** (`ref.watch`/`ref.read`) anywhere in the application. The `MediaSyncService` is **dead code** — the system media notification sync does not run.

---

## 6. WebView Architecture

PPPlayer does **not** contain a custom WebView implementation. Instead, it uses the `youtube_player_iframe` package which internally creates a platform WebView to host a YouTube IFrame.

### Creation

**File:** [`media_kit_playback_engine.dart:134`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart#L134-L141)

```dart
_youtubeController = yt.YoutubePlayerController.fromVideoId(
  videoId: videoId,
  params: const yt.YoutubePlayerParams(
    showControls: true,
    showFullscreenButton: true,
    mute: false,
  ),
);
```

The `YoutubePlayerController` is created **lazily** — on the first call to `play()`. It is **reused** for subsequent track plays (the controller is kept alive and `loadVideoById` is called on it).

### Configuration

All YouTube IFrame configuration is handled by `youtube_player_iframe`. The app configures:

| Setting | Value | Location |
|---|---|---|
| Controls | `showControls: true` | `media_kit_playback_engine.dart:137` |
| Fullscreen button | `showFullscreenButton: true` | `media_kit_playback_engine.dart:138` |
| Mute on start | `mute: false` | `media_kit_playback_engine.dart:139` |
| Autoplay | Not set at init; `playVideo()` called after load | `media_kit_playback_engine.dart:228` |

**JavaScript, DOM storage, cookies, user agent, cache, mixed content, debugging:** All controlled internally by `youtube_player_iframe` package — **not configurable at the app level in this codebase**.

### Navigation

There is no URL interception, domain allowlist, or custom navigation handler in the application code. All navigation within the YouTube IFrame is handled by the package.

### Errors

**Confirmed error handling:**
- `media_kit Player.stream.error` → emits `PlaybackState.error` + error string to `_statusController`
- `loadVideoById()` catch block → emits `PlaybackState.error`
- `PlayerState.loadError` drives a "Retry" button in `scaffold_with_nav.dart:210`

**Not handled:**
- HTTP errors from YouTube (e.g. 4xx, 5xx)
- SSL errors within the IFrame
- Page crashes / renderer crashes
- JavaScript errors from the IFrame

---

## 7. Navigation Architecture

**File:** [`lib/core/router/app_router.dart`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/router/app_router.dart)

**Router:** GoRouter with a single `ShellRoute` wrapping all main navigation in `ScaffoldWithNav`.

| Route | Screen | Type |
|---|---|---|
| `/home` (initial) | `HomeScreen` | Shell child |
| `/search` | `SearchScreen` | Shell child |
| `/library` | `LibraryScreen` | Shell child |
| `/player` | `PlayerScreen` | Shell child (slide-up from bottom) |
| `/artist/:id` | `ArtistScreen` | Shell child |
| `/album/:id` | `AlbumScreen` | Shell child |
| `/playlist/:id` | `PlaylistDetailScreen` | Shell child |
| `/playlist/remote/:id` | `RemotePlaylistScreen` | Shell child |
| `/liked-songs` | `LikedSongsScreen` | Shell child |
| `/radio/:type/:id` | `RadioDetailsScreen` | Shell child |
| `/genre/:id` | `GenreDetailsScreen` | Shell child |
| `/settings` | `SettingsScreen` | Shell child |
| `/recently-played` | `RecentlyPlayedScreen` | Shell child |

**Bottom navigation bar:** Home (`/home`), Search (`/search`), Library (`/library`) via `context.go()`.

**Player navigation:** Mini-player tap → `context.push('/player')`; player dismiss → `context.pop()`.

---

## 8. Media Playback Architecture

### Engine Overview

The playback engine is a **local package** at `lib/core/playback/packages/pp_playback_engine/`.

**Abstract interface:** [`PlaybackController`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/packages/pp_playback_engine/lib/src/engine/playback_controller.dart)  
**Implementation:** [`MediaKitPlaybackEngine`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart)

The engine has two internal modes:
1. **IFrame mode** (`isIFrameMode: true`) — YouTube playback via `YoutubePlayerController`. **This is the active path.**
2. **media_kit mode** (`isIFrameMode: false`) — direct native playback via `media_kit Player`. **Not used at runtime** (the engine always enters IFrame mode immediately on `play()`).

### Playback Flow (Confirmed)

```
User taps track
        ↓
PlayerNotifier.playTrack(track)               [player_provider.dart:90]
        ↓
  Check: track.youtubeVideoId == null?
  YES → PlaybackService.resolveCandidates()    [playback_service.dart:66]
          ↓
        YoutubeResolver.resolve(artist, name)  [youtube_resolver.dart:19]
          ↓
        YOUTUBE_SEARCH_METHOD=scraping →
        _viaScraping() → GET youtube.com/results?search_query=...  [youtube_resolver.dart:84]
          → parse ytInitialData JSON in background isolate
          → return up to 10 video IDs
          ↓
        candidates.first → resolvedId
          ↓
        AppDatabase.cacheYoutubeId()           [app_database.dart:152]
  NO → use track.youtubeVideoId directly
        ↓
_controller.play(track.toPlaybackTrack())      [playback_providers.dart:10]
        ↓
MediaKitPlaybackEngine.play(track)             [media_kit_playback_engine.dart:98]
        ↓
  _updateStatus(isIFrameMode: true, state: preparing)
        ↓
  _enterIFrameMode(videoId)                    [media_kit_playback_engine.dart:130]
        ↓
  YoutubePlayerController created (if first time)
  └── 3000ms warmup delay
        ↓
  loadVideoById(videoId)                       [media_kit_playback_engine.dart:222]
  playVideo() after 1500ms delay               [media_kit_playback_engine.dart:228]
        ↓
  Watchdog timer (2s interval) monitors state   [media_kit_playback_engine.dart:183]
  └── retries loadVideoById/playVideo if stuck >10s
  └── safety cutoff at ~40s
        ↓
  IFrame position polling (500ms)              [media_kit_playback_engine.dart:317]
  └── currentTime/duration from controller
        ↓
PlaybackStatus stream → PlayerNotifier._syncFromStatus()
        ↓
  state.ended → PlayerNotifier.skipNext()      [player_provider.dart:66]
```

### Video Surface / Overlay

**File:** [`lib/shared/widgets/scaffold_with_nav.dart`](file:///Users/veneno/Projects/Apps/ppplayer/lib/shared/widgets/scaffold_with_nav.dart)

The `PlaybackView` widget (containing the `YoutubePlayer` IFrame) is rendered in a **globally persistent `AnimatedPositioned` overlay** inside `ScaffoldWithNav`. This overlay:
- Floats bottom-right (160×90px) when NOT on the player screen and video is active
- Moves to fill the `_videoSlotKey` rect in `PlayerScreen` when on the player screen in Video view

The `videoSurfaceKeyProvider` provides a `GlobalKey` wrapping the `RepaintBoundary` holding the video widget, keeping it alive across navigation transitions.

---

## 9. YouTube Flow

### How PPPlayer handles YouTube

| Question | Answer | Evidence |
|---|---|---|
| Opens youtube.com directly? | **No** | No `url_launcher` YouTube calls found |
| Uses embed URL? | **Yes** — via `youtube_player_iframe` package (embeds `https://www.youtube.com/embed/{id}`) | `youtube_player_iframe` package internals |
| Transforms YouTube URLs? | **Yes** — resolves Spotify track metadata → YouTube video ID via search | `youtube_resolver.dart` |
| Uses iframe? | **Yes** — `YoutubePlayer` widget from `youtube_player_iframe` | `playback_view.dart:37` |
| Uses YouTube mobile site? | **Unknown** — determined by `youtube_player_iframe` package internals | - |
| Custom user agent? | **No** app-level UA override; UA is set by the platform WebView | - |
| Cookies required? | **Unknown / Likely yes** — YouTube IFrame may use cookies for consent state | Requires runtime verification |
| JavaScript required? | **Yes** — IFrame API JS bridge | `youtube_player_iframe` package |
| Autoplay expected? | **Yes** — `playVideo()` called after load | `media_kit_playback_engine.dart:228` |
| Fullscreen supported? | **Configured** — `showFullscreenButton: true`, but behavior is platform-dependent | `media_kit_playback_engine.dart:138` |
| Navigation intercepted? | **No** — no custom WebViewClient in app code | - |
| YouTube URLs redirected externally? | **No** | - |

### YouTube Search Resolution

**Active method:** HTML scraping (`YOUTUBE_SEARCH_METHOD=scraping` in `.env`)

```
YoutubeResolver._viaScraping(artist, track)
  → GET https://www.youtube.com/results?search_query={encoded}
    Headers: Windows Chrome UA + Accept-Language: en-US
  → parse ytInitialData JSON (background isolate via compute())
  → extract up to 10 videoRenderer.videoId values
```

**Fallback method:** YouTube Data API v3 (requires `YOUTUBE_API_KEY`, not currently active)

### YouTube video ID in the `PlaybackTrack`

When `Track.toPlaybackTrack()` is called:
```dart
id: youtubeVideoId ?? spotifyId
```

If `youtubeVideoId` is null, the Spotify ID is used as the playback ID, which would cause YouTube to fail. The resolution flow **should** have run before this point, but if resolution fails silently, the Spotify ID would be passed to `YoutubePlayerController.fromVideoId()`.

---

## 10. Authentication & Persistence

### Spotify API

- **Auth method:** OAuth 2.0 Client Credentials (no user login, no scopes)
- **Credentials storage:** Hardcoded in `.env` file, loaded at startup via `flutter_dotenv`
  - `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET` are in plaintext in `.env`
- **Token handling:** In-memory only (`SpotifyClient._accessToken`, `_tokenExpiry`). Not persisted to disk.
- **Token refresh:** Automatic via `_ensureToken()` on each API call
- **No user auth:** No login/logout, no OAuth redirect, no user-specific Spotify data

### YouTube

- **No auth:** YouTube resolution uses scraping or API key; no user session
- **API key storage:** Plaintext in `.env` file

### Local Persistence

| Data | Store | Key/Table |
|---|---|---|
| Play history | Drift (SQLite) | `tracks.last_played_at`, `tracks.play_count` |
| Favorites (tracks) | Drift | `tracks.is_favorite` |
| YouTube video ID cache | Drift | `tracks.youtube_video_id` |
| Followed artists | Drift | `artists.is_followed` |
| Liked albums | Drift | `albums.is_liked` |
| Local playlists | Drift | `playlists`, `playlist_tracks` |
| Followed radios | Drift | `radios` |
| Country/market | Hive (`settings` box) | `selected_country` |
| Theme index | Hive | `theme_index` |
| Player view mode | Hive | `player_view` |
| Performance mode | Hive | `performance_mode` |
| Low data mode | Hive | `low_data_mode` |
| Show video | Hive | `show_video` |

**Database file:** `ppplayer_db` (Drift default — typically `ppplayer_db.sqlite` in app documents directory)

**WebView state:** The `YoutubePlayerController` is held in memory as a singleton inside `MediaKitPlaybackEngine`. It is **not persisted** across app restarts. The `playbackControllerProvider` is created fresh on each app start.

**What survives app restarts:**
- Cached YouTube video IDs (Drift)
- Play history (Drift)
- Favorites, followed artists, liked albums (Drift)
- Settings (Hive)

**What does NOT survive app restarts:**
- Current playback queue (in-memory only in `PlayerNotifier`)
- Current playing track (in-memory only)
- YouTube IFrame controller state

---

## 11. Android Lifecycle

### `MainActivity`

**File:** [`android/app/src/main/kotlin/com/ppplayer/app/MainActivity.kt`](file:///Users/veneno/Projects/Apps/ppplayer/android/app/src/main/kotlin/com/ppplayer/app/MainActivity.kt)

```kotlin
class MainActivity : AudioServiceActivity()
```

Minimal — extends `AudioServiceActivity` from the `audio_service` package. No custom lifecycle overrides.

### Activity Lifecycle Behavior

| Event | Behavior |
|---|---|
| App starts | `main()` runs full init sequence (MediaKit, Hive, AudioSession, AudioService) |
| Activity created | Flutter engine starts, `PpPlayerApp` builds |
| WebView created | `YoutubePlayerController` created lazily on first `play()` call — **not** at app startup |
| User navigates | GoRouter updates route; `ScaffoldWithNav` overlay stays alive (persistent `GlobalKey`) |
| App backgrounded | `AudioService` foreground service keeps audio session; `audio_service` manages lifecycle |
| App resumed | Flutter resumes; `YoutubePlayerController` state is **unknown** (likely paused by system) |
| Activity recreated (rotation etc.) | Flutter typically handles this via `configChanges` in manifest (orientation etc. listed) |
| Process killed | All in-memory state lost; Drift + Hive data survives |
| App reopened after kill | Full `main()` re-runs; queue and playback not restored |

### Android Manifest Lifecycle Config

**File:** [`android/app/src/main/AndroidManifest.xml`](file:///Users/veneno/Projects/Apps/ppplayer/android/app/src/main/AndroidManifest.xml)

- `launchMode="singleTop"` — prevents duplicate activity instances
- `configChanges` covers orientation, screen size, keyboard, locale, density, uiMode — Flutter handles these
- `hardwareAccelerated="true"` — required for WebView/video

### Android Permissions

| Permission | Purpose |
|---|---|
| `INTERNET` | All network requests |
| `WAKE_LOCK` | Keep screen/CPU alive during playback |
| `FOREGROUND_SERVICE` | Background audio service |
| `FOREGROUND_SERVICE_MEDIA_PLAYBACK` | Android 14+ media playback foreground service type |
| `POST_NOTIFICATIONS` | Android 13+ notification permission (requested at runtime) |
| `BLUETOOTH_CONNECT` | Bluetooth headphone/speaker support |
| `MODIFY_AUDIO_SETTINGS` | Audio focus management |

---

## 12. Dependencies

### Runtime Dependencies (Key)

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.5.1 | State management |
| `go_router` | ^13.2.5 | Navigation |
| `audio_service` | ^0.18.18 | Background audio + system media controls |
| `audio_session` | ^0.2.3 | Audio focus (iOS/Android) |
| `media_kit` | ^1.2.6 | Native media player (libmpv) — **initialized but not actively used for playback** |
| `media_kit_video` | ^2.0.1 | Video renderer for media_kit |
| `media_kit_libs_video` | ^1.0.7 | Native libs for media_kit |
| `youtube_player_iframe` | ^5.2.2 | YouTube IFrame playback (primary video path) |
| `youtube_explode_dart` | ^3.0.5 | YouTube stream extraction — **listed in engine pubspec, not confirmed used in runtime** |
| `youtube_explode_dart_plus` | ^1.0.3 | youtube_explode extension — **not observed in any source** |
| `dio` | ^5.9.2 | HTTP client |
| `drift` + `drift_flutter` | ^2.22.0 | SQLite ORM |
| `hive_ce` + `hive_ce_flutter` | ^2.19.3 | Key-value persistence |
| `google_mobile_ads` | ^7.0.0 | AdMob ads (initialized with delay) |
| `in_app_purchase` | ^3.2.3 | IAP — **declared but not used in any source file found** |
| `flutter_dotenv` | ^6.0.0 | Environment variables from `.env` |
| `cached_network_image` | ^3.4.1 | Image caching |
| `flutter_animate` | ^4.5.2 | Animation utilities |
| `freezed_annotation` | ^2.4.4 | Immutable model code generation |
| `permission_handler` | ^11.3.1 | Runtime permissions |
| `connectivity_plus` | ^7.0.0 | Network connectivity |
| `path_provider` | ^2.1.5 | File system paths |
| `url_launcher` | ^6.3.2 | External URL opening |

### Build Dependencies

| Package | Version |
|---|---|
| `build_runner` | ^2.4.13 |
| `drift_dev` | ^2.22.0 |
| `riverpod_generator` | ^2.4.3 |
| `freezed` | ^2.5.7 |
| `json_serializable` | ^6.9.3 |
| `mocktail` | ^1.0.4 |

---

## 13. Existing Tests

### Main App Tests

**File:** [`test/playback_queue_test.dart`](file:///Users/veneno/Projects/Apps/ppplayer/test/playback_queue_test.dart)

**Coverage:** 5 unit tests for `PlaybackQueue` (pure Dart, no Flutter/engine):
- `next()` normal advance
- `next()` at end with no repeat (stops)
- `next()` wraps with repeat-all
- `next()` stays with repeat-one
- `previous()` wraps to end with repeat-all at index 0
- `reorder()` index tracking (moving down and moving up)

### Engine Package Tests

**File:** [`lib/core/playback/packages/pp_playback_engine/test/iframe_view_test.dart`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/packages/pp_playback_engine/test/iframe_view_test.dart)

**Coverage:** 2 widget tests for `PlaybackView`:
- Renders `YoutubePlayer` when `isIFrameMode=true` and controller is not null
- Does not render `YoutubePlayer` when `isIFrameMode=true` but controller is null

### What is NOT covered

| Area | Test Coverage |
|---|---|
| YouTube resolution (`YoutubeResolver`) | ❌ None |
| Spotify API client (`SpotifyClient`) | ❌ None |
| `MediaKitPlaybackEngine` | ❌ None |
| `PlayerNotifier` | ❌ None |
| Database queries (`AppDatabase`) | ❌ None |
| Navigation / routing | ❌ None |
| Authentication/token refresh | ❌ None |
| Settings persistence (Hive) | ❌ None |
| `PpPlayerAudioHandler` | ❌ None |
| `MediaSyncService` | ❌ None |
| Lifecycle behavior | ❌ None |
| YouTube playback E2E | ❌ None |
| `PlaybackQueue.previous()` restart-track case | ❌ Not tested |
| `PlaybackQueue.add()` | ❌ Not tested |
| `PlaybackQueue.removeAt()` | ❌ Not tested |

---

## 14. Known Problems

### 1. `mediaSyncServiceProvider` is never consumed
**File:** [`lib/core/playback/media_sync_service.dart:93`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/media_sync_service.dart#L93)

`mediaSyncServiceProvider` is defined but **never `ref.watch`-ed or `ref.read`-ed** anywhere. Because Riverpod providers are lazy by default, `MediaSyncService._init()` is never called. **System media controls (lock screen, notification) receive no playback state updates.** The notification will not update position, playing/paused state, or track metadata.

### 2. YouTube scraping fragility
**File:** [`lib/core/api/youtube_resolver.dart:84`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/api/youtube_resolver.dart#L84)

The active resolution method (`YOUTUBE_SEARCH_METHOD=scraping`) parses `ytInitialData` from YouTube's HTML. This data structure is:
- Undocumented
- Changed by YouTube without notice
- May return empty results if YouTube changes its HTML format
- May be blocked by Google's anti-scraping infrastructure
- Rate-limited without the user being aware

### 3. Playback ID fallback uses Spotify ID
**File:** [`lib/core/playback/playback_providers.dart:13`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/playback_providers.dart#L13)

```dart
id: youtubeVideoId ?? spotifyId
```

If YouTube resolution fails silently (exception caught, empty list returned), `youtubeVideoId` remains null and `spotifyId` is passed to `YoutubePlayerController.fromVideoId()`. A Spotify ID is not a valid YouTube video ID and will cause the player to fail.

### 4. 3-second initialization delay hardcoded
**File:** [`lib/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart:173`](file:///Users/veneno/Projects/Apps/ppplayer/lib/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart#L173)

```dart
await Future.delayed(const Duration(milliseconds: 3000));
```

The comment says *"resource-heavy emulator"*. This delay is unconditional — it adds 3 seconds of dead time before every first play in a session.

### 5. media_kit is initialized but not used
`MediaKit.ensureInitialized()` is called in `main()` and a `Player` + `VideoController` are created in `MediaKitPlaybackEngine`, but because `play()` immediately sets `isIFrameMode: true` and never exits it, the media_kit path is dead code at runtime. This adds unnecessary startup overhead and native library loading.

### 6. `youtube_explode_dart` and `youtube_explode_dart_plus` are declared but not used
Both packages appear in `pubspec.yaml` and the engine's `pubspec.yaml` but no imports of either were found in any `.dart` source file in active code paths. These are dead dependencies.

### 7. `in_app_purchase` declared but not implemented
`in_app_purchase ^3.2.3` is in `pubspec.yaml` but no IAP code exists in any source file.

### 8. AdMob using test App ID
**File:** [`android/app/src/main/AndroidManifest.xml:65`](file:///Users/veneno/Projects/Apps/ppplayer/android/app/src/main/AndroidManifest.xml#L65)

`ca-app-pub-3940256099942544~3347511713` is Google's **test App ID**. This is appropriate for development but must be replaced before production release.

### 9. Release build signed with debug keys
**File:** [`android/app/build.gradle.kts:37`](file:///Users/veneno/Projects/Apps/ppplayer/android/app/build.gradle.kts#L37)

```kotlin
signingConfig = signingConfigs.getByName("debug")
```

The TODO comment acknowledges this. Release builds cannot be distributed to Google Play with debug signing.

### 10. API credentials in `.env` are committed to source
**File:** [`.env`](file:///Users/veneno/Projects/Apps/ppplayer/.env)

`SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, and `YOUTUBE_API_KEY` are in plaintext. The `.env` file is included in the Flutter asset bundle (`pubspec.yaml:69`). These values are accessible by extracting the APK/IPA.

---

## 15. Areas Requiring Deeper Investigation

### A. `youtube_player_iframe` Platform Behavior
The entire YouTube playback experience depends on this package. The following requires runtime investigation:
- How the WebView is configured on each platform (Android, iOS, macOS)
- Whether cookies are enabled and how consent state is managed
- Whether the user agent is set to something YouTube accepts
- Whether autoplay restrictions apply (especially on iOS)
- How fullscreen transitions work and whether they cause lifecycle issues
- What happens when the YouTube video is `videoEmbeddable: false` (Error 150)
- What happens when a region restriction blocks the video

### B. The Watchdog Timer Behavior
The `_watchdogTimer` in `MediaKitPlaybackEngine` fires every 2 seconds and retries `loadVideoById`/`playVideo` if the player is stuck. The conditions for "stuck" and the retry behavior need verification:
- Does `loadVideoById` reset to a new video or reload the same one?
- At what tick does the watchdog actually become useful vs. harmful?
- Is the 20-tick (40s) safety cutoff sufficient?

### C. `PlaybackView` Video Surface Lifecycle
The persistent `GlobalKey`/`RepaintBoundary` video overlay approach in `ScaffoldWithNav` keeps the video widget tree alive across navigation. The interaction between this approach and Flutter's widget tree on:
- Back navigation from `/player`
- App backgrounding/foregrounding
- Platform view lifecycle on Android

### D. `mediaSyncServiceProvider` — Is this intentional?
It is unclear whether `MediaSyncService` was intentionally disabled or is a bug. If system media controls are required (lock screen controls, Bluetooth headphone buttons), this provider needs to be consumed somewhere (e.g., in `ScaffoldWithNav.initState()` or as an eager provider).

### E. `connectivity_plus` — Not observed in use
`connectivity_plus` is declared but no imports or usage were found in any reviewed source file. Whether it is used in unreviewed screens needs verification.

### F. `url_launcher` — Usage pattern
Declared in dependencies. Where external URLs are launched (e.g., opening links in artist bios or settings) was not fully traced.

### G. Platform-specific behavior (macOS)
The app is currently running on macOS (`flutter run -d macos`). Whether the `youtube_player_iframe` WebView works correctly on macOS (vs. Android/iOS) has different implications — particularly around sandbox entitlements, network access, and WebView availability.

### H. AdMob initialization and ad display
The ad service (`ad_service.dart`) and `banner_ad_widget.dart` exist. The exact surfaces where ads appear and whether the ad lifecycle is handled correctly (especially in relation to the player screen and navigation) was not fully reviewed.

### I. Spotify API market/region handling
`SpotifyClient` is constructed with the `selectedCountryProvider` market. If the market changes in settings, the provider rebuilds. Whether this causes in-flight request issues or stale track data needs verification.

### J. YouTube scraping rate limiting and bot detection
The scraping path sends a request with a Windows Chrome user agent to `youtube.com/results`. Behavior under:
- Repeated rapid requests (queue skip)
- Bot detection / CAPTCHA enforcement
- YouTube's `ytInitialData` format changes
needs ongoing monitoring.
