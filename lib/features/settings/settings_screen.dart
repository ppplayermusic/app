import 'dart:io';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/spotify_client.dart';
import '../../core/services/settings_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/db/app_database.dart' as db;
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../shared/widgets/profile_modal.dart';
import 'widgets/api_credentials_modal.dart';
import 'widgets/about_dialog.dart';
import '../../core/cache/catalog_cache_repository.dart';
import '../../core/cache/image_cache_manager.dart';
import '../../core/api/spotify_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/cache/clear_cache_helper.dart';

final availableMarketsProvider = FutureProvider<List<String>>((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getAvailableMarkets();
});

final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version}+${info.buildNumber} Premium Beta';
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Glassmorphic App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
            elevation: 0,
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
              color: colorScheme.onSurface,
            ),
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.8,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),

          // Hero Section
          SliverToBoxAdapter(
            child:
                Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        final themeColor =
                            AppTheme.themeColors[settings.themeIndex];
                        final avatarColor =
                            AppTheme.themeColors[settings.userAvatarColorIndex];
                        return _SettingsHero(
                          themeColor: themeColor,
                          avatarColor: avatarColor,
                          settings: settings,
                        );
                      },
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
          ),

          // Settings Groups
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(context, 'Profile')
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.editProfile,
                      subtitle: settings.userName.isEmpty
                          ? 'Set your name and avatar'
                          : settings.userName,
                      icon: Icons.person_rounded,
                      onTap: () => showEditProfileModal(context, ref),
                    )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Preferences')
                    .animate(delay: 250.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.contentMarket,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.currentCountry(settings.selectedCountry),
                      icon: Icons.public_rounded,
                      onTap: () => _showCountryPicker(context, ref),
                    )
                    .animate(delay: 250.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.language,
                      subtitle: settings.languageCode == null
                          ? AppLocalizations.of(context)!.systemDefault
                          : _getLanguageName(settings.languageCode, context),
                      icon: Icons.language_rounded,
                      onTap: () => _showLanguagePicker(context, ref),
                    )
                    .animate(delay: 250.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSwitchTile(
                      title: AppLocalizations.of(context)!.showVideoPlayer,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.useYoutubePlayerWhenAvailable,
                      icon: Icons.smart_display_rounded,
                      value: settings.showVideo,
                      onChanged: (v) =>
                          ref.read(settingsProvider.notifier).toggleVideo(),
                    )
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                _buildThemeSelector(context, ref, settings),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'API Credentials')
                    .animate(delay: 360.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.spotifyCredentials,
                      subtitle:
                          settings.spotifyProvider == SpotifyProviderType.custom
                          ? 'Custom Provider'
                          : 'PPPlayer Default',
                      icon: Icons.key_rounded,
                      onTap: () => showSpotifyCredentialsModal(context),
                    )
                    .animate(delay: 370.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.youtubeCredentials,
                      subtitle:
                          settings.youtubeSearchMethod ==
                              YoutubeSearchMethod.scraping
                          ? AppLocalizations.of(context)!.scraping
                          : (settings.youtubeApiProvider ==
                                    YoutubeApiProviderType.custom
                                ? 'Custom Provider'
                                : 'PPPlayer Default'),
                      icon: Icons.play_arrow_rounded,
                      onTap: () => showYoutubeCredentialsModal(context),
                    )
                    .animate(delay: 380.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Data & Storage')
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSwitchTile(
                      title: AppLocalizations.of(context)!.autoplay,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.keepPlayingSimilarTracksWhenQueueEnds,
                      icon: Icons.all_inclusive_rounded,
                      value: settings.autoplayEnabled,
                      onChanged: (v) =>
                          ref.read(settingsProvider.notifier).toggleAutoplay(v),
                    )
                    .animate(delay: 390.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSwitchTile(
                      title: AppLocalizations.of(context)!.lowDataMode,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.forceAudioonlyStreamsToSaveData,
                      icon: Icons.data_usage_rounded,
                      value: settings.lowDataMode,
                      onChanged: (v) => ref
                          .read(settingsProvider.notifier)
                          .toggleLowDataMode(),
                    )
                    .animate(delay: 450.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                if (Platform.isAndroid) ...[
                  TactileSwitchTile(
                        title: AppLocalizations.of(
                          context,
                        )!.pictureinpicturePip,
                        subtitle: AppLocalizations.of(
                          context,
                        )!.continueVideoPlaybackInASmallWindow,
                        icon: Icons.picture_in_picture_alt_rounded,
                        value: settings.continuePlaybackInPip,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .toggleContinuePlaybackInPip(v),
                      )
                      .animate(delay: 480.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                  const SizedBox(height: 12),
                ],
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.clearRecentlyPlayed,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.permanentlyRemoveListeningHistory,
                      icon: Icons.history_rounded,
                      color: colorScheme.error.withValues(alpha: 0.8),
                      onTap: () => _showClearHistoryConfirm(context, ref),
                    )
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                TactileSettingTile(
                      title: AppLocalizations.of(context)!.clearCache,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.freesUpSpaceAndForcesFreshDataOnNextLoad,
                      icon: Icons.delete_outline_rounded,
                      color: colorScheme.error.withValues(alpha: 0.8),
                      onTap: () => _showClearCacheConfirm(context, ref),
                    )
                    .animate(delay: 550.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'About')
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                Consumer(
                      builder: (context, ref, _) {
                        final versionAsync = ref.watch(appVersionProvider);
                        return TactileSettingTile(
                          title: AppLocalizations.of(context)!.appVersion,
                          subtitle: versionAsync.when(
                            data: (version) => version,
                            loading: () => 'Loading...',
                            error: (e, _) => 'Unknown',
                          ),
                          icon: Icons.info_outline_rounded,
                          onTap: versionAsync.hasValue
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const PpAboutDialog(),
                                  );
                                }
                              : null,
                        );
                      },
                    )
                    .animate(delay: 650.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(context, 'Theme Color'),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child:
                      Text(
                            AppTheme.themeNames[settings.themeIndex],
                            style: TextStyle(
                              color: AppTheme.themeColors[settings.themeIndex],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          )
                          .animate(key: ValueKey(settings.themeIndex))
                          .fadeIn()
                          .slideX(begin: 0.2),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          physics: const BouncingScrollPhysics(),
                          itemCount: AppTheme.themeColors.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final color = AppTheme.themeColors[index];
                            final isSelected = settings.themeIndex == index;

                            return TactileTap(
                              onTap: () {
                                if (!isSelected) {
                                  HapticFeedback.mediumImpact();
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setTheme(index);
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: 400.ms,
                                    width: isSelected ? 54 : 46,
                                    height: isSelected ? 54 : 46,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurface.withValues(
                                                alpha: 0.24,
                                              ),
                                        width: isSelected ? 3 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: color.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_rounded,
                                      color: colorScheme.surface,
                                      size: 26,
                                    ).animate().scale(
                                      duration: 200.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        .animate(delay: 350.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOutCubic);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.2,
        ),
      ),
    );
  }

  void _showClearCacheConfirm(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showPremiumModal(
      context: context,
      title: AppLocalizations.of(context)!.clearAppCache,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This will clear all cached tracks, playlists, and albums. The app will fetch fresh data on the next load. Your library and favorites will not be affected.',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TactileTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) => TactileTap(
                    onTap: () async {
                      // 1. Clear Catalog L1 and L2 Caches
                      await ref.read(catalogCacheRepositoryProvider).clearAll();

                      // 2. Clear Image Caches (Disk and Memory)
                      PaintingBinding.instance.imageCache.clear();
                      PaintingBinding.instance.imageCache.clearLiveImages();
                      await PPImageCacheManager.instance.emptyCache();

                      // 3. Invalidate API and Repository Providers
                      ref.invalidate(spotifyClientProvider);
                      ref.invalidate(spotifyRepositoryProvider);

                      // 4. Invalidate all feature-level catalog providers
                      invalidateCatalogProviders(ref);

                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.clearCache,
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearHistoryConfirm(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showPremiumModal(
      context: context,
      title: AppLocalizations.of(context)!.clearHistory,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This will permanently remove your listening history. This action cannot be undone.',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TactileTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) => TactileTap(
                    onTap: () async {
                      await ref.read(db.appDatabaseProvider).clearHistory();
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String? code, BuildContext context) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português (Brasil)';
      case 'it':
        return 'Italiano';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'hi':
        return 'हिन्दी';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      case 'id':
        return 'Bahasa Indonesia';
      case 'my':
        return 'မြန်မာ';
      case 'pl':
        return 'Polski';
      case 'da':
        return 'Dansk';
      case 'kk':
        return 'Қазақша';
      case 'cs':
        return 'Čeština';
      case 'hu':
        return 'Magyar';
      case 'ka':
        return 'ქართული';
      case 'sv':
        return 'Svenska';
      case 'uz':
        return 'O\'zbekcha';
      case 'fil':
        return 'Filipino';
      case 'lv':
        return 'Latviešu';
      case 'bn':
        return 'বাংলা';
      case 'pcm':
        return 'Naija';
      case 'et':
        return 'Eesti';
      case 'fa':
        return 'فارسی';
      case 'gn':
        return 'Avañe\'ẽ';
      case 'hr':
        return 'Hrvatski';
      case 'ms':
        return 'Bahasa Melayu';
      case 'tr':
        return 'Türkçe';
      default:
        return AppLocalizations.of(context)!.systemDefault;
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // Build options dynamically from the app's generated supportedLocales
    final supportedLocales = [
      {'code': null, 'name': AppLocalizations.of(context)!.systemDefault},
      ...AppLocalizations.supportedLocales.map(
        (locale) => {
          'code': locale.languageCode,
          'name': _getLanguageName(locale.languageCode, context),
        },
      ),
    ];

    showPremiumModal(
      context: context,
      title: AppLocalizations.of(context)!.language,
      child: SizedBox(
        height: 450,
        child: Consumer(
          builder: (context, ref, _) {
            final settings = ref.watch(settingsProvider);
            final currentLanguage = settings.languageCode;

            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = supportedLocales[index];
                final code = locale['code'];
                final name = locale['name']!;
                final isSelected = code == currentLanguage;
                final themeColor = AppTheme.themeColors[settings.themeIndex];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TactileTap(
                    onTap: () {
                      ref.read(settingsProvider.notifier).setLanguageCode(code);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.onSurface.withValues(alpha: 0.1)
                            : colorScheme.onSurface.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? themeColor.withValues(alpha: 0.5)
                              : colorScheme.onSurface.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? themeColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? themeColor
                                    : colorScheme.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: colorScheme.surface,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showPremiumModal(
      context: context,
      title: AppLocalizations.of(context)!.selectMarket,
      child: SizedBox(
        height: 450,
        child: Consumer(
          builder: (context, ref, _) {
            final marketsAsync = ref.watch(availableMarketsProvider);
            final currentCountry = ref.watch(selectedCountryProvider);

            return marketsAsync.when(
              data: (markets) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: markets.length,
                  itemBuilder: (context, index) {
                    final code = markets[index];
                    final isSelected = code == currentCountry;
                    final settings = ref.watch(settingsProvider);
                    final themeColor =
                        AppTheme.themeColors[settings.themeIndex];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TactileTap(
                        onTap: () {
                          ref.read(settingsProvider.notifier).setCountry(code);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.onSurface.withValues(alpha: 0.1)
                                : colorScheme.onSurface.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.onSurface.withValues(
                                      alpha: 0.24,
                                    )
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? themeColor
                                      : colorScheme.onSurface.withValues(
                                          alpha: 0.1,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    code.substring(
                                      0,
                                      code.length >= 2 ? 2 : code.length,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                code,
                                style: TextStyle(
                                  color: isSelected
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                Icon(
                                  Icons.check_rounded,
                                  color: themeColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () {
                final settings = ref.watch(settingsProvider);
                final themeColor = AppTheme.themeColors[settings.themeIndex];
                return Center(
                  child: CircularProgressIndicator(color: themeColor),
                );
              },
              error: (err, _) => Center(
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.errorLoadingMarkets(err.toString()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  final Color themeColor;
  final Color avatarColor;
  final SettingsState settings;

  const _SettingsHero({
    required this.themeColor,
    required this.avatarColor,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: colorScheme.onSurface.withValues(alpha: 0.03),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Mesh Gradient / Ambient Background
            Positioned.fill(
              child: Animate(onPlay: (controller) => controller.repeat())
                  .custom(
                    duration: const Duration(seconds: 15),
                    builder: (context, value, child) => CustomPaint(
                      painter: _MeshPainter(
                        animationValue: value,
                        themeColor: themeColor,
                        secondaryColor: colorScheme.secondary,
                        tertiaryColor: colorScheme.tertiary,
                      ),
                    ),
                  ),
            ),
            // Glass Surface
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.onSurface.withValues(alpha: 0.12),
                      colorScheme.onSurface.withValues(alpha: 0.04),
                    ],
                  ),
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child:
                        Container(
                              padding: const EdgeInsets.all(24),
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withValues(alpha: 0.3),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat())
                            .rotate(duration: 10.seconds, begin: 0, end: 1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PPPlayer',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'PRO EXPERIENCE ACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: themeColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double animationValue;
  final Color themeColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  _MeshPainter({
    required this.animationValue,
    required this.themeColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Primary Brand Blob
    paint.color = themeColor.withValues(alpha: 0.3);
    final center1 = Offset(
      size.width * (0.5 + 0.35 * math.cos(animationValue * 2 * math.pi)),
      size.height * (0.5 + 0.35 * math.sin(animationValue * 2 * math.pi)),
    );
    canvas.drawCircle(center1, 120, paint);

    // Dynamic Secondary Blob (derived from theme)
    final derivedSecondary =
        Color.lerp(themeColor, secondaryColor, 0.2) ?? themeColor;
    paint.color = derivedSecondary.withValues(alpha: 0.2);
    final center2 = Offset(
      size.width *
          (0.5 + 0.45 * math.cos((animationValue + 0.3) * 2 * math.pi)),
      size.height *
          (0.5 + 0.25 * math.sin((animationValue + 0.3) * 2 * math.pi)),
    );
    canvas.drawCircle(center2, 100, paint);

    // Dynamic Tertiary Blob (derived from theme)
    final derivedTertiary =
        Color.lerp(themeColor, tertiaryColor, 0.2) ?? themeColor;
    paint.color = derivedTertiary.withValues(alpha: 0.15);
    final center3 = Offset(
      size.width *
          (0.5 + 0.25 * math.cos((animationValue + 0.7) * 2 * math.pi)),
      size.height *
          (0.5 + 0.45 * math.sin((animationValue + 0.7) * 2 * math.pi)),
    );
    canvas.drawCircle(center3, 110, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class TactileSettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const TactileSettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TactileTap(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.onSurface.withValues(alpha: 0.05),
                  colorScheme.onSurface.withValues(alpha: 0.01),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (color ?? colorScheme.onSurface).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (color ?? colorScheme.onSurface).withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color:
                        color ?? colorScheme.onSurface.withValues(alpha: 0.9),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TactileSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TactileSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.05),
                colorScheme.onSurface.withValues(alpha: 0.01),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colorScheme.onSurface, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Consumer(
                  builder: (context, ref, _) {
                    final settings = ref.watch(settingsProvider);
                    final themeColor =
                        AppTheme.themeColors[settings.themeIndex];
                    return Switch.adaptive(
                      value: value,
                      activeTrackColor: themeColor.withValues(alpha: 0.5),
                      activeThumbColor: themeColor,
                      onChanged: (v) {
                        HapticFeedback.mediumImpact();
                        onChanged(v);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
