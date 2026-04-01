import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/promotion_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/ad_service.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');

final _searchResultsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, query) async {
  if (query.isEmpty) return {};
  return ref.read(spotifyClientProvider).search(query);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl;
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(_searchQueryProvider);
    final results = ref.watch(_searchResultsProvider(query));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _ctrl,
            autofocus: false,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'What do you want to listen to?',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withValues(alpha: 0.6),
                size: 22,
              ),
              suffixIcon: _ctrl.text.isNotEmpty 
                ? TactileIconButton(
                    icon: Icons.close_rounded,
                    onTap: () {
                      _ctrl.clear();
                      ref.read(_searchQueryProvider.notifier).state = '';
                      setState(() {});
                    },
                    size: 20,
                    color: Colors.white70,
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onChanged: (v) {
              setState(() {});
              Future.delayed(const Duration(milliseconds: 400), () {
                if (_ctrl.text == v) {
                  ref.read(_searchQueryProvider.notifier).state = v;
                }
              });
            },
          ),
        ),
        bottom: query.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: TabBar(
                  controller: _tabCtrl,
                  indicatorColor: Colors.green,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  dividerColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'Tracks'),
                    Tab(text: 'Artists'),
                    Tab(text: 'Albums'),
                  ],
                ),
              ),
      ),
      body: query.isEmpty
          ? _EmptySearch()
          : results.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (data) => TabBarView(
                controller: _tabCtrl,
                children: [
                  _TrackResults(data['tracks']?['items'] ?? []),
                  _ArtistResults(data['artists']?['items'] ?? []),
                  _AlbumResults(data['albums']?['items'] ?? []),
                ],
              ),
            ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: Color(0xFF3A3A3A)),
          SizedBox(height: 16),
          Text('Search for music', style: TextStyle(color: Color(0xFFB3B3B3))),
        ],
      ),
    );
  }
}

class _TrackResults extends ConsumerWidget {
  const _TrackResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('No tracks found'));
    final tracks =
        items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
    return ListView.builder(
      itemCount: tracks.length + (tracks.length / 8).ceil(),
      itemBuilder: (_, i) {
        if (i % 9 == 0) {
          final promoIndex = (i / 9).floor() % 3;
          final promo = ref.read(adServiceProvider).getPromoData()[promoIndex];
          return PromotionTile(
            title: promo['title']!,
            subtitle: promo['subtitle']!,
            imageUrl: promo['image'],
            ctaText: promo['cta']!,
            type: PromotionType.vertical,
          );
        }
        
        final trackIndex = i - (i / 9).floor() - 1;
        if (trackIndex >= tracks.length || trackIndex < 0) return const SizedBox.shrink();
        
        return TrackTile(
          track: tracks[trackIndex],
          onTap: () => ref.read(playerProvider.notifier).playTrack(
                tracks[trackIndex],
                queue: tracks,
              ),
        );
      },
    );
  }
}

class _ArtistResults extends ConsumerWidget {
  const _ArtistResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('No artists found'));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: items.length + (items.length / 8).ceil(),
      itemBuilder: (_, i) {
        if (i % 9 == 0 && i != 0) {
          final promoIndex = (i / 9).floor() % 3;
          final promo = ref.read(adServiceProvider).getPromoData()[promoIndex];
          return PromotionTile(
            title: promo['title']!,
            subtitle: promo['subtitle']!,
            imageUrl: promo['image'],
            ctaText: promo['cta']!,
            type: PromotionType.vertical,
          );
        }
        
        final artistIndex = i - (i / 9).floor();
        if (artistIndex >= items.length || artistIndex < 0) return const SizedBox.shrink();
        
        final a = items[artistIndex] as Map<String, dynamic>;
        final images = (a['images'] as List?) ?? [];
        final imageUrl = images.isNotEmpty ? images[0]['url'] as String : '';

        return TactileTap(
          onTap: () => context.push('/artist/${a['id']}'),
          scaleDown: 0.98,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(color: Colors.white10),
                          )
                        : Container(
                            color: Colors.white10,
                            child: const Icon(Icons.person, color: Colors.white24),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Artist',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlbumResults extends StatelessWidget {
  const _AlbumResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Center(child: Text('No albums found'));
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BannerAdWidget(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final album = items[i] as Map<String, dynamic>;
                final images = (album['images'] as List?) ?? [];
                final imageUrl = images.isNotEmpty ? images[0]['url'] as String : '';

                return TactileTap(
                  onTap: () => context.push('/album/${album['id']}'),
                  scaleDown: 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(color: const Color(0xFF2A2A2A)),
                          ),
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
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (album['artists'] as List?)?.firstOrNull?['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
