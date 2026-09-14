import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/tactile_buttons.dart';
import '../../core/local_library/local_library_service.dart';
import 'local_songs_tab.dart';
import 'local_folders_tab.dart';
import 'local_artists_tab.dart';
import 'local_albums_tab.dart';
import 'local_library_providers.dart';
import 'package:ppplayer/l10n/app_localizations.dart';

class LocalLibraryScreen extends ConsumerStatefulWidget {
  const LocalLibraryScreen({super.key});

  @override
  ConsumerState<LocalLibraryScreen> createState() => _LocalLibraryScreenState();
}

class _LocalLibraryScreenState extends ConsumerState<LocalLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    _searchController.addListener(() {
      ref.read(localSearchQueryProvider.notifier).update(_searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              hintText: l10n.searchLocalMusic,
                              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
                          'Local Music', // Could be localized if there's a key for it
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
                          icon: Icon(Icons.add_circle_outline_rounded, color: colorScheme.onSurface),
                          tooltip: l10n.addMusic,
                          color: colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onSelected: (value) {
                            if (value == 'files') {
                              ref.read(localLibraryServiceProvider).importFiles();
                            } else if (value == 'folder') {
                              ref.read(localLibraryServiceProvider).importFolder();
                            } else if (value == 'rescan') {
                              // Rescan logic here if available
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'files',
                              child: Row(
                                children: [
                                  const Icon(Icons.audio_file_outlined),
                                  const SizedBox(width: 12),
                                  Text(l10n.addFiles),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'folder',
                              child: Row(
                                children: [
                                  const Icon(Icons.create_new_folder_outlined),
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
                                  const Icon(Icons.refresh_rounded),
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
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: colorScheme.primary,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: l10n.songsTab),
                Tab(text: l10n.foldersTab),
                Tab(text: l10n.artistsTab),
                Tab(text: l10n.albumsTab),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  LocalSongsTab(),
                  LocalFoldersTab(),
                  LocalArtistsTab(),
                  LocalAlbumsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
