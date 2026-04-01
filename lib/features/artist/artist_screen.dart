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
                expandedHeight: 340,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: TactileIconButton(
                  icon: Icons.arrow_back_ios_new,
                  size: 20,
                  onTap: () => context.pop(),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TactileIconButton(
                      icon: _isSearching ? Icons.close : Icons.search,
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
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  titlePadding: EdgeInsets.zero,
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCollapsed =
                          constraints.maxHeight <= kToolbarHeight + 44;
                      return Stack(
                        children: [
                          if (isCollapsed)
                            Positioned.fill(
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            height: kToolbarHeight + 44,
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _isSearching && isCollapsed
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 48),
                                    child: TextField(
                                      controller: _searchController,
                                      autofocus: true,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                      cursorColor: const Color(0xFF1DB954),
                                      decoration: InputDecoration(
                                        hintText: 'Search songs...',
                                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value.toLowerCase();
                                        });
                                      },
                                    ),
                                  )
                                : AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: 1.0,
                                    child: Text(
                                      artistName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isCollapsed ? 18 : 36,
                                        letterSpacing: -1.0,
                                        shadows: [
                                          if (!isCollapsed)
                                            const Shadow(
                                                color: Colors.black,
                                                blurRadius: 20,
                                                offset: Offset(0, 4)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
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
                      // Modern Premium Gradient Overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0x33000000),
                              Color(0x99000000),
                              Colors.black,
                            ],
                            stops: [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          '${(artist['followers']?['total'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} followers',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4), 
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white30, width: 0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Follow', 
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      )
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TactileIconButton(
                                  icon: Icons.more_vert,
                                  color: Colors.white70,
                                  padding: const EdgeInsets.all(10),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TactileActionPlayButton(
                              size: 64,
                              onTap: () {
                                final tracks = tracksAsync.asData?.value;
                                if (tracks != null && tracks.isNotEmpty) {
                                  final modelTracks = tracks
                                      .map((j) => Track.fromSpotify(
                                          j as Map<String, dynamic>))
                                      .toList();
                                  ref
                                      .read(playerProvider.notifier)
                                      .playTrack(modelTracks.first,
                                          queue: modelTracks);
                                }
                              },
                            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                      if (_isSearching)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: const Color(0xFF1DB954),
                              decoration: InputDecoration(
                                hintText: 'Search popular songs...',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                border: InputBorder.none,
                                icon: const Icon(Icons.search, color: Colors.white54, size: 20),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                              },
                            ),
                          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                        ),
                      _buildSectionHeader('Popular'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              tracksAsync.when(
                loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
                    )),
                error: (e, _) =>
                    SliverToBoxAdapter(child: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white54)))),
                data: (items) {
                  var tracks = items
                      .map((j) => Track.fromSpotify(
                          j as Map<String, dynamic>))
                      .toList();
                  
                  if (_searchQuery.isNotEmpty) {
                    tracks = tracks.where((t) => t.name.toLowerCase().contains(_searchQuery)).toList();
                  }

                  if (tracks.isEmpty && _searchQuery.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off, size: 48, color: Colors.white24),
                            const SizedBox(height: 16),
                            Text(
                              'No tracks found for "$_searchQuery"',
                              style: const TextStyle(color: Colors.white54, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final track = tracks[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TrackTile(
                                    track: track,
                                    onTap: () => ref
                                        .read(playerProvider.notifier)
                                        .playTrack(track, queue: tracks),
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: (i * 50).ms).fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
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
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: _buildSectionHeader('Albums'),
                  ),
                ),
                albumsAsync.when(
                  loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)))),
                  error: (e, _) =>
                      SliverToBoxAdapter(child: Text('Error: $e')),
                  data: (items) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final album = items[i] as Map<String, dynamic>;
                          final imgs = (album['images'] as List?) ?? [];
                          final imageUrl =
                              imgs.isNotEmpty ? imgs[0]['url'] as String : '';

                          return TactileTap(
                            onTap: () => context.push("/album/${album['id']}"),
                            scaleDown: 0.98,
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      height: 160,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => Container(
                                          color: const Color(0xFF1A1A1A)),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    album['name'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    album['release_date']
                                            ?.toString()
                                            .substring(0, 4) ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.4),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: (i * 100).ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
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
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );
  }
}

