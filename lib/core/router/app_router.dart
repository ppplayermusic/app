import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/home/recently_played_screen.dart';
import '../../features/home/genre_details_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/artist/artist_screen.dart';
import '../../features/album/album_screen.dart';
import '../../features/player/player_screen.dart';
import '../../features/library/liked_songs_screen.dart';
import '../../features/library/playlist_detail_screen.dart';
import '../../features/library/remote_playlist_screen.dart';
import '../../features/radio/radio_details_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/network_streams/stream_playlist_detail_screen.dart';
import '../../features/local_library/local_library_screen.dart';
import '../../features/local_library/local_video_library_screen.dart';
import '../../shared/widgets/scaffold_with_nav.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder:
            (context, state, child) =>
                ScaffoldWithNav(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: DiscoverScreen()),
          ),
          GoRoute(
            path: '/recently-played',
            builder: (context, state) => const RecentlyPlayedScreen(),
          ),
          GoRoute(
            path: '/search',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) {
              final filterStr = state.uri.queryParameters['filter'];
              final filter =
                  filterStr == 'playlists'
                      ? LibraryFilter.playlists
                      : LibraryFilter.all;
              return NoTransitionPage(
                child: LibraryScreen(initialFilter: filter),
              );
            },
          ),
          GoRoute(
            path: '/local-library',
            builder: (context, state) => const LocalLibraryScreen(),
          ),
          GoRoute(
            path: '/local-videos',
            builder: (context, state) => const LocalVideoLibraryScreen(),
          ),
          GoRoute(
            path: '/artist/:id',
            builder:
                (context, state) =>
                    ArtistScreen(artistId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/album/:id',
            builder:
                (context, state) =>
                    AlbumScreen(albumId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/playlist/:id',
            builder:
                (context, state) => PlaylistDetailScreen(
                  playlistId: int.parse(state.pathParameters['id']!),
                ),
          ),
          GoRoute(
            path: '/playlist/remote/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'];
              return RemotePlaylistScreen(playlistId: id, playlistName: name);
            },
          ),
          GoRoute(
            path: '/player',
            pageBuilder:
                (context, state) => CustomTransitionPage(
                  child: const PlayerScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOutQuart)),
                      ),
                      child: child,
                    );
                  },
                ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/liked-songs',
            builder: (context, state) => const LikedSongsScreen(),
          ),
          GoRoute(
            path: '/radio/:type/:id',
            builder: (context, state) {
              final type = state.pathParameters['type']!;
              final id = state.pathParameters['id']!;
              final title = state.uri.queryParameters['title'] ?? 'Radio';
              final imageUrl = state.uri.queryParameters['imageUrl'] ?? '';
              final subtitle = state.uri.queryParameters['subtitle'];
              final artistId = state.uri.queryParameters['artistId'];
              final artistName = state.uri.queryParameters['artistName'];

              final extra = state.extra as Map<String, dynamic>?;
              final color1 = extra?['color1'] as Color?;
              final color2 = extra?['color2'] as Color?;

              return RadioDetailsScreen(
                seedType: type,
                seedId: id,
                title: title,
                imageUrl: imageUrl,
                subtitle: subtitle,
                artistId: artistId,
                artistName: artistName,
                color1: color1,
                color2: color2,
              );
            },
          ),
          GoRoute(
            path: '/genre/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? id;
              return GenreDetailsScreen(categoryId: id, categoryName: name);
            },
          ),
          GoRoute(
            path: '/stream_playlist/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return StreamPlaylistDetailScreen(playlistId: id);
            },
          ),
        ],
      ),
    ],
  );
});
