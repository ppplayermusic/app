import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

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
      backgroundColor: Colors.black,
      body: albumAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white54))),
        data: (album) {
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
                expandedHeight: _isSearching ? kToolbarHeight : 380,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: _isSearching
                    ? TactileIconButton(
                        icon: Icons.arrow_back,
                        onTap: () {
                          setState(() {
                            _isSearching = false;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : TactileIconButton(
                        icon: Icons.arrow_back_ios_new,
                        size: 20,
                        onTap: () => context.pop(),
                      ),
                title: _isSearching
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search in album...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      )
                    : null,
                actions: [
                  if (!_isSearching)
                    TactileIconButton(
                      icon: Icons.search,
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    )
                  else if (_searchQuery.isNotEmpty)
                    TactileIconButton(
                      icon: Icons.clear,
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: _isSearching
                    ? ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isCollapsed =
                              constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top + 10;
                          return ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: isCollapsed ? 15 : 0,
                                sigmaY: isCollapsed ? 15 : 0,
                              ),
                              child: Container(
                                color: isCollapsed
                                    ? Colors.black.withValues(alpha: 0.7)
                                    : Colors.transparent,
                                child: FlexibleSpaceBar(
                                  stretchModes: const [
                                    StretchMode.zoomBackground,
                                    StretchMode.blurBackground,
                                  ],
                                  titlePadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  title: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: 1.0,
                                    child: Text(
                                      albumName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isCollapsed ? 18 : 32,
                                        letterSpacing: -0.8,
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
                                  background: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      if (imageUrl != null)
                                        CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Container(color: const Color(0xFF121212)),
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
                            ),
                          );
                        },
                      ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TactileTap(
                        onTap: () {
                          if (artistId != null) {
                            context.push('/artist/$artistId');
                          }
                        },
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white10,
                              child: Icon(Icons.person,
                                  size: 16, color: Colors.white70),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              artistName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white30),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Album • ${album['release_date']?.toString().substring(0, 4) ?? ''}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          TactileIconButton(
                            icon: Icons.favorite_border,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.download_for_offline_outlined,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.more_vert,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
                            onTap: () {},
                          ),
                          const Spacer(),
                          TactileIconButton(
                            icon: Icons.shuffle,
                            color: Colors.white70,
                            size: 28,
                            padding: const EdgeInsets.all(10),
                            onTap: tracks.isNotEmpty
                                ? () {
                                    final shuffled = [...tracks]..shuffle();
                                    ref
                                        .read(playerProvider.notifier)
                                        .playTrack(shuffled[0],
                                            queue: shuffled);
                                  }
                                : null,
                          ),
                          const SizedBox(width: 12),
                          TactileActionPlayButton(
                            size: 64,
                            onTap: tracks.isNotEmpty
                                ? () => ref
                                    .read(playerProvider.notifier)
                                    .playTrack(tracks[0], queue: tracks)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (filteredTracks.isEmpty && _searchQuery.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No tracks found matching "$_searchQuery"',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final track = filteredTracks[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
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
                                showImage: false,
                                onTap: () => ref
                                    .read(playerProvider.notifier)
                                    .playTrack(track, queue: filteredTracks),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate(delay: (20 * i).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.1, end: 0);
                    },
                    childCount: filteredTracks.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${album['release_date']} • ${tracks.length} songs',
                        style:
                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      if (album['copyrights'] != null)
                        ... (album['copyrights'] as List).map((c) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            c['text'] as String,
                            style: const TextStyle(color: Colors.white30, fontSize: 11),
                          ),
                        )),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}

