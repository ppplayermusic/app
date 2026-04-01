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

final _relatedArtistsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getRelatedArtists(id);
});

final _artistPlaylistsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, name) {
  if (name.isEmpty) return Future.value([]);
  return ref.read(spotifyClientProvider).searchPlaylists('Featuring $name', limit: 12);
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
    final relatedAsync = ref.watch(_relatedArtistsProvider(widget.artistId));
    final playlistsAsync = ref.watch(_artistPlaylistsProvider(artistAsync.asData?.value['name'] ?? ''));

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
                backgroundColor: Colors.black.withValues(alpha: 0.1),
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
                      expandedTitleScale: 1.0,
                      titlePadding: EdgeInsets.zero,
                      title: isCollapsed
                          ? ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  width: double.infinity,
                                  height: kToolbarHeight + topPadding,
                                  padding: EdgeInsets.only(top: topPadding),
                                  color: Colors.black.withValues(alpha: 0.6),
                                  alignment: Alignment.center,
                                  child: Text(
                                    artistName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                      letterSpacing: -0.5,
                                      color: Colors.white,
                                    ),
                                  ).animate().fadeIn(duration: 200.ms),
                                ),
                              ),
                            )
                          : null,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (headerImage != null)
                            CachedNetworkImage(
                              imageUrl: headerImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: const Color(0xFF121212)),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFF1E1E1E),
                                child: const Icon(Icons.person, size: 80, color: Colors.white10),
                              ),
                            )
                          else
                            Container(color: const Color(0xFF121212)),

                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.1),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 32,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isCollapsed ? 0.0 : 1.0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        artistName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -2.5,
                                          height: 1.0,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 30,
                                              offset: Offset(0, 15),
                                            ),
                                          ],
                                        ),
                                      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
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
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isSearching) ...[
                        Text(
                          '${(artist['followers']?['total'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} FOLLOWERS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4), 
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ).animate().fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  TactileTap(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.0),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        'FOLLOW', 
                                        style: TextStyle(
                                          color: Colors.white, 
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11,
                                          letterSpacing: 1.5,
                                        )
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  TactileTap(
                                    onTap: () {
                                      final artistData = artistAsync.asData?.value;
                                      if (artistData != null) {
                                        final artistName = artistData['name'] ?? 'Artist';
                                        final imgs = (artistData['images'] as List?) ?? [];
                                        final artistImageUrl = imgs.isNotEmpty ? imgs[0]['url'] as String : '';
                                        
                                        context.push(
                                          '/radio/artist/${widget.artistId}?title=$artistName Radio&imageUrl=$artistImageUrl',
                                          extra: {
                                            'color1': const Color(0xFF1DB954),
                                            'color2': Colors.black,
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                                        border: Border.all(color: const Color(0xFF1DB954).withValues(alpha: 0.4), width: 1.0),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.radio_rounded, color: Color(0xFF1DB954), size: 18),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'RADIO', 
                                            style: TextStyle(
                                              color: Color(0xFF1DB954), 
                                              fontWeight: FontWeight.w900,
                                              fontSize: 11,
                                              letterSpacing: 1.5,
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
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
                relatedAsync.when(
                  loading: () => const SliverToBoxAdapter(child: SizedBox()),
                  error: (e, _) => const SliverToBoxAdapter(child: SizedBox()),
                  data: (artists) {
                    if (artists.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
                            child: _buildSectionHeader('FANS ALSO LIKE'),
                          ),
                          SizedBox(
                            height: 190,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: artists.length,
                              itemBuilder: (context, i) {
                                final rArtist = artists[i];
                                final rImgs = (rArtist['images'] as List?) ?? [];
                                final rImgUrl = rImgs.isNotEmpty ? rImgs[0]['url'] as String : '';

                                return TactileTap(
                                  onTap: () => context.push("/artist/${rArtist['id']}"),
                                  scaleDown: 0.92,
                                  child: Container(
                                    width: 140,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                blurRadius: 30,
                                                spreadRadius: -10,
                                                offset: const Offset(0, 15),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: rImgUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.white.withValues(alpha: 0.05),
                                                child: const Icon(Icons.person, color: Colors.white10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          rArtist['name'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate(delay: (i * 80).ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                playlistsAsync.when(
                  loading: () => const SliverToBoxAdapter(child: SizedBox()),
                  error: (e, _) => const SliverToBoxAdapter(child: SizedBox()),
                  data: (playlists) {
                    if (playlists.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
                            child: _buildSectionHeader('FEATURING ${artistName.toUpperCase()}'),
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: playlists.length,
                              itemBuilder: (context, i) {
                                final playlist = playlists[i];
                                final pImgs = (playlist['images'] as List?) ?? [];
                                final pImgUrl = pImgs.isNotEmpty ? pImgs[0]['url'] as String : '';

                                return TactileTap(
                                  onTap: () {
                                    final id = playlist['id'];
                                    final name = playlist['name'] as String;
                                    context.push('/spotify-playlist/$id?name=${Uri.encodeComponent(name)}');
                                  },
                                  scaleDown: 0.96,
                                  child: Container(
                                    width: 170,
                                    margin: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.4),
                                                blurRadius: 25,
                                                spreadRadius: -5,
                                                offset: const Offset(0, 15),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: pImgUrl,
                                                  width: 170,
                                                  height: 170,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    color: Colors.white.withValues(alpha: 0.05),
                                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white10)),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withValues(alpha: 0.6),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.playlist_play_rounded, color: Colors.white, size: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          playlist['name'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Spotify Playlist • ${playlist['tracks']?['total'] ?? 0} tracks',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white.withValues(alpha: 0.3),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate(delay: (i * 100).ms).fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

