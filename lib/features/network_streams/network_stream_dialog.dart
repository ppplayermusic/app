import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/network_streams/network_stream_service.dart';

void showNetworkStreamDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const NetworkStreamDialog(),
  );
}

class NetworkStreamDialog extends ConsumerStatefulWidget {
  const NetworkStreamDialog({super.key});

  @override
  ConsumerState<NetworkStreamDialog> createState() => _NetworkStreamDialogState();
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

  Future<void> _submit() async {
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
      final channels = await service.analyzeAndParseUrl(url, client: _activeClient);
      
      if (channels.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'No channels found in stream/playlist.';
          _isLoading = false;
        });
        return;
      }

      await service.savePlaylist(title, url, channels);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${channels.length} channels from stream!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
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
              onSubmitted: (_) => _submit(),
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
              onSubmitted: (_) => _submit(),
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
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: const Text('Open'),
        ),
      ],
    );
  }
}
