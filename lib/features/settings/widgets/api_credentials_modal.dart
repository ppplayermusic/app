import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/secure_credentials_service.dart';
import '../../../core/services/settings_provider.dart';
import '../../../shared/widgets/premium_modals.dart';
import '../../../shared/widgets/tactile_buttons.dart';

void showSpotifyCredentialsModal(BuildContext context) {
  showPremiumModal(
    context: context,
    title: 'Spotify Credentials',
    child: const _SpotifyCredentialsForm(),
  );
}

void showYoutubeCredentialsModal(BuildContext context) {
  showPremiumModal(
    context: context,
    title: 'YouTube Credentials',
    child: const _YoutubeCredentialsForm(),
  );
}

class _SpotifyCredentialsForm extends ConsumerStatefulWidget {
  const _SpotifyCredentialsForm();

  @override
  ConsumerState<_SpotifyCredentialsForm> createState() => _SpotifyCredentialsFormState();
}

class _SpotifyCredentialsFormState extends ConsumerState<_SpotifyCredentialsForm> {
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final storage = ref.read(secureCredentialsProvider);
    final clientId = await storage.readSpotifyClientId();
    final clientSecret = await storage.readSpotifyClientSecret();
    if (mounted) {
      setState(() {
        _clientIdController.text = clientId ?? '';
        _clientSecretController.text = clientSecret ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCredentials() async {
    setState(() => _isSaving = true);
    final storage = ref.read(secureCredentialsProvider);
    await storage.writeSpotifyCredentials(
      clientId: _clientIdController.text.trim(),
      clientSecret: _clientSecretController.text.trim(),
    );
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);
    final isCustom = settings.spotifyProvider == SpotifyProviderType.custom;

    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Use Custom API Key', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
            Switch.adaptive(
              value: isCustom,
              activeTrackColor: colorScheme.primary,
              onChanged: (v) {
                ref.read(settingsProvider.notifier).setSpotifyProvider(
                  v ? SpotifyProviderType.custom : SpotifyProviderType.ppplayer,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Your credentials are stored locally on this device in the secure keychain and are never sent to PPPlayer.',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _clientIdController,
          enabled: isCustom,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Client ID',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _clientSecretController,
          enabled: isCustom,
          obscureText: true,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Client Secret',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        TactileTap(
          onTap: isCustom && !_isSaving ? _saveCredentials : null,
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCustom ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _isSaving 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2))
              : Text('Save Credentials', style: TextStyle(
                  color: isCustom ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.5), 
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
  }
}

class _YoutubeCredentialsForm extends ConsumerStatefulWidget {
  const _YoutubeCredentialsForm();

  @override
  ConsumerState<_YoutubeCredentialsForm> createState() => _YoutubeCredentialsFormState();
}

class _YoutubeCredentialsFormState extends ConsumerState<_YoutubeCredentialsForm> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final storage = ref.read(secureCredentialsProvider);
    final apiKey = await storage.readYoutubeApiKey();
    if (mounted) {
      setState(() {
        _apiKeyController.text = apiKey ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCredentials() async {
    setState(() => _isSaving = true);
    final storage = ref.read(secureCredentialsProvider);
    await storage.writeYoutubeApiKey(_apiKeyController.text.trim());
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);
    final isScraping = settings.youtubeSearchMethod == YoutubeSearchMethod.scraping;
    final isCustomApi = settings.youtubeApiProvider == YoutubeApiProviderType.custom;

    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Search Strategy', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        SegmentedButton<YoutubeSearchMethod>(
          segments: const [
            ButtonSegment(value: YoutubeSearchMethod.scraping, label: Text('Scraping')),
            ButtonSegment(value: YoutubeSearchMethod.api, label: Text('API')),
          ],
          selected: {settings.youtubeSearchMethod},
          onSelectionChanged: (set) {
            ref.read(settingsProvider.notifier).setYoutubeSearchMethod(set.first);
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: colorScheme.surface,
            selectedForegroundColor: colorScheme.onPrimary,
            selectedBackgroundColor: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        AnimatedCrossFade(
          firstChild: Text(
            'Scraping uses no API quota and requires no credentials, but can be slightly slower or less reliable.',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Use Custom API Key', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                  Switch.adaptive(
                    value: isCustomApi,
                    activeTrackColor: colorScheme.primary,
                    onChanged: (v) {
                      ref.read(settingsProvider.notifier).setYoutubeApiProvider(
                        v ? YoutubeApiProviderType.custom : YoutubeApiProviderType.ppplayer,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Your credentials are stored locally on this device in the secure keychain and are never sent to PPPlayer.',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _apiKeyController,
                enabled: isCustomApi,
                obscureText: true,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'YouTube Data API v3 Key',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              TactileTap(
                onTap: isCustomApi && !_isSaving ? _saveCredentials : null,
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCustomApi ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isSaving 
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2))
                    : Text('Save Credentials', style: TextStyle(
                        color: isCustomApi ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.5), 
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          ),
          crossFadeState: isScraping ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: 300.ms,
          sizeCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
}
