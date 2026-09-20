import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_kit/media_kit.dart';
import '../../../core/services/settings_provider.dart';
import '../../../core/playback/playback_providers.dart';
import '../../../core/player/player_provider.dart';
import 'package:ppplayer/l10n/app_localizations.dart';

class SubtitlePanel extends ConsumerStatefulWidget {
  final Player? player;
  const SubtitlePanel({super.key, required this.player});

  @override
  ConsumerState<SubtitlePanel> createState() => _SubtitlePanelState();
}

class _SubtitlePanelState extends ConsumerState<SubtitlePanel> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(playerProvider);
    final currentDelay = state.subtitleDelay;
    final engine = ref.watch(playbackControllerProvider);
    final settings = ref.watch(settingsProvider);

    final tracks = widget.player?.state.tracks.subtitle ?? <SubtitleTrack>[];
    final currentTrack = widget.player?.state.track.subtitle;

    final supportsDelay = engine.supportsSubtitleDelay;
    final supportsSize = engine.supportsSubtitleTextSize;
    final supportsBg = engine.supportsSubtitleBackgroundStyling;
    final supportsExt = engine.supportsExternalSubtitles;
    final supportsTrackSelection = engine.supportsTrackSelection;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.subtitles,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          if (supportsTrackSelection) ...[
            ...tracks.map((track) {
              final isSelected = track == currentTrack;
              String? displayStr;
              if (track.id == 'no' || track.id == 'none') {
                displayStr = AppLocalizations.of(context)!.off;
              } else if (track.title != null && track.title.toString().trim().isNotEmpty) {
                displayStr = track.title;
              } else if (track.language != null && track.language.toString().trim().isNotEmpty) {
                displayStr = track.language;
              } else {
                displayStr = track.id;
              }

              return ListTile(
                title: Text(displayStr ?? 'Unknown'),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () async {
                  if (track.id == 'no' || track.id == 'none') {
                    await ref.read(playerProvider.notifier).setSubtitleTrack(null);
                  } else {
                    widget.player?.setSubtitleTrack(track);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              );
            }),
          ],

          if (supportsExt && (!Platform.isAndroid && !Platform.isIOS)) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: Text(AppLocalizations.of(context)!.loadSubtitleFile),
              onTap: _pickExternalSubtitle,
            ),
          ],

          if (supportsDelay) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 16),
                  Text('Delay: ${(currentDelay.inMilliseconds / 1000.0).toStringAsFixed(1)} s'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _updateDelay((currentDelay.inMilliseconds / 1000.0) - 0.1),
                    tooltip: 'Earlier',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => _updateDelay(0), // reset
                    tooltip: 'Reset',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _updateDelay((currentDelay.inMilliseconds / 1000.0) + 0.1),
                    tooltip: 'Later',
                  ),
                ],
              ),
            ),
          ],

          if (supportsSize || supportsBg) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (supportsSize) ...[
                    Row(
                      children: [
                        const Text('Size'),
                        Expanded(
                          child: Slider(
                            value: settings.subtitleTextSize,
                            min: 12.0,
                            max: 48.0,
                            onChanged: (val) {
                              ref.read(settingsProvider.notifier).setSubtitleTextSize(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (supportsBg) ...[
                    Row(
                      children: [
                        const Text('Background'),
                        const Spacer(),
                        Switch(
                          value: Color(settings.subtitleBackgroundColor).a > 0,
                          onChanged: (val) {
                            ref.read(settingsProvider.notifier).setSubtitleBackgroundColor(
                              val ? 0x80000000 : 0x00000000,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateDelay(double delaySeconds) async {
    final ms = (delaySeconds * 1000).round();
    await ref.read(playerProvider.notifier).setSubtitleDelay(Duration(milliseconds: ms));
  }

  Future<void> _pickExternalSubtitle() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt', 'vtt', 'ass', 'ssa', 'sub'],
    );
    if (result.isNotEmpty && result.single.path != null) {
      final path = result.single.path!;
      await ref.read(playerProvider.notifier).setSubtitleTrack(path);
      if (mounted) Navigator.pop(context);
    }
  }
}
