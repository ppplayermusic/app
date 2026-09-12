import 'package:flutter/material.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import '../../shared/widgets/pp_image.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/section_wrapper.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../core/services/favorites_provider.dart';
import '../../shared/widgets/playlist_cover.dart';
import '../../shared/widgets/animated_equalizer.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';

import '../../core/api/spotify_repository.dart';

final artistProvider = StreamProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, id) {
      return ref
          .watch(spotifyRepositoryProvider)
          .watchArtist(id)
          .map((res) => res.data);
    });

final artistTopTracksProvider = StreamProvider.autoDispose
    .family<List<dynamic>, String>((ref, id) {
      return ref
          .watch(spotifyRepositoryProvider)
          .watchArtistTopTracks(id)
          .map((res) => res.data);
    });

final artistAlbumsProvider = StreamProvider.autoDispose
    .family<List<dynamic>, String>((ref, id) {
      return ref
          .watch(spotifyRepositoryProvider)
          .watchArtistAlbums(id)
          .map((res) => res.data);
    });

final relatedArtistsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, id) {
      return ref
          .watch(spotifyRepositoryProvider)
          .watchRelatedArtists(id)
          .map((res) => res.data);
    });

final artistPlaylistsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, name) {
      if (name.isEmpty) return Stream.value([]);
      return ref
          .watch(spotifyRepositoryProvider)
          .watchSearch('Featuring $name', limit: 12)
          .map((res) {
            final playlists = res.data['playlists']?['items'] as List?;
            return playlists?.cast<Map<String, dynamic>>() ?? [];
          });
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
    final artistAsync = ref.watch(artistProvider(widget.artistId));
    final tracksAsync = ref.watch(artistTopTracksProvider(widget.artistId));
    final albumsAsync = ref.watch(artistAlbumsProvider(widget.artistId));
    final relatedAsync = ref.watch(relatedArtistsProvider(widget.artistId));
    final playlistsAsync = ref.watch(
      artistPlaylistsProvider(artistAsync.asData?.value['name'] ?? ''),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: artistAsync.when(
        loading: () => const ArtistDetailsShimmer(),
        error:
            (e, _) => Center(
              child: Text(
                'Error: $e',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
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
                      icon:
                          _isSearching
                              ? Icons.close_rounded
                              : Icons.search_rounded,
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
                    final isCollapsed =
                        constraints.maxHeight <=
                        kToolbarHeight + topPadding + 10;

                    return FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      centerTitle: true,
                      expandedTitleScale: 1.0,
                      titlePadding: EdgeInsets.zero,
                      title:
                          isCollapsed && !_isSearching
                              ? AdaptiveBlur(
                                sigmaX: 20,
                                sigmaY: 20,
                                child: Container(
                                  width: double.infinity,
                                  height: kToolbarHeight + topPadding,
                                  padding: EdgeInsets.only(top: topPadding),
                                  color: colorScheme.surface.withValues(
                                    alpha: 0.6,
                                  ),
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
                              )
                              : null,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (headerImage != null)
                            PPImage(imageUrl: headerImage, fit: BoxFit.cover)
                          else
                            Container(
                              color: colorScheme.surfaceContainerHighest,
                            ),

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
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.85,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.15),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface.withValues(
                                          alpha: 0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.15),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ARTIST',
                                            style: TextStyle(
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.5),
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
                                                      color: colorScheme.surface
                                                          .withValues(
                                                            alpha: 0.45,
                                                          ),
                                                      blurRadius: 30,
                                                      offset: const Offset(
                                                        0,
                                                        15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .animate()
                                              .fadeIn(duration: 600.ms)
                                              .scale(
                                                begin: const Offset(0.95, 0.95),
                                                curve: Curves.easeOutCubic,
                                              ),
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
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isSearching) ...[
                        Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final statusAsync = ref.watch(
                                            favoritesStatusProvider((
                                              FavoriteType.artist,
                                              widget.artistId,
                                            )),
                                          );
                                          final isFollowed =
                                              statusAsync.value ?? false;

                                          return TactileTap(
                                            onTap: () {
                                              final imgs =
                                                  (artist['images'] as List?) ??
                                                  [];
                                              final artistImageUrl =
                                                  imgs.isNotEmpty
                                                      ? imgs[0]['url'] as String
                                                      : '';
                                              ref
                                                  .read(
                                                    favoritesControllerProvider
                                                        .notifier,
                                                  )
                                                  .toggleArtistFollow(
                                                    widget.artistId,
                                                    artistName,
                                                    artistImageUrl,
                                                    isFollowed,
                                                  );
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isFollowed
                                                        ? colorScheme.primary
                                                            .withValues(
                                                              alpha: 0.2,
                                                            )
                                                        : colorScheme.onSurface
                                                            .withValues(
                                                              alpha: 0.05,
                                                            ),
                                                border: Border.all(
                                                  color:
                                                      isFollowed
                                                          ? colorScheme.primary
                                                              .withValues(
                                                                alpha: 0.4,
                                                              )
                                                          : colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                isFollowed
                                                    ? 'FOLLOWING'
                                                    : 'FOLLOW',
                                                style: TextStyle(
                                                  color:
                                                      isFollowed
                                                          ? colorScheme.primary
                                                          : colorScheme
                                                              .onSurface,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 11,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      TactileTap(
                                        onTap: () {
                                          final artistData =
                                              artistAsync.asData?.value;
                                          if (artistData != null) {
                                            final artistName =
                                                artistData['name'] ?? 'Artist';
                                            final imgs =
                                                (artistData['images']
                                                    as List?) ??
                                                [];
                                            final artistImageUrl =
                                                imgs.isNotEmpty
                                                    ? imgs[0]['url'] as String
                                                    : '';

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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.2),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.4),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.radio_rounded,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'RADIO',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 11,
                                                  letterSpacing: 1.5,
                                                ),
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
                                      final modelTracks =
                                          tracks
                                              .map(
                                                (j) => Track.fromSpotify(
                                                  j as Map<String, dynamic>,
                                                ),
                                              )
                                              .toList();
                                      ref
                                          .read(playerProvider.notifier)
                                          .playTrack(
                                            modelTracks.first,
                                            queue: modelTracks,
                                            contextArtistId: widget.artistId,
                                          );
                                    }
                                  },
                                ).animate().scale(
                                  delay: 200.ms,
                                  duration: 400.ms,
                                  curve: Curves.easeOutBack,
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.2, curve: Curves.easeOutCubic),
                      ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<dynamic>(
                  title: AppLocalizations.of(context)!.popular,
                  asyncValue: tracksAsync,
                  builder: (items) {
                    var tracks =
                        items
                            .map(
                              (j) =>
                                  Track.fromSpotify(j as Map<String, dynamic>),
                            )
                            .toList();
                    final filteredTracks =
                        _searchQuery.isEmpty
                            ? tracks
                            : tracks
                                .where(
                                  (t) => t.name.toLowerCase().contains(
                                    _searchQuery,
                                  ),
                                )
                                .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSearching)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 24,
                              left: 16,
                              right: 16,
                            ),
                            child: AdaptiveBlur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.searchPopularSongs,
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.3),
                                          size: 20,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                        hintStyle: TextStyle(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.3),
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 14,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value.toLowerCase();
                                        });
                                      },
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .scale(begin: const Offset(0.95, 0.95)),
                          ),
                        if (filteredTracks.isEmpty && _searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(64.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 48,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No tracks found for "$_searchQuery"',
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                                      fontSize: 14,
                                    ),
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
                                for (
                                  int i = 0;
                                  i < filteredTracks.length;
                                  i++
                                ) ...[
                                  TrackTile(
                                        index: i + 1,
                                        track: filteredTracks[i],
                                        onTap:
                                            () => ref
                                                .read(playerProvider.notifier)
                                                .playTrack(
                                                  filteredTracks[i],
                                                  queue: filteredTracks,
                                                  contextArtistId:
                                                      widget.artistId,
                                                ),
                                      )
                                      .animate(delay: (i * 40).ms)
                                      .fadeIn(duration: 500.ms)
                                      .slideX(begin: 0.05, end: 0),
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
                  title: AppLocalizations.of(context)!.albums,
                  asyncValue: albumsAsync,
                  builder:
                      (items) => SizedBox(
                        height: 256,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            return _ArtistAlbumCard(
                                  album: items[i] as Map<String, dynamic>,
                                  artistId: widget.artistId,
                                )
                                .animate(delay: (i * 70).ms)
                                .fadeIn(duration: 500.ms)
                                .scale(begin: const Offset(0.95, 0.95));
                          },
                        ),
                      ),
                  loadingWidget: const SectionShimmer(height: 250),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<Map<String, dynamic>>(
                  title: AppLocalizations.of(context)!.fansAlsoLike,
                  asyncValue: relatedAsync,
                  builder:
                      (artists) => SizedBox(
                        height: 200,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: artists.length,
                          itemBuilder: (context, i) {
                            return _RelatedArtistCard(artist: artists[i])
                                .animate(delay: (i * 60).ms)
                                .fadeIn(duration: 500.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutBack,
                                );
                          },
                        ),
                      ),
                  loadingWidget: const SectionShimmer(height: 190),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper<Map<String, dynamic>>(
                  title: AppLocalizations.of(context)!.featuringArtist(artistName.toUpperCase()),
                  asyncValue: playlistsAsync,
                  builder:
                      (playlists) => SizedBox(
                        height: 265,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: playlists.length,
                          itemBuilder: (context, i) {
                            return _ArtistPlaylistCard(
                                  playlist: playlists[i],
                                  artistId: widget.artistId,
                                )
                                .animate(delay: (i * 80).ms)
                                .fadeIn(duration: 600.ms)
                                .scale(
                                  begin: const Offset(0.95, 0.95),
                                  curve: Curves.easeOutCubic,
                                );
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

class _ArtistAlbumCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> album;
  final String artistId;

  const _ArtistAlbumCard({required this.album, required this.artistId});

  @override
  ConsumerState<_ArtistAlbumCard> createState() => _ArtistAlbumCardState();
}

class _ArtistAlbumCardState extends ConsumerState<_ArtistAlbumCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final album = widget.album;
    final imgs = (album['images'] as List?) ?? [];
    final imageUrl = imgs.isNotEmpty ? imgs[0]['url'] as String : '';

    final playerState = ref.watch(playerProvider);
    final currentTrack = playerState.currentTrack;
    final isCurrentAlbum =
        currentTrack?.albumId != null && currentTrack?.albumId == album['id'];
    final isPlaying = isCurrentAlbum && playerState.isPlaying;

    void onPlayTap() async {
      if (isCurrentAlbum) {
        ref.read(playerProvider.notifier).togglePlay();
        return;
      }
      try {
        final cacheResult =
            await ref
                .read(spotifyRepositoryProvider)
                .watchAlbum(album['id'])
                .first;
        final albumData = cacheResult.data;
        final tracksRaw = albumData['tracks']?['items'] as List? ?? [];
        final tracks =
            tracksRaw
                .map((j) => Track.fromSpotify(j as Map<String, dynamic>))
                .toList();
        if (tracks.isNotEmpty) {
          ref
              .read(playerProvider.notifier)
              .playTrack(
                tracks.first,
                queue: tracks,
                contextArtistId: widget.artistId,
              );
        }
      } catch (_) {}
    }

    return ContentContextMenuRegion(
      target: AlbumContextTarget(
        id: album['id'] as String,
        name: album['name'] as String,
        artistName: (album['artists'] as List?)?.firstOrNull?['name'] ?? '',
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: TactileTap(
          onTap: () => context.push("/album/${album['id']}"),
          scaleDown: 0.96,
          child: AnimatedScale(
            scale: _isHovered ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isCurrentAlbum
                                ? colorScheme.primary.withValues(alpha: 0.8)
                                : (_isHovered
                                    ? colorScheme.primary.withValues(alpha: 0.3)
                                    : Colors.transparent),
                        width: isCurrentAlbum ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isCurrentAlbum || _isHovered)
                                  ? colorScheme.primary.withValues(alpha: 0.35)
                                  : colorScheme.shadow.withValues(alpha: 0.3),
                          blurRadius: (isCurrentAlbum || _isHovered) ? 26 : 20,
                          spreadRadius: (isCurrentAlbum || _isHovered) ? 2 : 0,
                          offset: Offset(
                            0,
                            (isCurrentAlbum || _isHovered) ? 14 : 10,
                          ),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: HoverPlayOverlay(
                        onPlay: onPlayTap,
                        isHovered: _isHovered,
                        isPlaying: isPlaying,
                        size: 42,
                        child: PPImage(
                          imageUrl: imageUrl,
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color:
                          (isCurrentAlbum || _isHovered)
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                    child: Row(
                      children: [
                        if (isCurrentAlbum) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: AnimatedEqualizer(
                              color: colorScheme.primary,
                              size: 14,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            album['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album['release_date']?.toString().substring(0, 4) ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                    ),
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

class _RelatedArtistCard extends StatefulWidget {
  final Map<String, dynamic> artist;

  const _RelatedArtistCard({required this.artist});

  @override
  State<_RelatedArtistCard> createState() => _RelatedArtistCardState();
}

class _RelatedArtistCardState extends State<_RelatedArtistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final artist = widget.artist;
    final rImgs = (artist['images'] as List?) ?? [];
    final rImgUrl = rImgs.isNotEmpty ? rImgs[0]['url'] as String : '';

    return ContentContextMenuRegion(
      target: ArtistContextTarget(
        id: artist['id'] as String,
        name: artist['name'] as String,
        imageUrl: rImgUrl.isNotEmpty ? rImgUrl : null,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: TactileTap(
          onTap: () => context.push("/artist/${artist['id']}"),
          scaleDown: 0.94,
          child: AnimatedScale(
            scale: _isHovered ? 1.06 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _isHovered
                                ? colorScheme.primary.withValues(alpha: 0.8)
                                : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              _isHovered
                                  ? colorScheme.primary.withValues(alpha: 0.35)
                                  : colorScheme.shadow.withValues(alpha: 0.5),
                          blurRadius: _isHovered ? 36 : 30,
                          spreadRadius: _isHovered ? 2 : -10,
                          offset: Offset(0, _isHovered ? 18 : 15),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: PPImage(imageUrl: rImgUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      color:
                          _isHovered
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: -0.2,
                    ),
                    child: Text(
                      artist['name'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
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

class _ArtistPlaylistCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> playlist;
  final String artistId;

  const _ArtistPlaylistCard({required this.playlist, required this.artistId});

  @override
  ConsumerState<_ArtistPlaylistCard> createState() =>
      _ArtistPlaylistCardState();
}

class _ArtistPlaylistCardState extends ConsumerState<_ArtistPlaylistCard> {
  bool _isHovered = false;

  void _onPlay() async {
    try {
      final cacheResult =
          await ref
              .read(spotifyRepositoryProvider)
              .watchPlaylistTracks(widget.playlist['id'])
              .first;
      final tracks = cacheResult.data;
      if (tracks.isNotEmpty) {
        ref
            .read(playerProvider.notifier)
            .playTrack(
              tracks.first,
              queue: tracks,
              contextArtistId: widget.artistId,
            );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final playlist = widget.playlist;
    final pImgs = (playlist['images'] as List?) ?? [];
    final images = pImgs.map((i) => i['url'] as String).toList();
    final pImgUrl = images.isNotEmpty ? images[0] : '';

    Widget imageWidget;
    if (images.length > 1) {
      imageWidget = PlaylistCover(images: images, size: 170, borderRadius: 20);
    } else {
      imageWidget = PPImage(
        imageUrl: pImgUrl,
        width: 170,
        height: 170,
        fit: BoxFit.cover,
      );
    }

    final id = playlist['id'];
    final name = playlist['name'] as String;

    return ContentContextMenuRegion(
      target: PlaylistContextTarget(
        id: id as String,
        name: name,
        imageUrl: pImgUrl.isNotEmpty ? pImgUrl : null,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: TactileTap(
          onTap:
              () => context.push(
                '/playlist/remote/$id?name=${Uri.encodeComponent(name)}',
              ),
          scaleDown: 0.96,
          child: AnimatedScale(
            scale: _isHovered ? 1.03 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Container(
              width: 170,
              margin: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              _isHovered
                                  ? colorScheme.primary.withValues(alpha: 0.3)
                                  : colorScheme.shadow.withValues(alpha: 0.4),
                          blurRadius: _isHovered ? 32 : 25,
                          spreadRadius: _isHovered ? 2 : -5,
                          offset: Offset(0, _isHovered ? 18 : 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: HoverPlayOverlay(
                        onPlay: _onPlay,
                        isHovered: _isHovered,
                        size: 42,
                        child: Stack(
                          children: [
                            imageWidget,
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 150),
                                opacity: _isHovered ? 0.0 : 1.0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface.withValues(
                                      alpha: 0.6,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.playlist_play_rounded,
                                    color: colorScheme.onSurface,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      color:
                          _isHovered
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                    child: Text(
                      playlist['name'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Playlist • ${playlist['tracks']?['total'] ?? 0} tracks',
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
          ),
        ),
      ),
    );
  }
}
