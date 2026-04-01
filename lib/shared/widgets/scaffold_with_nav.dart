import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import '../../core/player/player_provider.dart';
import '../../core/player/youtube_player_service.dart';
import '../../core/player/video_layout_provider.dart';
import '../../core/services/settings_provider.dart';
import '../../shared/widgets/tactile_buttons.dart';


class ScaffoldWithNav extends ConsumerStatefulWidget {
  const ScaffoldWithNav({super.key, required this.child, required this.location});
  final Widget child;
  final String location;

  @override
  ConsumerState<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends ConsumerState<ScaffoldWithNav> {
  final GlobalKey _stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final playerService = ref.watch(youtubePlayerServiceProvider);
    final settings = ref.watch(settingsProvider);
    final showVideo = settings.showVideo;
    final playerView = settings.playerView;
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
    const double kPeek  = 2.0; // px kept inside window to avoid JS suspension

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stackHeight = constraints.maxHeight;

                  double renderW, renderH, renderTop, renderLeft, renderRadius;
                  bool showShadow;

                  if (isPlayerScreen) {
                    if (playerView == PlayerView.video && videoLayout.isReady) {
                      // Snap WebView into the video slot reported by PlayerScreen
                      // Use viewPadding as a fallback if the stack isn't laid out yet
                      final topPadding = MediaQuery.viewPaddingOf(context).top;
                      renderW = videoLayout.size.width;
                      renderH = videoLayout.size.height;
                      renderTop = videoLayout.position.dy - topPadding;
                      renderLeft = videoLayout.position.dx;
                      renderRadius = 12;
                      showShadow = false;
                    } else {
                      // ARTWORK / QUEUE tabs — keep 2×2 peek so JS stays alive
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
                      renderLeft = screenWidth - kMinW - 16;
                      // Sit above the mini-player bar (64) + system bottom padding
                      renderRadius = 8;
                      showShadow = true;
                      renderTop = stackHeight - kMinH - 8;
                    } else {
                      // showVideo=false — keep 2×2 peek so JS stays alive
                      renderW = kMinW;
                      renderH = kMinH;
                      renderTop = stackHeight - kPeek;
                      renderLeft = screenWidth - kPeek;
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
                      Builder(builder: (context) {
                        double finalTop = renderTop;
                        double finalLeft = renderLeft;

                        if (isPlayerScreen && playerView == PlayerView.video && videoLayout.isReady) {
                          final RenderBox? stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
                          if (stackBox != null) {
                            // Use globalToLocal for precise alignment relative to THIS stack.
                            // This handles status bars, safely consumed paddings, and any parent offsets.
                            final localPos = stackBox.globalToLocal(videoLayout.position);
                            finalTop = localPos.dy;
                            finalLeft = localPos.dx;
                          }
                        }

                        return AnimatedPositioned(
                          duration: const Duration(milliseconds: 80),
                          curve: Curves.easeOutCubic,
                          top: finalTop,
                          left: finalLeft,
                          width: renderW,
                          height: renderH,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 80),
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(renderRadius),
                              boxShadow: [
                                if (showShadow)
                                  const BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: RepaintBoundary(
                              child: (playerService.isMobile)
                                  ? mobile.YoutubePlayer(
                                      controller: playerService.mobileController!,
                                    )
                                  : WebViewWidget(controller: playerService.desktopController!),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isPlayerScreen 
        ? null 
        : const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MiniPlayerBar(),
              _BottomNavBar(),
            ],
          ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = switch (location) {
      String s when s.startsWith('/home') => 0,
      String s when s.startsWith('/search') => 1,
      String s when s.startsWith('/library') => 2,
      _ => 0,
    };

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.only(
            top: 8,
            bottom: MediaQuery.paddingOf(context).bottom + 4,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
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
    final color = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5);
    
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.85, // More pronounced tactile feedback for nav items
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 26,
            ),
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

    if (track == null) return const SizedBox.shrink();

    final progress = playerState.duration.inSeconds > 0
        ? playerState.position.inSeconds / playerState.duration.inSeconds
        : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: TactileTap(
            onTap: () => context.push('/player'),
            scaleDown: 0.98,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
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
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.3),
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
                            Text(
                              track.artistName,
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      TactileIconButton(
                        icon: Icons.skip_previous,
                        onTap: () => ref.read(playerProvider.notifier).skipPrevious(),
                        size: 24,
                      ),
                      TactileIconButton(
                        icon: playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                        onTap: () =>
                            ref.read(playerProvider.notifier).togglePlay(),
                        size: 28,
                      ),
                      TactileIconButton(
                        icon: Icons.skip_next,
                        onTap: () => ref.read(playerProvider.notifier).skipNext(),
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      TactileIconButton(
                        icon: showVideo ? Icons.videocam : Icons.videocam_off,
                        onTap: () => ref.read(settingsProvider.notifier).toggleVideo(),
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
