import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:ppplayer/l10n/app_localizations.dart';
import '../../../core/playback/playback_providers.dart';
import '../../../core/player/player_provider.dart';

class VideoControlsOverlay extends ConsumerStatefulWidget {
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;
  final VoidCallback onToggleFit;
  final bool isFill;

  const VideoControlsOverlay({
    super.key,
    required this.onToggleFullscreen,
    required this.isFullscreen,
    required this.onToggleFit,
    required this.isFill,
  });

  @override
  ConsumerState<VideoControlsOverlay> createState() =>
      _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends ConsumerState<VideoControlsOverlay> {
  bool _isVisible = true;

  mk.Player? get _mkPlayer {
    final engine = ref.read(playbackControllerProvider);
    return engine.renderer?.player;
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Future<void> _showTrackSelectionDialog<T>(
    String title,
    List<T> tracks,
    T currentTrack,
    ValueChanged<T> onSelect, {
    VoidCallback? onExternalLoad,
  }) async {
    final selected = await showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...tracks.map((track) {
                  final isSelected = track == currentTrack;
                  final dynamic t = track;
                  // Map 'no' track to 'Off'
                  final String displayTitle = (t.id == 'no' || t.id == 'none')
                      ? AppLocalizations.of(context)!.off
                      : (t.title ?? t.language ?? t.id);
                  return ListTile(
                    title: Text(displayTitle),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(track),
                  );
                }),
                if (onExternalLoad != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.file_upload),
                    title: Text(AppLocalizations.of(context)!.loadSubtitleFile),
                    onTap: () {
                      Navigator.of(context).pop();
                      onExternalLoad();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      onSelect(selected);
    }
  }

  Future<void> _pickExternalSubtitle(mk.Player player) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['srt', 'vtt'],
      );

      if (result.isNotEmpty && result.single.path != null) {
        final path = result.single.path!;
        await ref.read(playerProvider.notifier).setSubtitleTrack(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingSubtitle(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleVisibility,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !_isVisible,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.closed_caption,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final player = _mkPlayer;
                        if (player != null) {
                          _showTrackSelectionDialog(
                            AppLocalizations.of(context)!.subtitles,
                            player.state.tracks.subtitle,
                            player.state.track.subtitle,
                            (t) async {
                              if (t.id == 'no' || t.id == 'none') {
                                await ref
                                    .read(playerProvider.notifier)
                                    .setSubtitleTrack(null);
                              } else {
                                player.setSubtitleTrack(t);
                              }
                            },
                            onExternalLoad: () => _pickExternalSubtitle(player),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.audiotrack, color: Colors.white),
                      onPressed: () {
                        final player = _mkPlayer;
                        if (player != null) {
                          _showTrackSelectionDialog(
                            AppLocalizations.of(context)!.audioTracks,
                            player.state.tracks.audio,
                            player.state.track.audio,
                            (t) => player.setAudioTrack(t),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.isFill ? Icons.fit_screen : Icons.crop_free,
                        color: Colors.white,
                      ),
                      tooltip: widget.isFill ? 'Fit' : 'Fill',
                      onPressed: widget.onToggleFit,
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      tooltip: widget.isFullscreen
                          ? 'Exit Fullscreen'
                          : 'Fullscreen',
                      onPressed: widget.onToggleFullscreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
