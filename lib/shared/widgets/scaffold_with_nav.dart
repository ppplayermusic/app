import 'package:ppplayer/l10n/app_localizations.dart';

import 'dart:ui';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/playback/playback_providers.dart';
import '../../core/player/player_provider.dart';
import '../../core/player/video_layout_provider.dart';
import '../../core/services/settings_provider.dart';
import '../../core/providers/search_provider.dart';
import '../../core/providers/recent_searches_provider.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/pp_image.dart';
import 'user_avatar.dart';
import 'profile_modal.dart';
import 'premium_modals.dart';
import '../../core/db/app_database.dart' as db;
import 'artists_links.dart';
import 'context_menu/content_context_menu.dart';
import '../../core/models/track.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../features/settings/widgets/about_dialog.dart';

class ScaffoldWithNav extends ConsumerStatefulWidget {
  const ScaffoldWithNav({
    super.key,
    required this.child,
    required this.location,
  });
  final Widget child;
  final String location;

  @override
  ConsumerState<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends ConsumerState<ScaffoldWithNav> {
  final GlobalKey _stackKey = GlobalKey();
  double _lastFinalTop = 0.0;

  @override
  Widget build(BuildContext context) {
    final playbackEngine = ref.watch(playbackControllerProvider);
    // Watch only structural identity — NOT position/buffered (those are 10 Hz).
    // This prevents the entire ScaffoldWithNav from rebuilding on every tick.
    ref.watch(
      playbackStatusProvider.select((a) {
        final v = a.value;
        return (
          v?.activeVideoId,
          v?.isIFrameMode ?? false,
          v?.state ?? PlaybackState.idle,
        );
      }),
    );
    // Read full status without subscribing for widgets that need it inline.
    final playbackStatus =
        ref.read(playbackStatusProvider).value ?? const PlaybackStatus();

    final settings = ref.watch(settingsProvider);
    final showVideo = settings.showVideo;
    final playerView = settings.playerView;
    final isVideoView = playerView == PlayerView.video;
    final isPlayerScreen = widget.location == '/player';
    final currentTrack = ref.watch(playerProvider.select((s) => s.currentTrack));
    final isLocalTrack = currentTrack?.sourceType == TrackSourceType.local;
    final hasVideoId = ref.watch(
      playerProvider.select((s) => s.videoId != null),
    ) && !isLocalTrack;
    final loadError = ref.watch(playerProvider.select((s) => s.loadError));
    final isPipMode = ref.watch(playerProvider.select((s) => s.isPipMode));

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    final videoLayout = ref.watch(videoLayoutProvider);

    // ---------------------------------------------------------------
    // ---------------------------------------------------------------
    // KEY INSIGHT: When WKWebView.visibleRect == NSRect.zero, WebKit
    // suspends the JavaScript engine entirely (not just throttles it).
    // This means our JS guardian timer can't run → YouTube stays paused.
    //
    // FIX: Always keep at least a 2×2 px "peek" inside the window bounds.
    //   visibleRect = 2×2 ≠ zero → WebKit keeps JS alive → guardian fires
    //   every 150 ms → any YouTube auto-pause is reversed within one tick.
    //
    // The peek is positioned at the extreme bottom-right corner and is
    // imperceptible to users. We achieve it by combining:
    //   top:   screenHeight - kPeek  (only kPeek rows visible at bottom)
    //   right: -(kMinW - kPeek)      (negative = extend past the right edge,
    //                                 so only kPeek columns visible)
    // ---------------------------------------------------------------
    const double kMinW = 160;
    const double kMinH = 90;
    const double kPeek = 2.0; // px kept inside window to avoid JS suspension
    // On Windows, the Win32 floating webview ignores Flutter layout constraints
    // and clamps itself to the visible screen area. We must use a large negative
    // top/left position to truly move it off-screen, while keeping kMinW x kMinH
    // so the underlying JS engine stays alive.
    final isWindows = !kIsWeb && Platform.isWindows;
    const double kOffScreen = -9999.0;

    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final isDesktop = boxConstraints.maxWidth >= 600;

        Widget content = Scaffold(
          body: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (isDesktop && !isPlayerScreen && !isPipMode)
                  const _DesktopSidebar(),
                Expanded(
                  child: Stack(
                    children: [
                      // Gradient Background & Animated Mesh
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 800,
                          height: 600,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.8, -0.8),
                              radius: 1.5,
                              colors: [
                                const Color(
                                  0xFF4A1010,
                                ).withValues(alpha: 0.5), // Dark red
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: _MeshPainter(
                              primaryColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          if (isDesktop && !isPlayerScreen && !isPipMode)
                            const _DesktopTopBar(),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final stackHeight = constraints.maxHeight;

                                double renderW,
                                    renderH,
                                    renderTop,
                                    renderLeft,
                                    renderRadius;
                                bool showShadow;

                                if (isPipMode) {
                                  renderW = constraints.maxWidth;
                                  renderH = constraints.maxHeight;
                                  renderTop = 0;
                                  renderLeft = 0;
                                  renderRadius = 0;
                                  showShadow = false;
                                } else if (isPlayerScreen) {
                                  if (isVideoView &&
                                      videoLayout.isVisible &&
                                      videoLayout.isReady) {
                                    // Initial values (will be refined by globalToLocal in the Builder below)
                                    renderW = videoLayout.size.width;
                                    renderH = videoLayout.size.height;
                                    renderTop = 0;
                                    renderLeft = 0;
                                    renderRadius = 24;
                                    showShadow = false;
                                  } else {
                                    // ARTWORK / QUEUE tabs — keep size so JS stays alive.
                                    // On Windows, we use kMinW/kMinH and move it far off-screen
                                    // because Win32 ignores tiny constraints and clamps to visible area.
                                    // On macOS/others, use the 2×2 peek trick.
                                    renderW = isWindows ? kMinW : kPeek;
                                    renderH = isWindows ? kMinH : kPeek;
                                    renderTop = isWindows ? kOffScreen : stackHeight - kPeek;
                                    renderLeft = isWindows ? kOffScreen : screenWidth - kPeek;
                                    renderRadius = 0;
                                    showShadow = false;
                                  }
                                } else {
                                  // Not on player screen — show mini floating video if enabled
                                  if (showVideo && hasVideoId) {
                                    renderW = kMinW;
                                    renderH = kMinH;
                                    renderLeft =
                                        screenWidth -
                                        (isDesktop && !isPlayerScreen
                                            ? 240
                                            : 0) -
                                        kMinW -
                                        16;
                                    // Sit above the mini-player bar on mobile, or bottom right on desktop
                                    renderTop = stackHeight - kMinH - 8;
                                    renderRadius = 12;
                                    showShadow = true;
                                  } else {
                                    // Miniplayer hidden — keep size so JS stays alive.
                                    // On Windows, move it far off-screen. On macOS/others, use 2×2 peek.
                                    renderW = isWindows ? kMinW : kPeek;
                                    renderH = isWindows ? kMinH : kPeek;
                                    renderTop = isWindows ? kOffScreen : stackHeight - kPeek;
                                    renderLeft = isWindows
                                        ? kOffScreen
                                        : screenWidth -
                                              (isDesktop && !isPlayerScreen
                                                  ? 240
                                                  : 0) -
                                              kPeek;
                                    renderRadius = 0;
                                    showShadow = false;
                                  }
                                }

                                return Stack(
                                  key: _stackKey,
                                  children: [
                                    Visibility(
                                      visible: !isPipMode,
                                      maintainState: true,
                                      child: widget.child,
                                    ),
                                    // Always-mounted WebView — never removed or hidden via Opacity.
                                    // Audio plays uninterrupted on all tabs and when minimized.
                                    Builder(
                                      builder: (context) {
                                        double finalTop = renderTop;
                                        double finalLeft = renderLeft;

                                        // Precise alignment for the video slot in PlayerScreen
                                        if (isPlayerScreen &&
                                            isVideoView &&
                                            videoLayout.isVisible &&
                                            videoLayout.isReady) {
                                          final RenderBox? stackBox =
                                              _stackKey.currentContext
                                                      ?.findRenderObject()
                                                  as RenderBox?;
                                          if (stackBox != null) {
                                            // globalToLocal is the gold standard for syncing separate widget trees.
                                            // It automatically handles SafeArea, TabBars, and parent offsets.
                                            final localPos = stackBox
                                                .globalToLocal(
                                                  videoLayout.position,
                                                );
                                            finalTop = localPos.dy;
                                            finalLeft = localPos.dx;
                                          }
                                        }
                                        
                                        final bool isHidingTransition = (finalTop == kOffScreen || _lastFinalTop == kOffScreen);
                                        // Update the tracked position for the next frame
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) {
                                            _lastFinalTop = finalTop;
                                          }
                                        });

                                        return AnimatedPositioned(
                                          duration:
                                              (isPipMode || (isWindows && isHidingTransition))
                                                  ? Duration.zero
                                                  : const Duration(
                                                    milliseconds: 250,
                                                  ),
                                          curve: Curves.easeOutQuart,
                                          top: finalTop,
                                          left: finalLeft,
                                          width: renderW,
                                          height: renderH,
                                          child: AnimatedContainer(
                                            duration:
                                                (isPipMode || (!kIsWeb && Platform.isWindows && isHidingTransition))
                                                    ? Duration.zero
                                                    : const Duration(
                                                      milliseconds: 250,
                                                    ),
                                            curve: Curves.easeOutQuart,
                                            decoration: BoxDecoration(
                                              color:
                                                  isPipMode ? Colors.black : Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    renderRadius,
                                                  ),
                                              boxShadow: [
                                                if (showShadow)
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .scrim
                                                        .withValues(alpha: 0.5),
                                                    blurRadius: 15,
                                                    offset: const Offset(0, 6),
                                                  ),
                                              ],
                                            ),
                                            // clipBehavior is permanently Clip.none.
                                            // Toggling it (antiAlias ↔ none) remounts the
                                            // entire child subtree, destroying the WebView.
                                            // Rounded corners are provided by the BoxDecoration
                                            // background. Child content is clipped by the
                                            // ClipRRect below only when renderRadius > 0.
                                            clipBehavior: Clip.none,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    renderRadius,
                                                  ),
                                              child: Stack(
                                                children: [
                                                  // Stable WebView host — never remounts during PiP.
                                                  if (playbackStatus.track?.isLocal != true)
                                                    _StablePlaybackView(
                                                      controller: playbackEngine,
                                                      status: playbackStatus,
                                                    ),

                                                  if (loadError != null)
                                                    Positioned.fill(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              renderRadius,
                                                            ),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                sigmaX: 10,
                                                                sigmaY: 10,
                                                              ),
                                                          child: Container(
                                                            color: Theme.of(
                                                                  context,
                                                                )
                                                                .colorScheme
                                                                .surface
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .error_outline_rounded,
                                                                  color:
                                                                      Theme.of(
                                                                        context,
                                                                      ).colorScheme.error,
                                                                  size: 24, // Use fixed size instead of renderH * 0.25 to avoid overflow in miniplayer
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    loadError,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          )
                                                                              .colorScheme
                                                                              .error,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                TactileTap(
                                                                  onTap:
                                                                      () =>
                                                                          ref
                                                                              .read(
                                                                                playerProvider.notifier,
                                                                              )
                                                                              .retryLoad(),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          ).colorScheme.primary,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            20,
                                                                          ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Theme.of(
                                                                            context,
                                                                          ).colorScheme.primary.withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                          blurRadius:
                                                                              10,
                                                                          offset: const Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .refresh_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        const Text(
                                                                          'Retry',
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ), // Stack
                                            ), // ClipRRect
                                          ), // AnimatedContainer
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              isPlayerScreen || isPipMode
                  ? null
                  : isDesktop
                  ? const _DesktopPlayerBar()
                  : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_MiniPlayerBar(), _BottomNavBar()],
                  ),
        );

        if (!kIsWeb && Platform.isMacOS) {
          content = PlatformMenuBar(
            menus: [
              PlatformMenu(
                label: 'PPPlayer',
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformMenuItem(
                        label: 'About PPPlayer',
                        onSelected: () async {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => const PpAboutDialog(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.servicesSubmenu),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hideOtherApplications),
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.showAllApplications),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
                    ],
                  ),
                ],
              ),
              PlatformMenu(
                label: 'View',
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.toggleFullScreen),
                    ],
                  ),
                ],
              ),
              PlatformMenu(
                label: 'Window',
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
                    ],
                  ),
                ],
              ),
            ],
            child: content,
          );
        }

        return content;
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = switch (location) {
      String s when s.startsWith('/home') => 0,
      String s when s.startsWith('/discover') => 1,
      String s when s.startsWith('/search') => 2,
      String s when s.startsWith('/library') => 3,
      _ => -1,
    };

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.paddingOf(context).bottom + 6,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.scrim.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: AppLocalizations.of(context)!.home,
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavBarItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: AppLocalizations.of(context)!.discover,
                isSelected: currentIndex == 1,
                onTap: () => context.go('/discover'),
              ),
              _NavBarItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: AppLocalizations.of(context)!.search,
                isSelected: currentIndex == 2,
                onTap: () => context.go('/search'),
              ),
              _NavBarItem(
                icon: Icons.library_music_outlined,
                activeIcon: Icons.library_music,
                label: AppLocalizations.of(context)!.library,
                isSelected: currentIndex == 3,
                onTap: () => context.go('/library'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color =
        isSelected
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha: 0.5);

    return TactileTap(
      onTap: onTap,
      scaleDown: 0.85, // More pronounced tactile feedback for nav items
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                letterSpacing: 0.2,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayerBar extends ConsumerWidget {
  const _MiniPlayerBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final track = playerState.currentTrack;
    final isLocalTrack = track?.sourceType == TrackSourceType.local;
    final showVideo = ref.watch(settingsProvider.select((s) => s.showVideo));
    final colorScheme = Theme.of(context).colorScheme;

    if (track == null) return const SizedBox.shrink();

    final progress =
        playerState.duration.inSeconds > 0
            ? playerState.position.inSeconds / playerState.duration.inSeconds
            : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: ContentContextMenuRegion(
            target: TrackContextTarget(track),
            child: TactileTap(
              onTap: () => context.push('/player'),
              scaleDown: 0.98,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    width: 0.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Progress Bar at the top edge
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Subtle Logo Watermark
                    Positioned(
                      right: -20,
                      bottom: -15,
                      child: Opacity(
                        opacity: 0.05,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Image.asset(
                            'assets/logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: PPImage(
                            imageUrl: track.albumImage ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              ArtistsLinks(
                                track: track,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TactileIconButton(
                          icon: Icons.skip_previous,
                          onTap:
                              () =>
                                  ref
                                      .read(playerProvider.notifier)
                                      .skipPrevious(),
                          size: 24,
                          hoverColor: colorScheme.primary,
                          tooltip: AppLocalizations.of(context)!.previous,
                        ),
                        TactilePlayerPlayPauseButton(
                          isPlaying: playerState.isPlaying,
                          size: 34,
                          onTap:
                              () =>
                                  ref
                                      .read(playerProvider.notifier)
                                      .togglePlay(),
                          tooltip: playerState.isPlaying ? 'Pause' : 'Play',
                        ),
                        TactileIconButton(
                          icon: Icons.skip_next,
                          onTap:
                              () =>
                                  ref.read(playerProvider.notifier).skipNext(),
                          size: 24,
                          hoverColor: colorScheme.primary,
                          tooltip: AppLocalizations.of(context)!.next,
                        ),
                        const SizedBox(width: 4),
                        if (isLocalTrack == false)
                          TactileIconButton(
                            icon: showVideo ? Icons.videocam : Icons.videocam_off,
                            onTap:
                                () =>
                                    ref
                                        .read(settingsProvider.notifier)
                                        .toggleVideo(),
                            size: 18,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                            hoverColor: colorScheme.onSurface,
                            tooltip: showVideo ? 'Hide Video' : 'Show Video',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopSidebar extends ConsumerWidget {
  const _DesktopSidebar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;
    final database = ref.watch(db.appDatabaseProvider);
    final currentIndex = switch (location) {
      String s when s.startsWith('/home') => 0,
      String s when s.startsWith('/discover') => 1,
      String s when s.startsWith('/search') => 2,
      String s when s.startsWith('/library') => 3,
      _ => -1,
    };

    return Container(
      width: 240,
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Hero(
                      tag: 'app_logo',
                      child: Image.asset('assets/logo.png', height: 28),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(width: 8),
                Text(
                  'PPPlayer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: AppLocalizations.of(context)!.home,
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/home'),
                ),
                _SidebarItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: AppLocalizations.of(context)!.discover,
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/discover'),
                ),
                _SidebarItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: AppLocalizations.of(context)!.search,
                  isSelected: currentIndex == 2,
                  onTap: () => context.go('/search'),
                ),
                _SidebarItem(
                  icon: Icons.library_music_outlined,
                  activeIcon: Icons.library_music,
                  label: AppLocalizations.of(context)!.library,
                  isSelected:
                      currentIndex == 3 &&
                      GoRouterState.of(context).uri.queryParameters['filter'] !=
                          'playlists',
                  onTap: () => context.go('/library'),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    'YOUR MUSIC',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                _SidebarItem(
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  label: AppLocalizations.of(context)!.favorites,
                  isSelected: location.startsWith('/liked-songs'),
                  onTap: () => context.push('/liked-songs'),
                ),
                _SidebarItem(
                  icon: Icons.history,
                  activeIcon: Icons.history,
                  label: AppLocalizations.of(context)!.recentlyPlayed,
                  isSelected: location.startsWith('/recently-played'),
                  onTap: () => context.push('/recently-played'),
                ),
                _SidebarItem(
                  icon: Icons.queue_music,
                  activeIcon: Icons.queue_music,
                  label: AppLocalizations.of(context)!.playlists,
                  isSelected:
                      location.startsWith('/library') &&
                      GoRouterState.of(context).uri.queryParameters['filter'] ==
                          'playlists',
                  onTap: () => context.go('/library?filter=playlists'),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PLAYLISTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      TactileIconButton(
                        icon: Icons.add_rounded,
                        size: 18,
                        padding: const EdgeInsets.all(4),
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        hoverColor: colorScheme.primary,
                        tooltip: AppLocalizations.of(context)!.newPlaylist,
                        onTap: () async {
                          final nameController = TextEditingController();
                          await showPremiumModal(
                            context: context,
                            title: AppLocalizations.of(context)!.newPlaylist,
                            child: Builder(
                              builder: (modalContext) {
                                final modalColors =
                                    Theme.of(modalContext).colorScheme;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      autofocus: true,
                                      style: TextStyle(
                                        color: modalColors.onSurface,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.playlistName,
                                        filled: true,
                                        fillColor: modalColors
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.of(
                                                    modalContext,
                                                  ).pop(),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: modalColors.onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TactileTap(
                                          onTap: () async {
                                            final name =
                                                nameController.text.trim();
                                            if (name.isNotEmpty) {
                                              await database.createPlaylist(
                                                name,
                                              );
                                              if (modalContext.mounted) {
                                                Navigator.of(
                                                  modalContext,
                                                ).pop();
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: modalColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Create',
                                              style: TextStyle(
                                                color: modalColors.onPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<db.Playlist>>(
                  stream: database.watchPlaylists(),
                  builder: (context, snap) {
                    final playlists = snap.data ?? [];
                    if (playlists.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Text(
                          'No playlists yet.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children:
                          playlists.map((p) {
                            return ContentContextMenuRegion(
                              target: PlaylistContextTarget(
                                id: '${p.id}',
                                name: p.name,
                                imageUrl: p.imageUrl,
                                isLocal: true,
                                localId: p.id,
                              ),
                              child: _MockPlaylistItem(
                                title: p.name,
                                subtitle: AppLocalizations.of(context)!.playlist,
                                imageUrl:
                                    p.imageUrl ??
                                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(p.name)}&background=random',
                                onTap: () {
                                  context.push('/playlist/${p.id}');
                                },
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final iconColor =
        widget.isSelected
            ? colorScheme.onPrimary
            : (_isHovered
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.70));

    final textColor =
        widget.isSelected
            ? colorScheme.onPrimary
            : (_isHovered
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.70));

    final hoverBg = colorScheme.onSurface.withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient:
                  widget.isSelected
                      ? LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.80),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                      : null,
              color:
                  widget.isSelected
                      ? null
                      : (_isHovered ? hoverBg : Colors.transparent),
              border: Border.all(
                color:
                    widget.isSelected
                        ? Colors.transparent
                        : (_isHovered
                            ? colorScheme.outlineVariant.withValues(alpha: 0.18)
                            : Colors.transparent),
                width: 1.0,
              ),
              boxShadow:
                  widget.isSelected
                      ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: _isHovered ? 0.35 : 0.20,
                          ),
                          blurRadius: _isHovered ? 12 : 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : null,
            ),
            child: Row(
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    widget.isSelected ? widget.activeIcon : widget.icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight:
                          (widget.isSelected || _isHovered)
                              ? FontWeight.w600
                              : FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MockPlaylistItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const _MockPlaylistItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  });

  @override
  State<_MockPlaylistItem> createState() => _MockPlaylistItemState();
}

class _MockPlaylistItemState extends State<_MockPlaylistItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap ?? () => context.go('/library'),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  _isHovered
                      ? colorScheme.onSurface.withValues(alpha: 0.08)
                      : Colors.transparent,
              border: Border.all(
                color:
                    _isHovered
                        ? colorScheme.outlineVariant.withValues(alpha: 0.16)
                        : Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: PPImage(
                      imageUrl: widget.imageUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              _isHovered ? FontWeight.w600 : FontWeight.w500,
                          color:
                              _isHovered
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface.withValues(
                                    alpha: 0.9,
                                  ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              _isHovered
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                          fontWeight:
                              _isHovered ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopPlayerBar extends ConsumerWidget {
  const _DesktopPlayerBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final track = playerState.currentTrack;
    final isLocalTrack = track?.sourceType == TrackSourceType.local;
    final showVideo = ref.watch(settingsProvider.select((s) => s.showVideo));
    final colorScheme = Theme.of(context).colorScheme;

    if (track == null) return const SizedBox.shrink();

    final progress =
        playerState.duration.inSeconds > 0
            ? playerState.position.inSeconds / playerState.duration.inSeconds
            : 0.0;
    final bufferedProgress =
        playerState.duration.inSeconds > 0
            ? playerState.buffered.inSeconds / playerState.duration.inSeconds
            : 0.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            border: Border(
              top: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Left: Track Info
                      Expanded(
                        flex: 1,
                        child: ContentContextMenuRegion(
                          target: TrackContextTarget(track),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: PPImage(
                                  imageUrl: track.albumImage ?? '',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    ArtistsLinks(
                                      track: track,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Center: Controls
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TactileIconButton(
                            icon: Icons.shuffle,
                            onTap:
                                () =>
                                    ref
                                        .read(playerProvider.notifier)
                                        .toggleShuffle(),
                            size: 20,
                            color:
                                playerState.isShuffled
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.7,
                                    ),
                            hoverColor:
                                playerState.isShuffled
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                            tooltip: AppLocalizations.of(context)!.shuffle,
                          ),
                          const SizedBox(width: 16),
                          TactileIconButton(
                            icon: Icons.skip_previous,
                            onTap:
                                () =>
                                    ref
                                        .read(playerProvider.notifier)
                                        .skipPrevious(),
                            size: 28,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                            hoverColor: colorScheme.primary,
                            tooltip: AppLocalizations.of(context)!.previous,
                          ),
                          const SizedBox(width: 16),
                          TactilePlayerPlayPauseButton(
                            isPlaying: playerState.isPlaying,
                            size: 46,
                            onTap:
                                () =>
                                    ref
                                        .read(playerProvider.notifier)
                                        .togglePlay(),
                            tooltip: playerState.isPlaying ? 'Pause' : 'Play',
                          ),
                          const SizedBox(width: 16),
                          TactileIconButton(
                            icon: Icons.skip_next,
                            onTap:
                                () =>
                                    ref
                                        .read(playerProvider.notifier)
                                        .skipNext(),
                            size: 28,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                            hoverColor: colorScheme.primary,
                            tooltip: AppLocalizations.of(context)!.next,
                          ),
                          const SizedBox(width: 16),
                          TactileIconButton(
                            icon:
                                playerState.repeatMode == RepeatMode.one
                                    ? Icons.repeat_one
                                    : Icons.repeat,
                            onTap:
                                () =>
                                    ref
                                        .read(playerProvider.notifier)
                                        .cycleRepeat(),
                            size: 20,
                            color:
                                playerState.repeatMode != RepeatMode.none
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.7,
                                    ),
                            hoverColor:
                                playerState.repeatMode != RepeatMode.none
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                            tooltip:
                                playerState.repeatMode == RepeatMode.one
                                    ? 'Repeat One'
                                    : (playerState.repeatMode == RepeatMode.all
                                        ? 'Repeat All'
                                        : 'Repeat Off'),
                          ),
                        ],
                      ),

                      // Right: Extra controls
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Volume control with mute toggle
                            TactileIconButton(
                              icon:
                                  playerState.volume == 0
                                      ? Icons.volume_off
                                      : (playerState.volume < 0.5
                                          ? Icons.volume_down
                                          : Icons.volume_up),
                              size: 19,
                              padding: const EdgeInsets.all(6),
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.8,
                              ),
                              hoverColor: colorScheme.primary,
                              tooltip:
                                  playerState.volume == 0 ? 'Unmute' : 'Mute',
                              onTap: () {
                                final notifier = ref.read(
                                  playerProvider.notifier,
                                );
                                if (playerState.volume > 0) {
                                  notifier.setVolume(0);
                                } else {
                                  notifier.setVolume(0.7);
                                }
                              },
                            ),
                            Flexible(
                              child: _DesktopVolumeSlider(
                                volume: playerState.volume,
                                onChanged:
                                    (val) => ref
                                        .read(playerProvider.notifier)
                                        .setVolume(val),
                              ),
                            ),
                            if (isLocalTrack == false) ...[
                              const SizedBox(width: 8),
                              TactileIconButton(
                                icon:
                                    showVideo
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                onTap:
                                    () =>
                                        ref
                                            .read(settingsProvider.notifier)
                                            .toggleVideo(),
                                size: 20,
                                color:
                                    showVideo
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant.withValues(
                                          alpha: 0.7,
                                        ),
                                hoverColor: colorScheme.onSurface,
                                tooltip: showVideo ? 'Hide Video' : 'Show Video',
                              ),
                            ],
                            const SizedBox(width: 16),
                            TactileIconButton(
                              icon: Icons.queue_music,
                              onTap: () => context.push('/player'),
                              size: 20,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                              hoverColor: colorScheme.primary,
                              tooltip: AppLocalizations.of(context)!.queueTooltip,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _DesktopProgressBar(
            progress: progress,
            bufferedProgress: bufferedProgress,
            duration: playerState.duration,
            onSeek: (pos) => ref.read(playerProvider.notifier).seekTo(pos),
          ),
        ),
      ],
    );
  }
}

class _DesktopProgressBar extends StatefulWidget {
  final double progress;
  final double bufferedProgress;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const _DesktopProgressBar({
    required this.progress,
    required this.bufferedProgress,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<_DesktopProgressBar> createState() => _DesktopProgressBarState();
}

class _DesktopProgressBarState extends State<_DesktopProgressBar> {
  bool _isHovered = false;
  double? _dragProgress;
  double _hoverProgress = 0.0;
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleSeek(Offset localPosition, double totalWidth) {
    if (totalWidth <= 0 || widget.duration.inMilliseconds <= 0) return;
    final ratio = (localPosition.dx / totalWidth).clamp(0.0, 1.0);
    setState(() {
      _dragProgress = ratio;
    });
  }

  void _commitSeek() {
    if (_dragProgress != null && widget.duration.inMilliseconds > 0) {
      final targetMs =
          (widget.duration.inMilliseconds * _dragProgress!).round();
      widget.onSeek(Duration(milliseconds: targetMs));
      setState(() {
        _dragProgress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentProgress = (_dragProgress ?? widget.progress).clamp(0.0, 1.0);
    final hoverOrDragProgress = (_dragProgress ?? _hoverProgress).clamp(
      0.0,
      1.0,
    );
    final hoverDuration = Duration(
      milliseconds:
          (widget.duration.inMilliseconds * hoverOrDragProgress).round(),
    );
    final isActive = _isHovered || _dragProgress != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isActive) {
        if (!_tooltipController.isShowing) _tooltipController.show();
      } else {
        if (_tooltipController.isShowing) _tooltipController.hide();
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          onHover: (details) {
            if (constraints.maxWidth > 0) {
              setState(() {
                _hoverProgress = (details.localPosition.dx /
                        constraints.maxWidth)
                    .clamp(0.0, 1.0);
              });
            }
          },
          child: OverlayPortal(
            controller: _tooltipController,
            overlayChildBuilder: (context) {
              final tooltipX =
                  (constraints.maxWidth * hoverOrDragProgress).clamp(
                    16.0,
                    constraints.maxWidth - 32.0,
                  ) -
                  16.0;

              return Positioned(
                top: 0,
                left: 0,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(tooltipX, -28.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _formatDuration(hoverDuration),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown:
                    (details) => _handleSeek(
                      details.localPosition,
                      constraints.maxWidth,
                    ),
                onTapUp: (details) => _commitSeek(),
                onTapCancel: () => setState(() => _dragProgress = null),
                onHorizontalDragStart:
                    (details) => _handleSeek(
                      details.localPosition,
                      constraints.maxWidth,
                    ),
                onHorizontalDragUpdate:
                    (details) => _handleSeek(
                      details.localPosition,
                      constraints.maxWidth,
                    ),
                onHorizontalDragEnd: (details) => _commitSeek(),
                onHorizontalDragCancel:
                    () => setState(() => _dragProgress = null),
                child: Container(
                  height: 16.0, // Larger hit area
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      // Background track
                      Container(
                        height: isActive ? 4.5 : 2.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(
                            alpha: isActive ? 0.18 : 0.10,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Buffered track
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.bufferedProgress.clamp(0.0, 1.0),
                        child: Container(
                          height: isActive ? 4.5 : 2.5,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      // Active progress track
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: currentProgress,
                        child: Container(
                          height: isActive ? 4.5 : 2.5,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow:
                                isActive
                                    ? [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.45,
                                        ),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                    : null,
                          ),
                        ),
                      ),
                      // Thumb
                      if (isActive)
                        Positioned(
                          left: (constraints.maxWidth * currentProgress).clamp(
                            0.0,
                            constraints.maxWidth - 12.0,
                          ),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopVolumeSlider extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _DesktopVolumeSlider({required this.volume, required this.onChanged});

  @override
  State<_DesktopVolumeSlider> createState() => _DesktopVolumeSliderState();
}

class _DesktopVolumeSliderState extends State<_DesktopVolumeSlider> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 86),
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: _isHovered ? 4.5 : 3.0,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: _isHovered ? 6.5 : 4.5,
              elevation: _isHovered ? 2.0 : 0.0,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor:
                _isHovered
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.85),
            inactiveTrackColor: colorScheme.onSurface.withValues(
              alpha: _isHovered ? 0.25 : 0.15,
            ),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: widget.volume,
            min: 0.0,
            max: 1.0,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}

class _DesktopTopBar extends ConsumerStatefulWidget {
  const _DesktopTopBar();

  @override
  ConsumerState<_DesktopTopBar> createState() => _DesktopTopBarState();
}

class _DesktopTopBarState extends ConsumerState<_DesktopTopBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep controller in sync if provider changes from elsewhere
    ref.listen<String>(searchQueryProvider, (prev, next) {
      if (_ctrl.text != next) {
        _ctrl.text = next;
        _ctrl.selection = TextSelection.fromPosition(
          TextPosition(offset: next.length),
        );
      }
    });

    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 320,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          onTap: () {
                            if (GoRouterState.of(context).uri.path !=
                                '/search') {
                              context.go('/search');
                            }
                          },
                          onChanged: (val) {
                            ref
                                .read(searchQueryProvider.notifier)
                                .updateQuery(val);
                          },
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              ref
                                  .read(recentSearchesProvider.notifier)
                                  .addSearch(val);
                            }
                          },
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchHint,
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: false,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          cursorColor: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          TactileIconButton(
            icon: Icons.history,
            onTap: () => context.push('/recently-played'),
            size: 24,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 16),
          TactileIconButton(
            icon: Icons.settings_outlined,
            onTap: () => context.push('/settings'),
            size: 24,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 16),
          // Profile Avatar
          if (settings.userName.isNotEmpty)
            TactileTap(
              onTap: () => showEditProfileModal(context, ref),
              child: Hero(
                tag: 'settings_hero',
                child: UserAvatarWidget(
                  settings: settings,
                  size: 32,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final Color primaryColor;
  _MeshPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Primary Brand Blob
    paint.color = primaryColor.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 120, paint);

    // Dynamic Secondary Blob (derived from theme)
    final secondaryColor =
        Color.lerp(primaryColor, primaryColor.withValues(alpha: 0.8), 0.2) ??
        primaryColor;
    paint.color = secondaryColor.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 90, paint);

    // Dynamic Tertiary Blob (derived from theme)
    final tertiaryColor =
        Color.lerp(primaryColor, primaryColor.withValues(alpha: 0.6), 0.2) ??
        primaryColor;
    paint.color = tertiaryColor.withValues(alpha: 0.08);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 100, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor;
}

/// A stable wrapper around [PlaybackView] that survives parent rebuilds.
///
/// When [ScaffoldWithNav] rebuilds due to [isPipMode] changing, a normal
/// stateless child would be remounted — recreating [YoutubePlayer] and
/// calling [init()] again, which resets the video to paused.
///
/// This widget uses [AutomaticKeepAliveClientMixin] to keep its state alive
/// across parent rebuilds, preventing [YoutubePlayer] from being remounted.
class _StablePlaybackView extends StatefulWidget {
  final PlaybackController controller;
  final PlaybackStatus status;

  const _StablePlaybackView({required this.controller, required this.status});

  @override
  State<_StablePlaybackView> createState() => _StablePlaybackViewState();
}

class _StablePlaybackViewState extends State<_StablePlaybackView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required for AutomaticKeepAliveClientMixin
    return RepaintBoundary(
      child: PlaybackView(controller: widget.controller, status: widget.status),
    );
  }
}
