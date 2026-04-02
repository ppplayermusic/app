import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/section_wrapper.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../core/services/favorites_provider.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final artistAsync = ref.watch(_artistProvider(widget.artistId));
    final tracksAsync = ref.watch(_artistTopTracksProvider(widget.artistId));
    final albumsAsync = ref.watch(_artistAlbumsProvider(widget.artistId));
    final relatedAsync = ref.watch(_relatedArtistsProvider(widget.artistId));
    final playlistsAsync = ref.watch(_artistPlaylistsProvider(artistAsync.asData?.value['name'] ?? ''));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: artistAsync.when(
        loading: () => const ArtistDetailsShimmer(),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: colorScheme.onSurfaceVariant))),
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
                backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
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
                                  color: colorScheme.surface.withValues(alpha: 0.6),
                                  alignment: Alignment.center,
                                  child: Text(
                                    artistName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                      letterSpacing: -0.5,
                                      color: colorScheme.onSurface,
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
                              placeholder: (context, url) => Container(color: colorScheme.surfaceContainerHighest),
                              errorWidget: (context, url, error) => Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(Icons.person, size: 80, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                              ),
                            )
                          else
                            Container(color: colorScheme.surfaceContainerHighest),

                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.surface.withValues(alpha: 0.1),
                                  Colors.transparent,
                                  colorScheme.surface.withValues(alpha: 0.3),
                                  colorScheme.surface.withValues(alpha: 0.8),
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),

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
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                        blurRadius: 40,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
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
                                              'ARTIST',
                                              style: TextStyle(
                                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 4.0,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              artistName,
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
                                                    color: colorScheme.surface.withValues(alpha: 0.45),
                                                    blurRadius: 30,
                                                    offset: const Offset(0, 15),
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
                            color: colorScheme.onSurface.withValues(alpha: 0.4), 
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
                                  Consumer(
                                    builder: (context, ref, _) {
                                      final statusAsync = ref.watch(favoritesStatusProvider((FavoriteType.artist, widget.artistId)));
                                      final isFollowed = statusAsync.value ?? false;
                                      
                                      return TactileTap(
                                        onTap: () {
                                          final imgs = (artist['images'] as List?) ?? [];
                                          final artistImageUrl = imgs.isNotEmpty ? imgs[0]['url'] as String : '';
                                          ref.read(favoritesControllerProvider.notifier).toggleArtistFollow(
                                            widget.artistId,
                                            artistName,
                                            artistImageUrl,
                                            isFollowed,
                                          );
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: isFollowed 
                                                ? colorScheme.primary.withValues(alpha: 0.2)
                                                : colorScheme.onSurface.withValues(alpha: 0.05),
                                            border: Border.all(
                                              color: isFollowed 
                                                  ? colorScheme.primary.withValues(alpha: 0.4)
                                                  : colorScheme.onSurface.withValues(alpha: 0.1), 
                                              width: 1.0
                                            ),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            isFollowed ? 'FOLLOWING' : 'FOLLOW', 
                                            style: TextStyle(
                                              color: isFollowed ? colorScheme.primary : colorScheme.onSurface, 
                                              fontWeight: FontWeight.w900,
                                              fontSize: 11,
                                              letterSpacing: 1.5,
                                            )
                                          ),
                                        ),
                                      );
                                    }
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
                                            'color1': colorScheme.primary,
                                            'color2': colorScheme.surface,
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), width: 1.0),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.radio_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                                          const SizedBox(width: 10),
                                          Text(
                                            'RADIO', 
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary, 
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
                      ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<dynamic>(
                  title: 'POPULAR',
                  asyncValue: tracksAsync,
                  builder: (items) {
                    var tracks = items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
                    
                    if (_searchQuery.isNotEmpty) {
                      tracks = tracks.where((t) => t.name.toLowerCase().contains(_searchQuery)).toList();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSearching)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1), width: 0.5),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
                                    cursorColor: colorScheme.primary,
                                    decoration: InputDecoration(
                                      hintText: 'Search popular songs...',
                                      hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
                                      border: InputBorder.none,
                                      icon: Icon(Icons.search_rounded, color: colorScheme.onSurface.withValues(alpha: 0.3), size: 22),
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
                        if (tracks.isEmpty && _searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(64.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No tracks found for "$_searchQuery"',
                                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                for (int i = 0; i < tracks.length; i++) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurface.withValues(alpha: 0.03),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05), width: 0.5),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              colorScheme.onSurface.withValues(alpha: 0.05),
                                              colorScheme.onSurface.withValues(alpha: 0.01),
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
                                                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                                                    fontSize: 12,
                                                    fontFamily: 'monospace',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TrackTile(
                                                  track: tracks[i],
                                                  onTap: () => ref.read(playerProvider.notifier).playTrack(tracks[i], queue: tracks),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).animate(delay: (i * 40).ms).fadeIn(duration: 500.ms).slideX(begin: 0.05, end: 0),
                                ],
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  loadingWidget: const SectionShimmer(height: 200),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<dynamic>(
                  title: 'ALBUMS',
                  asyncValue: albumsAsync,
                  builder: (items) => SizedBox(
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
                                        color: colorScheme.shadow.withValues(alpha: 0.3),
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
                                      placeholder: (_, _) => Container(color: colorScheme.surfaceContainerHighest),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  album['name'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: colorScheme.onSurface,
                                    fontSize: 14,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  album['release_date']?.toString().substring(0, 4) ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.3),
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
                  loadingWidget: const SectionShimmer(height: 250),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<Map<String, dynamic>>(
                  title: 'FANS ALSO LIKE',
                  asyncValue: relatedAsync,
                  builder: (artists) => SizedBox(
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
                                        color: colorScheme.shadow.withValues(alpha: 0.5),
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
                                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                                        child: Icon(Icons.person, color: colorScheme.onSurface.withValues(alpha: 0.1)),
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
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
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
                  loadingWidget: const SectionShimmer(height: 190),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<Map<String, dynamic>>(
                  title: 'FEATURING ${artistName.toUpperCase()}',
                  asyncValue: playlistsAsync,
                  builder: (playlists) => SizedBox(
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
                                        color: colorScheme.shadow.withValues(alpha: 0.4),
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
                                            placeholder: (context, url) => const ShimmerPlaceholder(
                                              borderRadius: 20,
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: colorScheme.surface.withValues(alpha: 0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.playlist_play_rounded, color: colorScheme.onSurface, size: 14),
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
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
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
                                    color: colorScheme.onSurface.withValues(alpha: 0.4),
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
                  loadingWidget: const SectionShimmer(height: 250),
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




