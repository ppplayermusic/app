import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/l10n/app_localizations.dart';

import '../../shared/widgets/tactile_buttons.dart';
import '../../core/local_library/local_library_service.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import 'local_video_library_providers.dart';

class LocalVideoLibraryScreen extends ConsumerStatefulWidget {
  const LocalVideoLibraryScreen({super.key});

  @override
  ConsumerState<LocalVideoLibraryScreen> createState() =>
      _LocalVideoLibraryScreenState();
}

class _LocalVideoLibraryScreenState
    extends ConsumerState<LocalVideoLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _scanStatus;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref
          .read(localVideoSearchQueryProvider.notifier)
          .update(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final videosAsync = ref.watch(sortedLocalVideosProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_scanStatus != null)
              Container(
                width: double.infinity,
                color: colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _scanStatus!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _isSearching
                  ? Row(
                      children: [
                        TactileIconButton(
                          icon: Icons.close_rounded,
                          onTap: () {
                            setState(() {
                              _isSearching = false;
                              _searchController.clear();
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: l10n.searchLocalVideos,
                              hintStyle: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        TactileIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          l10n.localVideosCard,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        TactileIconButton(
                          icon: Icons.search_rounded,
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: colorScheme.onSurface,
                          ),
                          tooltip: l10n.addVideos,
                          color: colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) async {
                            if (value == 'files') {
                              ref
                                  .read(localLibraryServiceProvider)
                                  .importVideoFiles();
                            } else if (value == 'folder') {
                              ref
                                  .read(localLibraryServiceProvider)
                                  .importVideoFolder();
                            } else if (value == 'rescan') {
                              setState(() => _scanStatus = l10n.rescanLibrary);
                              await ref
                                  .read(localLibraryServiceProvider)
                                  .rescanLibrary(
                                    onProgress: (msg) {
                                      if (mounted)
                                        setState(() => _scanStatus = msg);
                                    },
                                  );
                              if (mounted) setState(() => _scanStatus = null);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'files',
                              child: Row(
                                children: [
                                  const Icon(Icons.video_file_outlined),
                                  const SizedBox(width: 12),
                                  Text(l10n.addFiles),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'folder',
                              child: Row(
                                children: [
                                  const Icon(Icons.folder_open_rounded),
                                  const SizedBox(width: 12),
                                  Text(l10n.addFolder),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'rescan',
                              child: Row(
                                children: [
                                  const Icon(Icons.sync_rounded),
                                  const SizedBox(width: 12),
                                  Text(l10n.rescanLibrary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            _SortHeader(),
            Expanded(
              child: videosAsync.when(
                data: (tracks) {
                  if (tracks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSearching
                                ? l10n.noLocalVideos
                                : l10n.noLocalVideos,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120, top: 8),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return TrackTile(
                        index: index + 1,
                        track: track,
                        onTap: () {
                          ref
                              .read(playerProvider.notifier)
                              .playTracks(tracks, initialIndex: index);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(localVideoSortOptionProvider);
    final isAscending = ref.watch(localVideoSortAscendingProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    String sortText;
    switch (sortOption) {
      case LocalVideoSortOption.title:
        sortText = l10n.sortTitle;
        break;
      case LocalVideoSortOption.duration:
        sortText = l10n.sortDuration;
        break;
      case LocalVideoSortOption.dateAdded:
        sortText = l10n.sortDateAdded;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.sortBy,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          PopupMenuButton<LocalVideoSortOption>(
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (option) {
              if (option == sortOption) {
                ref
                    .read(localVideoSortAscendingProvider.notifier)
                    .update(!isAscending);
              } else {
                ref.read(localVideoSortOptionProvider.notifier).update(option);
              }
            },
            itemBuilder: (context) => [
              _buildMenuItem(
                context,
                LocalVideoSortOption.dateAdded,
                l10n.sortDateAdded,
                sortOption,
                isAscending,
              ),
              _buildMenuItem(
                context,
                LocalVideoSortOption.title,
                l10n.sortTitle,
                sortOption,
                isAscending,
              ),
              _buildMenuItem(
                context,
                LocalVideoSortOption.duration,
                l10n.sortDuration,
                sortOption,
                isAscending,
              ),
            ],
            child: Row(
              children: [
                Text(
                  sortText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isAscending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<LocalVideoSortOption> _buildMenuItem(
    BuildContext context,
    LocalVideoSortOption option,
    String text,
    LocalVideoSortOption currentOption,
    bool isAscending,
  ) {
    final isSelected = option == currentOption;
    return PopupMenuItem(
      value: option,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          if (isSelected)
            Icon(
              isAscending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
