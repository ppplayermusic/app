import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/player/player_provider.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/pp_image.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';
import 'providers/discover_providers.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final discoverState = ref.watch(discoverContentProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => ref.read(discoverContentProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 56.0, right: 32.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'New music curated for you.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            discoverState.when(
              data: (content) {
                if (content.sections.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Nothing to discover right now.', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final section = content.sections[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (section.subtitle != null) ...[
                                    Text(
                                      section.subtitle!.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Text(
                                    section.title,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (section.tracks.isNotEmpty)
                              SizedBox(
                                height: 230,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: section.tracks.length,
                                  padding: const EdgeInsets.only(left: 16),
                                  itemBuilder: (context, i) {
                                    final track = section.tracks[i];
                                    return _DiscoverTrackCard(
                                      track: track,
                                      onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: section.tracks),
                                    ).animate().fadeIn(delay: (i * 50).ms).slideX(begin: 0.05);
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: content.sections.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SectionShimmer(height: 230, childAspectRatio: 1, isGrid: false, count: 4),
                      SizedBox(height: 32),
                      SectionShimmer(height: 230, childAspectRatio: 1, isGrid: false, count: 4),
                    ],
                  ),
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Failed to load recommendations', style: TextStyle(color: colorScheme.onSurface)),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => ref.read(discoverContentProvider.notifier).refresh(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTrackCard extends StatelessWidget {
  const _DiscoverTrackCard({required this.track, required this.onTap});
  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ContentContextMenuRegion(
      target: TrackContextTarget(track),
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: TactileTap(
          onTap: onTap,
          scaleDown: 0.95,
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: track.albumImage != null
                        ? PPImage(imageUrl: track.albumImage!, width: 150, height: 150, fit: BoxFit.cover)
                        : Container(color: colorScheme.surfaceContainerHighest, child: Icon(Icons.music_note, color: colorScheme.onSurfaceVariant)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  track.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  track.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
