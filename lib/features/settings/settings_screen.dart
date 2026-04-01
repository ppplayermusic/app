import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/spotify_client.dart';
import '../../core/services/settings_provider.dart';

final availableMarketsProvider = FutureProvider<List<String>>((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getAvailableMarkets();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Content Language / Country'),
            subtitle: Text('Current market: ${settings.selectedCountry}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCountryPicker(context, ref),
          ),
          SwitchListTile(
            title: const Text('Show Video Player'),
            subtitle: const Text('Use YouTube player when available'),
            value: settings.showVideo,
            onChanged: (v) => ref.read(settingsProvider.notifier).toggleVideo(),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final markets = ref.watch(availableMarketsProvider);
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Market',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: markets.when(
                      data: (list) {
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final code = list[index];
                            return ListTile(
                              title: Text(code),
                              onTap: () {
                                ref.read(settingsProvider.notifier).setCountry(code);
                                Navigator.pop(context);
                              },
                              trailing: code == ref.watch(selectedCountryProvider)
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
