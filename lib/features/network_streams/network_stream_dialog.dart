import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../core/network_streams/network_stream_service.dart';
import '../../core/network_streams/playlist_parser.dart';
import '../../core/player/player_provider.dart';
import '../../core/models/track.dart';

void showNetworkStreamDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const NetworkStreamDialog(),
  );
}

class NetworkStreamDialog extends ConsumerStatefulWidget {
  const NetworkStreamDialog({super.key});

  @override
  ConsumerState<NetworkStreamDialog> createState() =>
      _NetworkStreamDialogState();
}

class _NetworkStreamDialogState extends ConsumerState<NetworkStreamDialog> {
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  http.Client? _activeClient;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _activeClient?.close();
    super.dispose();
  }

  Future<void> _submit({bool saveToLibrary = true}) async {
    final url = _urlController.text.trim();
    var title = _titleController.text.trim();
    if (url.isEmpty) return;

    if (title.isEmpty) {
      title = 'Network Stream';
    }

    _activeClient?.close();
    _activeClient = http.Client();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(networkStreamServiceProvider);
      final channels = await service.analyzeAndParseUrl(
        url,
        client: _activeClient,
      );

      if (channels.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'No channels found in stream/playlist.';
          _isLoading = false;
        });
        return;
      }

      if (saveToLibrary) {
        await service.savePlaylist(title, url, channels);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${channels.length} channels from stream!'),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.pop(context); // Close the dialog
          
          // Just play the first stream immediately
          final first = channels.first;
          final track = Track.fromNetworkStream(
            streamUrl: first.url,
            title: first.title,
            groupTitle: first.groupTitle ?? 'IPTV',
            logoUrl: first.tvgLogo,
          );
          ref.read(playerProvider.notifier).playTrack(track, queue: [track]);
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      if (e is YoutubeApiKeyMissingException) {
        setState(() {
          _isLoading = false;
        });
        
        final urlStr = _urlController.text.trim();
        final uri = Uri.tryParse(urlStr);
        final hasVideoId = uri != null && (uri.queryParameters.containsKey('v') || (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty));
        
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('API Key Required'),
            content: Text(hasVideoId 
                ? '${e.message}\n\nYou can still add the single video from this link instead of the whole playlist.' 
                : e.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              if (hasVideoId)
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx); // Close the API key dialog
                    
                    setState(() {
                      _isLoading = true;
                    });
                    
                    try {
                      final service = ref.read(networkStreamServiceProvider);
                      var finalTitle = _titleController.text.trim();
                      if (finalTitle.isEmpty) finalTitle = 'YouTube Video';
                      
                      String videoId = uri.queryParameters['v'] ?? uri.pathSegments.first;
                      final cleanUrl = 'https://youtube.com/watch?v=$videoId';
                      
                      if (saveToLibrary) {
                        await service.savePlaylist(finalTitle, cleanUrl, [
                          PlaylistItem(title: finalTitle, url: cleanUrl),
                        ]);
                        
                        if (mounted) {
                          Navigator.pop(context); // Close the network stream dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added video successfully!')),
                          );
                        }
                      } else {
                        if (mounted) {
                          Navigator.pop(context); // Close the dialog
                          final track = Track.fromNetworkStream(
                            streamUrl: cleanUrl,
                            title: finalTitle,
                            groupTitle: 'YouTube',
                          );
                          ref.read(playerProvider.notifier).playTrack(track, queue: [track]);
                        }
                      }
                    } catch(err) {
                      if (mounted) {
                        setState(() {
                          _error = err.toString();
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: Text(saveToLibrary ? 'Add Single Video' : 'Play Single Video'),
                ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Close the network stream dialog too
                  context.push('/settings');
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      }

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    } finally {
      _activeClient?.close();
      _activeClient = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: const Text('Open Network Stream'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter a network stream URL (HTTP/HTTPS) or a remote M3U playlist link.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Stream URL',
                hintText: 'https://...',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading,
              onSubmitted: (_) => _submit(saveToLibrary: false),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (Optional)',
                hintText: 'My Stream',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading,
              onSubmitted: (_) => _submit(saveToLibrary: false),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: colorScheme.error, fontSize: 13),
              ),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : () => _submit(saveToLibrary: true),
          child: const Text('Save to Library'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : () => _submit(saveToLibrary: false),
          child: const Text('Just Play'),
        ),
      ],
    );
  }
}
