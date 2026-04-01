import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

final _artistProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getArtist(id);
});

final _artistTopTracksProvider =
    FutureProvider.family<List<dynamic>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getArtistTopTracks(id);
});

final _artistAlbumsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getArtistAlbums(id);
});

class ArtistScreen extends ConsumerStatefulWidget {
  const ArtistScreen({super.key, required this.artistId});
  final String artistId;

  @override
  ConsumerState<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends ConsumerState<ArtistScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artistAsync = ref.watch(_artistProvider(widget.artistId));
    final tracksAsync = ref.watch(_artistTopTracksProvider(widget.artistId));
    final albumsAsync = ref.watch(_artistAlbumsProvider(widget.artistId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: artistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white54))),
        data: (artist) {
          final images = (artist['images'] as List?) ?? [];
          final headerImage =
              images.isNotEmpty ? images[0]['url'] as String : null;
          final artistName = artist['name'] as String;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TactileIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    onTap: () => context.pop(),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TactileIconButton(
                      icon: _isSearching ? Icons.close_rounded : Icons.search_rounded,
                      size: 24,
                      onTap: () {
                        setState(() {
                          if (_isSearching) {
                            _isSearching = false;
                            _searchQuery = '';
                            _searchController.clear();
                          } else {
                            _isSearching = true;
                          }
                        });
                      },
                    ),
                  ),
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
                      titlePadding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: isCollapsed ? 14 : 24,
                      ),
                      title: _isSearching && isCollapsed
                          ? Container(
                              height: 38,
                              margin: const EdgeInsets.symmetric(horizontal: 32),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Search popular songs...',
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            )
                          : AnimatedContainer(
                              duration: 200.ms,
                              child: Text(
                                artistName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: isCollapsed ? 18 : 36,
                                  letterSpacing: isCollapsed ? 0 : -2.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (headerImage != null)
                            CachedNetworkImage(
                              imageUrl: headerImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(color: const Color(0xFF121212)),
                            )
                          else
                            Container(color: const Color(0xFF121212)),
                          
                          // Cinematic Ambient Overlays
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.3),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                    Colors.black,
                                  ],
                                  stops: const [0.0, 0.4, 0.8, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Header Glassmorphic Panel when collapsed
                          if (isCollapsed)
                            Positioned.fill(
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.4),
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
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isSearching) ...[
                        Text(
                          '${(artist['followers']?['total'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} FOLLOWERS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3), 
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ).animate().fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TactileTap(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Text(
                                      'FOLLOW', 
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                      )
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TactileIconButton(
                                  icon: Icons.more_vert_rounded,
                                  color: Colors.white70,
                                  padding: const EdgeInsets.all(12),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TactileActionPlayButton(
                              size: 72,
                              onTap: () {
                                final tracks = tracksAsync.asData?.value;
                                if (tracks != null && tracks.isNotEmpty) {
                                  final modelTracks = tracks
                                      .map((j) => Track.fromSpotify(j as Map<String, dynamic>))
                                      .toList();
                                  ref.read(playerProvider.notifier).playTrack(modelTracks.first, queue: modelTracks);
                                }
                              },
                            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                          ],
                        ),
                        const SizedBox(height: 48),
                      ],
                      if (_isSearching)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                  cursorColor: const Color(0xFF1DB954),
                                  decoration: InputDecoration(
                                    hintText: 'Search popular songs...',
                                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                                    border: InputBorder.none,
                                    icon: const Icon(Icons.search_rounded, color: Colors.white30, size: 22),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value.toLowerCase();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                        ),
                      _buildSectionHeader('POPULAR'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              tracksAsync.when(
                loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954), strokeWidth: 2)),
                    )),
                error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white30)))),
                data: (items) {
                  var tracks = items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
                  
                  if (_searchQuery.isNotEmpty) {
                    tracks = tracks.where((t) => t.name.toLowerCase().contains(_searchQuery)).toList();
                  }

                  if (tracks.isEmpty && _searchQuery.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: Colors.white.withValues(alpha: 0.1)),
                            const SizedBox(height: 16),
                            Text(
                              'No tracks found for "$_searchQuery"',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final track = tracks[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.05),
                                      Colors.white.withValues(alpha: 0.01),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 28,
                                        child: Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TrackTile(
                                          track: track,
                                          onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ).animate(delay: (i * 40).ms).fadeIn(duration: 500.ms).slideX(begin: 0.05, end: 0);
                        },
                        childCount: tracks.length,
                      ),
                    ),
                  );
                },
              ),
              if (!_isSearching) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                    child: _buildSectionHeader('ALBUMS'),
                  ),
                ),
                albumsAsync.when(
                  loading: () => const SliverToBoxAdapter(child: SizedBox()),
                  error: (e, _) => const SliverToBoxAdapter(child: SizedBox()),
                  data: (items) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final album = items[i] as Map<String, dynamic>;
                          final imgs = (album['images'] as List?) ?? [];
                          final imageUrl = imgs.isNotEmpty ? imgs[0]['url'] as String : '';

                          return TactileTap(
                            onTap: () => context.push("/album/${album['id']}"),
                            scaleDown: 0.98,
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        height: 160,
                                        width: 160,
                                        fit: BoxFit.cover,
                                        placeholder: (_, _) => Container(color: const Color(0xFF1A1A1A)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    album['name'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    album['release_date']?.toString().substring(0, 4) ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.3),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: (i * 100).ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9));
                        },
                      ),
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 2.0,
      ),
    );
  }
}

