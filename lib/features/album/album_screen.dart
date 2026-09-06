import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/favorites_provider.dart';
import '../../shared/widgets/adaptive_blur.dart';

final _albumProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getAlbum(id);
});

class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({super.key, required this.albumId});
  final String albumId;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albumAsync = ref.watch(_albumProvider(widget.albumId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: albumAsync.when(
        loading: () => const AlbumDetailsShimmer(),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)))),
        data: (album) {
          final colorScheme = Theme.of(context).colorScheme;
          final images = (album['images'] as List?) ?? [];
          final imageUrl =
              images.isNotEmpty ? images[0]['url'] as String : null;
          final rawTracks = (album['tracks']?['items'] as List?) ?? [];
          final tracks = rawTracks.map((j) {
            final map = Map<String, dynamic>.from(j as Map<String, dynamic>);
            map['album'] = {
              'id': album['id'],
              'name': album['name'],
              'images': images,
            };
            return Track.fromSpotify(map);
          }).toList();

          final artistName =
              (album['artists'] as List).firstOrNull?['name'] ?? '';
          final artistId = (album['artists'] as List).firstOrNull?['id'];
          final albumName = album['name'] as String;
          var filteredTracks = tracks;
          if (_searchQuery.isNotEmpty) {
            filteredTracks = tracks.where((t) {
              return t.name.toLowerCase().contains(_searchQuery) ||
                  t.artistName.toLowerCase().contains(_searchQuery);
            }).toList();
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: _isSearching ? kToolbarHeight + MediaQuery.of(context).padding.top : 420,
                pinned: true,
                stretch: true,
                backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isSearching
                      ? TactileIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                            setState(() {
                              _isSearching = false;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                      : TactileIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          onTap: () => context.pop(),
                        ),
                ),
                title: _isSearching
                    ? AdaptiveBlur(
                        sigmaX: 10,
                        sigmaY: 10,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.onSurface.withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search in album...',
                              prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurface.withValues(alpha: 0.3), size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.3),
                                fontSize: 14,
                              ),
                            ),
                            style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95))
                    : null,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !_isSearching
                        ? TactileIconButton(
                            icon: Icons.search_rounded,
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                          )
                        : _searchQuery.isNotEmpty
                            ? TactileIconButton(
                                icon: Icons.clear_rounded,
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : const SizedBox(width: 40),
                  ),
                  const SizedBox(width: 4),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final topPadding = MediaQuery.of(context).padding.top;
                    final isCollapsed = constraints.maxHeight <= kToolbarHeight + topPadding + 10;
                    
                    return FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      centerTitle: true,
                      expandedTitleScale: 1.0,
                      titlePadding: EdgeInsets.zero,
                      title: isCollapsed && !_isSearching
                          ? AdaptiveBlur(
                              sigmaX: 20,
                              sigmaY: 20,
                              child: Container(
                                width: double.infinity,
                                height: kToolbarHeight + topPadding,
                                padding: EdgeInsets.only(top: topPadding),
                                color: colorScheme.surface.withValues(alpha: 0.6),
                                alignment: Alignment.center,
                                child: Text(
                                  albumName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                    letterSpacing: -0.5,
                                    color: colorScheme.onSurface,
                                  ),
                                ).animate().fadeIn(duration: 200.ms),
                              ),
                            )
                          : null,
                      background: _isSearching ? null : Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imageUrl != null)
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) =>
                                  Container(color: colorScheme.surfaceContainerHighest),
                            )
                          else
                            Container(color: colorScheme.surfaceContainer),
                          
                          // Cinematic Ambient Overlays
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.8, -0.6),
                                    radius: 1.5,
                                    colors: [
                                      colorScheme.primary,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.3, 1.3),
                                duration: 10.seconds,
                                curve: Curves.easeInOut,
                              ).move(
                                begin: const Offset(-20, -20),
                                end: const Offset(20, 20),
                                duration: 12.seconds,
                                curve: Curves.easeInOut,
                              ),
                            ),
                          ),
                          
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colorScheme.surface.withValues(alpha: 0.1),
                                    Colors.transparent,
                                    colorScheme.surface.withValues(alpha: 0.4),
                                    colorScheme.surface.withValues(alpha: 0.9),
                                  ],
                                  stops: const [0.0, 0.4, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                          
                          // Expanded Hero Title
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 48,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isCollapsed ? 0.0 : 1.0,
                              child: Center(
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(alpha: 0.15),
                                        blurRadius: 40,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: AdaptiveBlur(
                                    sigmaX: 16,
                                    sigmaY: 16,
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: colorScheme.onSurface.withValues(alpha: 0.15),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ALBUM',
                                            style: TextStyle(
                                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 4.0,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            albumName,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -2.5,
                                              height: 1.0,
                                              shadows: [
                                                Shadow(
                                                  color: colorScheme.shadow.withValues(alpha: 0.45),
                                                  blurRadius: 30,
                                                  offset: Offset(0, 15),
                                                ),
                                              ],
                                            ),
                                          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TactileTap(
                        onTap: () {
                          if (artistId != null) {
                            context.push('/artist/$artistId');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                child: Icon(Icons.person, size: 12, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                artistName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Album • ${album['release_date']?.toString().substring(0, 4) ?? ''}',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final statusAsync = ref.watch(favoritesStatusProvider((FavoriteType.album, widget.albumId)));
                          final isLiked = statusAsync.value ?? false;
                          
                          return TactileIconButton(
                            icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isLiked ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
                            padding: const EdgeInsets.all(12),
                            onTap: () {
                              ref.read(favoritesControllerProvider.notifier).toggleAlbumLike(
                                widget.albumId,
                                albumName,
                                artistId ?? '',
                                artistName,
                                imageUrl,
                                isLiked,
                              );
                            },
                          );
                        },
                      ),
                          const Spacer(),
                          TactileIconButton(
                            icon: Icons.shuffle_rounded,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 26,
                            padding: const EdgeInsets.all(12),
                            onTap: tracks.isNotEmpty
                                ? () => ref.read(playerProvider.notifier).shuffleAndPlay(tracks)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          TactileActionPlayButton(
                            size: 68,
                            onTap: tracks.isNotEmpty
                                ? () => ref.read(playerProvider.notifier).playTrack(tracks[0], queue: tracks)
                                : null,
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              if (filteredTracks.isEmpty && _searchQuery.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found matching "$_searchQuery"',
                          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final track = filteredTracks[i];
                      return AdaptiveBlur(
                        sigmaX: 10,
                        sigmaY: 10,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.onSurface.withValues(alpha: 0.05),
                              width: 0.5,
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
                          child: Consumer(
                            builder: (context, ref, child) {
                              final currentTrackId = ref.watch(playerProvider.select((s) => s.currentTrack?.spotifyId));
                              final isActive = currentTrackId == track.spotifyId;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      child: isActive
                                          ? Icon(Icons.equalizer_rounded, size: 16, color: colorScheme.primary)
                                          : Text(
                                              '${i + 1}',
                                              style: TextStyle(
                                                color: colorScheme.onSurface.withValues(alpha: 0.2),
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                    ),
                                    Expanded(
                                      child: TrackTile(
                                        track: track,
                                        isActive: isActive,
                                        showImage: false,
                                        onTap: () => ref
                                            .read(playerProvider.notifier)
                                            .playTrack(track, queue: filteredTracks),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                          .animate(delay: (300 + 40 * i).ms)
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack);
                    },
                    childCount: filteredTracks.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${album['release_date']} • ${tracks.length} songs',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (album['copyrights'] != null)
                        ... (album['copyrights'] as List).map((c) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            c['text'] as String,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.15),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

