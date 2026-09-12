import 'dart:ui';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';

/// Provider for recently played tracks from the database (Stream for real-time updates)
final recentlyPlayedTracksProvider = StreamProvider<List<model.Track>>((ref) {
  final database = ref.watch(db.appDatabaseProvider);
  return database
      .watchRecentlyPlayed(limit: 50)
      .map((tracks) => tracks.map(model.Track.fromDb).toList());
});

class RecentlyPlayedScreen extends ConsumerWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tracksAsync = ref.watch(recentlyPlayedTracksProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
            elevation: 0,
            actions: [
              tracksAsync.when(
                data:
                    (tracks) =>
                        tracks.isEmpty
                            ? const SizedBox.shrink()
                            : TactileIconButton(
                              icon: Icons.delete_sweep_rounded,
                              onTap:
                                  () => _showClearHistoryConfirm(context, ref),
                              color: colorScheme.onSurfaceVariant,
                            ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
            ],
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
              color: colorScheme.onSurface,
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Recently Played',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
              background: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.onSurface.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          tracksAsync.when(
            data: (tracks) {
              if (tracks.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                              Icons.history_rounded,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                              size: 80,
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              duration: 2.seconds,
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.1, 1.1),
                            ),
                        const SizedBox(height: 24),
                        Text(
                          'Your listening history is empty.',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TactileTap(
                          onTap: () => context.go('/home'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'Go Home',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = tracks[index];
                    // Use unique key for the animation list to handle real-time movements
                    return Padding(
                          key: ValueKey(track.spotifyId),
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final currentTrackId = ref.watch(
                                playerProvider.select(
                                  (s) => s.currentTrack?.spotifyId,
                                ),
                              );
                              final isActive =
                                  currentTrackId == track.spotifyId;
                              return TrackTile(
                                track: track,
                                isActive: isActive,
                                onTap:
                                    () => ref
                                        .read(playerProvider.notifier)
                                        .playTrack(track, queue: tracks),
                              );
                            },
                          ),
                        )
                        .animate()
                        .fadeIn(delay: (index * 40).ms)
                        .slideX(begin: 0.05, curve: Curves.easeOutCubic);
                  }, childCount: tracks.length),
                ),
              );
            },
            loading:
                () => SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
            error:
                (e, _) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error: $e',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }

  void _showClearHistoryConfirm(BuildContext context, WidgetRef ref) {
    showPremiumModal(
      context: context,
      title: AppLocalizations.of(context)!.clearHistory,
      child: Builder(
        builder: (dialogContext) {
          final colorScheme = Theme.of(dialogContext).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This will permanently remove your listening history. This action cannot be undone.',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TactileTap(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TactileTap(
                      onTap: () async {
                        await ref.read(db.appDatabaseProvider).clearHistory();
                        if (context.mounted) {
                          Navigator.pop(dialogContext);
                        }
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
