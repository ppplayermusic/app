import 'dart:ui';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/playback/playback_providers.dart';
import '../../core/player/player_provider.dart';
import '../../core/player/video_layout_provider.dart';
import '../../core/services/settings_provider.dart';
import '../../core/providers/search_provider.dart';
import '../../core/providers/recent_searches_provider.dart';
import '../../shared/widgets/tactile_buttons.dart';
import 'user_avatar.dart';
import 'profile_modal.dart';
import '../../core/db/app_database.dart' as db;
import 'artists_links.dart';
import 'context_menu/content_context_menu.dart';
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

  @override
  Widget build(BuildContext context) {
    final playbackEngine = ref.watch(playbackControllerProvider);
    final playbackStatusAsync = ref.watch(playbackStatusProvider);
    final playbackStatus = playbackStatusAsync.value ?? const PlaybackStatus();
    final settings = ref.watch(settingsProvider);
    final showVideo = settings.showVideo;
    final playerView = settings.playerView;
    final isVideoView = playerView == PlayerView.video;
    final playerState = ref.watch(playerProvider);
    final isPlayerScreen = widget.location == '/player';
    final hasVideoId = playerState.videoId != null;

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

    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final isDesktop = boxConstraints.maxWidth >= 600;

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (isDesktop && !isPlayerScreen)
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
                                const Color(0xFF4A1010).withValues(alpha: 0.5), // Dark red
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: _MeshPainter(primaryColor: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          if (isDesktop && !isPlayerScreen) const _DesktopTopBar(),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final stackHeight = constraints.maxHeight;

                            double renderW, renderH, renderTop, renderLeft, renderRadius;
                            bool showShadow;

                            if (isPlayerScreen) {
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
                                // ARTWORK / QUEUE tabs — keep 2×2 peek so JS stays alive.
                                // We place it at the bottom-right of the Stack.
                                renderW = kMinW;
                                renderH = kMinH;
                                renderTop = stackHeight - kPeek;
                                renderLeft = screenWidth - kPeek;
                                renderRadius = 0;
                                showShadow = false;
                              }
                            } else {
                              // Not on player screen — show mini floating video if enabled
                              if (showVideo && hasVideoId) {
                                renderW = kMinW;
                                renderH = kMinH;
                                renderLeft = screenWidth - (isDesktop && !isPlayerScreen ? 240 : 0) - kMinW - 16;
                                // Sit above the mini-player bar on mobile, or bottom right on desktop
                                renderTop = stackHeight - kMinH - 8;
                                renderRadius = 12;
                                showShadow = true;
                              } else {
                                // Miniplayer hidden — keep 2×2 peek at the bottom-right
                                renderW = kMinW;
                                renderH = kMinH;
                                renderTop = stackHeight - kPeek;
                                renderLeft = screenWidth - (isDesktop && !isPlayerScreen ? 240 : 0) - kPeek;
                                renderRadius = 0;
                                showShadow = false;
                              }
                            }

                            return Stack(
                              key: _stackKey,
                              children: [
                                widget.child,
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
                                          _stackKey.currentContext?.findRenderObject()
                                              as RenderBox?;
                                      if (stackBox != null) {
                                        // globalToLocal is the gold standard for syncing separate widget trees.
                                        // It automatically handles SafeArea, TabBars, and parent offsets.
                                        final localPos = stackBox.globalToLocal(
                                          videoLayout.position,
                                        );
                                        finalTop = localPos.dy;
                                        finalLeft = localPos.dx;
                                      }
                                    }

                                    return AnimatedPositioned(
                                      duration: const Duration(milliseconds: 120),
                                      curve: Curves.easeOutQuart,
                                      top: finalTop,
                                      left: finalLeft,
                                      width: renderW,
                                      height: renderH,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 120),
                                        curve: Curves.easeOutQuart,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            renderRadius,
                                          ),
                                          boxShadow: [
                                            if (showShadow)
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.scrim
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 15,
                                                offset: const Offset(0, 6),
                                              ),
                                          ],
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: [
                                            RepaintBoundary(
                                              child: PlaybackView(
                                                controller: playbackEngine,
                                                status: playbackStatus,
                                              ),
                                            ),
                                            if (playerState.loadError != null)
                                              Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                    renderRadius,
                                                  ),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                      sigmaX: 10,
                                                      sigmaY: 10,
                                                    ),
                                                    child: Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .withValues(alpha: 0.7),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.error_outline_rounded,
                                                            color:
                                                                Theme.of(
                                                                  context,
                                                                ).colorScheme.error,
                                                            size: renderH * 0.25,
                                                          ),
                                                          const SizedBox(height: 12),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 16,
                                                                ),
                                                            child: Text(
                                                              playerState.loadError!,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color:
                                                                    Theme.of(context)
                                                                        .colorScheme
                                                                        .onSurface,
                                                                fontSize:
                                                                    renderH * 0.08 < 12
                                                                        ? 12
                                                                        : renderH * 0.08,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          TactileTap(
                                                            onTap:
                                                                () =>
                                                                    ref
                                                                        .read(
                                                                          playerProvider
                                                                              .notifier,
                                                                        )
                                                                        .retryLoad(),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal: 24,
                                                                    vertical: 10,
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
                                                                        )
                                                                        .colorScheme
                                                                        .primary
                                                                        .withValues(
                                                                          alpha: 0.3,
                                                                        ),
                                                                    blurRadius: 10,
                                                                    offset: const Offset(
                                                                      0,
                                                                      4,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize.min,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.refresh_rounded,
                                                                    color: Colors.white,
                                                                    size: 20,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  const Text(
                                                                    'Retry',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                      fontSize: 14,
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
                                          ],
                                        ),
                                      ),
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
              isPlayerScreen
                  ? null
                  : isDesktop
                      ? const _DesktopPlayerBar()
                      : const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [_MiniPlayerBar(), _BottomNavBar()],
                        ),
        );
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
      String s when s.startsWith('/search') => 1,
      String s when s.startsWith('/library') => 2,
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
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavBarItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: 'Search',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/search'),
              ),
              _NavBarItem(
                icon: Icons.library_music_outlined,
                activeIcon: Icons.library_music,
                label: 'Library',
                isSelected: currentIndex == 2,
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
                        child: CachedNetworkImage(
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
                            HoverText(
                              text: track.artistName,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 11,
                              ),
                              onTap: () => context.push('/artist/${track.artistId}'),
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
                      ),
                      TactileIconButton(
                        icon:
                            playerState.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                        onTap:
                            () =>
                                ref.read(playerProvider.notifier).togglePlay(),
                        size: 28,
                      ),
                      TactileIconButton(
                        icon: Icons.skip_next,
                        onTap:
                            () => ref.read(playerProvider.notifier).skipNext(),
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      TactileIconButton(
                        icon: showVideo ? Icons.videocam : Icons.videocam_off,
                        onTap:
                            () =>
                                ref
                                    .read(settingsProvider.notifier)
                                    .toggleVideo(),
                        size: 18,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
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
      String s when s.startsWith('/search') => 1,
      String s when s.startsWith('/library') => 2,
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
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                   .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2000.ms, curve: Curves.easeInOut),
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
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/home'),
                ),
                _SidebarItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: 'Search',
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/search'),
                ),
                _SidebarItem(
                  icon: Icons.library_music_outlined,
                  activeIcon: Icons.library_music,
                  label: 'Library',
                  isSelected: currentIndex == 2 && GoRouterState.of(context).uri.queryParameters['filter'] != 'playlists',
                  onTap: () => context.go('/library'),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  label: 'Favorites',
                  isSelected: location.startsWith('/liked-songs'),
                  onTap: () => context.push('/liked-songs'),
                ),
                _SidebarItem(
                  icon: Icons.history,
                  activeIcon: Icons.history,
                  label: 'Recently Played',
                  isSelected: location.startsWith('/recently-played'),
                  onTap: () => context.push('/recently-played'),
                ),
                _SidebarItem(
                  icon: Icons.queue_music,
                  activeIcon: Icons.queue_music,
                  label: 'Playlists',
                  isSelected: location.startsWith('/library') && GoRouterState.of(context).uri.queryParameters['filter'] == 'playlists',
                  onTap: () => context.go('/library?filter=playlists'),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                      InkWell(
                        onTap: () {
                          final nameController = TextEditingController();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('New Playlist'),
                              content: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(hintText: 'Playlist Name'),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (nameController.text.isNotEmpty) {
                                      await database.createPlaylist(nameController.text);
                                      if (context.mounted) Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Create'),
                                ),
                              ],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.add, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                      children: playlists.map((p) {
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
                            subtitle: 'Playlist',
                            imageUrl: p.imageUrl ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(p.name)}&background=random',
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

class _SidebarItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      const Color(0xFF8B0000), // Darker red gradient for active item
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(isSelected ? activeIcon : icon, color: color, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockPlaylistItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap ?? () => context.go('/library'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.music_note, size: 16, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
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
    );
  }
}

class _DesktopPlayerBar extends ConsumerWidget {
  const _DesktopPlayerBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final track = playerState.currentTrack;
    final showVideo = ref.watch(settingsProvider.select((s) => s.showVideo));
    final colorScheme = Theme.of(context).colorScheme;

    if (track == null) return const SizedBox.shrink();

    final progress = playerState.duration.inSeconds > 0
        ? playerState.position.inSeconds / playerState.duration.inSeconds
        : 0.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.4),
            border: Border(
              top: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
        children: [
          // Progress bar
          Container(
            height: 2,
            width: double.infinity,
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(color: colorScheme.primary),
            ),
          ),
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
                            child: CachedNetworkImage(
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
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                ArtistsLinks(
                                  track: track,
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
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
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TactileIconButton(
                          icon: Icons.shuffle,
                          onTap: () => ref.read(playerProvider.notifier).toggleShuffle(),
                          size: 20,
                          color: playerState.isShuffled ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 16),
                        TactileIconButton(
                          icon: Icons.skip_previous,
                          onTap: () => ref.read(playerProvider.notifier).skipPrevious(),
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        TactileIconButton(
                          icon: playerState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          onTap: () => ref.read(playerProvider.notifier).togglePlay(),
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        TactileIconButton(
                          icon: Icons.skip_next,
                          onTap: () => ref.read(playerProvider.notifier).skipNext(),
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        TactileIconButton(
                          icon: Icons.repeat,
                          onTap: () => ref.read(playerProvider.notifier).cycleRepeat(),
                          size: 20,
                          color: playerState.repeatMode != RepeatMode.none ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right: Extra controls
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Volume control
                        Icon(
                          playerState.volume == 0 ? Icons.volume_off : (playerState.volume < 0.5 ? Icons.volume_down : Icons.volume_up),
                          size: 20,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        SizedBox(
                          width: 80,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                              activeTrackColor: colorScheme.primary,
                              inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.2),
                              thumbColor: colorScheme.primary,
                              overlayColor: colorScheme.primary.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: playerState.volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (val) => ref.read(playerProvider.notifier).setVolume(val),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TactileIconButton(
                          icon: showVideo ? Icons.videocam : Icons.videocam_off,
                          onTap: () => ref.read(settingsProvider.notifier).toggleVideo(),
                          size: 20,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 16),
                        TactileIconButton(
                          icon: Icons.queue_music,
                          onTap: () => context.push('/player'), // Desktop could eventually have a slide-out queue instead
                          size: 20,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
    ref.listen(searchQueryProvider, (prev, next) {
      if (_ctrl.text != next) {
        _ctrl.text = next;
        _ctrl.selection = TextSelection.fromPosition(TextPosition(offset: next.length));
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
                      Icon(Icons.search, color: colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          onTap: () {
                            if (GoRouterState.of(context).uri.path != '/search') {
                              context.go('/search');
                            }
                          },
                          onChanged: (val) {
                            ref.read(searchQueryProvider.notifier).state = val;
                          },
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              ref.read(recentSearchesProvider.notifier).addSearch(val);
                            }
                          },
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search music, artists, albums...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
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
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Primary Brand Blob
    paint.color = primaryColor.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 120, paint);

    // Dynamic Secondary Blob (derived from theme)
    final secondaryColor = Color.lerp(primaryColor, primaryColor.withValues(alpha: 0.8), 0.2) ?? primaryColor;
    paint.color = secondaryColor.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 90, paint);
    
    // Dynamic Tertiary Blob (derived from theme)
    final tertiaryColor = Color.lerp(primaryColor, primaryColor.withValues(alpha: 0.6), 0.2) ?? primaryColor;
    paint.color = tertiaryColor.withValues(alpha: 0.08);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 100, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) => oldDelegate.primaryColor != primaryColor;
}
