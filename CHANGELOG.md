# Changelog

All notable changes to PPPlayer will be documented in this file.

## [1.3.0] - 2026-09-13

### Added
- Added localizations for Nigerian Pidgin, Filipino, Latvian, Bengali, Croatian, Malay, Persian, and Estonian languages.


## [1.1.2] - 2026-09-12

### Added
- Added Arabic and Chinese (Simplified & Traditional) localizations.

### Fixed
- Fixed an issue on macOS where the YouTube video player would shift off-center when resizing the application window.

## [1.1.1] - 2026-09-12

### Fixed
- Fixed an issue where the seek bar would instantly snap back to the start position when sliding it immediately after launching the app.
- Fixed the seek bar showing a duration of 0:00 when the app is first launched.

## [1.1.0] - 2026-09-11

### Added
- Comprehensive internationalization and localization across the entire app and website.
- Added full support for 11 global languages: Spanish, French, German, Portuguese, Italian, Japanese, Korean, Chinese, Hindi, Russian, and Arabic.
- Added an in-app language picker in the Preferences menu that applies translations instantly without restarting the app.
- Native OS-level language integrations on Android 13+ and iOS to sync the app's language automatically with system-level per-app language settings.
- Replaced all hardcoded text strings in the app and website with responsive localization keys.

## [1.0.6] - 2026-09-11

### Fixed
- Fixed a critical bug causing the app to crash on a blank screen on fresh installations due to a missing environment configuration file.

## [1.0.5] - 2026-09-11

### Fixed
- Fixed an issue on macOS where background playback would pause between songs when the app was minimized due to App Nap.

## [1.0.4] - 2026-09-11

### Added
- Automated release workflow via GitHub Actions for consistent builds and code signing.
- Official signed and notarized macOS releases now available directly on the website.
- Added MIT License to the repository.

### Fixed
- Fixed submodule checkout configuration in CI workflows.

## [1.0.3] - 2026-09-10

### Added
- Hybrid playback engine providing robust background processing and lock-screen playback capabilities.
- Deduplication and generation IDs to prevent overlapping and stale media commands across WebView bridge.

### Fixed
- Fixed an issue where the song queue would sometimes not automatically advance to the next track.
- Fixed a bug where a paused track would unexpectedly resume when handing off from foreground to PiP or background.
- Accurate millisecond precision reporting for current track position and playback duration.
- Eliminated several IDE linter errors and cleaned up redundant files.

## [1.0.2] - 2026-09-09

### Improved
- Context-aware Autoplay prioritizes original artist before falling back to related artists.
- Tiered Recommendation Engine accurately pulls exact artist tracks without mismatched searches.
- Autoplay uses explicit playback context instead of only relying on majority queue items.

## [1.0.1] - 2026-09-09

### Added
- Autoplay recommendations when the playback queue is ending.
- Custom Spotify and YouTube API credentials.
- Discover section with personalized recommendations.
- Additional language support.
- Added dynamic tooltip that follows the mouse cursor on the seekbar.

### Changed
- Improved playback queue persistence.
- Improved macOS media control integration.
- Updated player animations using Material 3 Expressive-inspired motion.

### Fixed
- Fixed duplicate macOS Now Playing controls caused by WebKit.
- Fixed station tracks not being highlighted correctly.
- Fixed playback state restoration after restarting the app.
- Fixed playback pausing/stopping unexpectedly when dragging the seekbar.
- Fixed bottom player bar rendering fully transparent and unreadable on macOS when playing music.

---

## [1.0.0] - 2026-09-XX

### Added
- Initial public release of PPPlayer.
- Spotify-powered music metadata.
- YouTube-powered audio playback.
- Playlists, favorites and listening history.
- macOS, Windows and Linux support.
