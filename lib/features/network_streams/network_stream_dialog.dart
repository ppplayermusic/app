import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../core/network_streams/network_stream_service.dart';
import '../../core/network_streams/playlist_parser.dart';
import '../../core/network_streams/video_metadata.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/pp_logo_loader.dart';

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
  final _imageUrlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  
  VideoPlatform _selectedPlatform = VideoPlatform.autoDetect;
  Timer? _debounce;
  http.Client? _activeClient;
  bool _isLoading = false;
  bool _isFetchingMetadata = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_onUrlChanged);
    _urlFocusNode.addListener(_onUrlFocusChanged);
  }

  @override
  void dispose() {
    _urlController.removeListener(_onUrlChanged);
    _urlFocusNode.removeListener(_onUrlFocusChanged);
    _urlController.dispose();
    _titleController.dispose();
    _imageUrlController.dispose();
    _urlFocusNode.dispose();
    _debounce?.cancel();
    _activeClient?.close();
    super.dispose();
  }

  String _cleanUrl(String input) {
    input = input.trim();
    if (input.toLowerCase().startsWith('<iframe')) {
      final srcMatch = RegExp(r'src="([^"]+)"').firstMatch(input);
      if (srcMatch != null) {
        input = srcMatch.group(1)!;
      }
    }
    return input;
  }

  void _onUrlChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _fetchMetadataForUrl(_urlController.text.trim());
    });
  }
  
  void _onUrlFocusChanged() {
    if (!_urlFocusNode.hasFocus) {
      _fetchMetadataForUrl(_urlController.text.trim());
    }
  }
  
  Future<void> _fetchMetadataForUrl(String rawUrl) async {
    final url = _cleanUrl(rawUrl);
    if (url.isEmpty) return;
    
    // Update the controller with the clean URL if it changed (e.g. from iframe)
    if (url != rawUrl && _urlController.text.trim() == rawUrl) {
      _urlController.text = url;
    }
    
    // Only auto-fetch if we are in auto-detect or if the platform might have changed
    if (_selectedPlatform != VideoPlatform.autoDetect) {
      // If user manually chose a platform, don't overwrite blindly unless they want auto.
      // But actually, maybe it's fine to fetch anyway, we'll let the service decide.
    }

    setState(() {
      _isFetchingMetadata = true;
    });

    try {
      final service = ref.read(networkStreamServiceProvider);
      final metadata = await service.fetchVideoMetadata(url);
      
      if (!mounted) return;
      
      setState(() {
        if (metadata.platform != VideoPlatform.custom) {
          _selectedPlatform = metadata.platform;
        }
        
        if (_titleController.text.isEmpty || _titleController.text == 'YouTube Video' || _titleController.text == 'Vimeo Video' || _titleController.text == 'Dailymotion Video') {
          _titleController.text = metadata.title;
        }
        
        if (metadata.thumbnailUrl != null && _imageUrlController.text.isEmpty) {
          _imageUrlController.text = metadata.thumbnailUrl!;
        }
      });
    } catch (_) {
      // Ignore errors on auto-fetch
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMetadata = false;
        });
      }
    }
  }

  Future<void> _submit({bool saveToLibrary = true}) async {
    var url = _cleanUrl(_urlController.text.trim());
    if (url.isEmpty) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    var title = _titleController.text.trim();
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
      
      // If platform is youtube, vimeo, dailymotion, and it's a single video, we can save it directly
      if (_selectedPlatform == VideoPlatform.youtube || _selectedPlatform == VideoPlatform.vimeo || _selectedPlatform == VideoPlatform.dailymotion) {
         if (saveToLibrary) {
           await service.savePlaylist(title, url, [
              PlaylistItem(title: title, url: url, tvgLogo: _imageUrlController.text.trim()),
            ], imageUrl: _imageUrlController.text.trim(), sourceKind: _selectedPlatform.dbSourceKind);
            
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added video successfully!')),
              );
            }
         } else {
            if (mounted) {
              Navigator.pop(context);
              final track = Track.fromNetworkStream(
                streamUrl: url,
                title: title,
                groupTitle: _selectedPlatform.displayName,
                logoUrl: _imageUrlController.text.trim(),
              );
              ref.read(playerProvider.notifier).playTrack(track, queue: [track]);
            }
         }
         return;
      }
      
      // For autoDetect or custom, try parsing as playlist
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
        final imgUrl = _imageUrlController.text.trim();
        await service.savePlaylist(title, url, channels, imageUrl: imgUrl.isEmpty ? null : imgUrl, sourceKind: _selectedPlatform.dbSourceKind);

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
                      _selectedPlatform = VideoPlatform.youtube;
                    });
                    
                    try {
                      final service = ref.read(networkStreamServiceProvider);
                      var finalTitle = _titleController.text.trim();
                      if (finalTitle.isEmpty) finalTitle = 'YouTube Video';
                      
                      String videoId = uri.queryParameters['v'] ?? uri.pathSegments.first;
                      final cleanUrl = 'https://youtube.com/watch?v=$videoId';
                      
                      if (saveToLibrary) {
                        final enteredImg = _imageUrlController.text.trim();
                        final imgUrl = enteredImg.isEmpty ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg' : enteredImg;
                        
                        await service.savePlaylist(finalTitle, cleanUrl, [
                          PlaylistItem(title: finalTitle, url: cleanUrl),
                        ], imageUrl: imgUrl, sourceKind: 'youtube_video');
                        
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
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Platform / Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<VideoPlatform>(
                  value: _selectedPlatform,
                  isExpanded: true,
                  items: VideoPlatform.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.displayName),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedPlatform = val);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              focusNode: _urlFocusNode,
              decoration: InputDecoration(
                labelText: 'Stream URL',
                hintText: 'https://...',
                border: const OutlineInputBorder(),
                suffixIcon: _isFetchingMetadata
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: PPLogoLoader(size: 20),
                        ),
                      )
                    : null,
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
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Optional)',
                hintText: 'https://...',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading,
              onSubmitted: (_) => _submit(saveToLibrary: false),
            ),
            if (_imageUrlController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: colorScheme.error, fontSize: 13),
              ),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: PPLogoLoader()),
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

