import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCredentialsService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    // Apple specific options: ensure credentials are only available when device is unlocked
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.unlocked),
  );

  static const _spotifyClientIdKey = 'spotify_client_id';
  static const _spotifyClientSecretKey = 'spotify_client_secret';
  static const _youtubeApiKeyKey = 'youtube_api_key';

  // --- Spotify ---

  Future<String?> readSpotifyClientId() async {
    return await _storage.read(key: _spotifyClientIdKey);
  }

  Future<String?> readSpotifyClientSecret() async {
    return await _storage.read(key: _spotifyClientSecretKey);
  }

  Future<void> writeSpotifyCredentials({
    required String clientId,
    required String clientSecret,
  }) async {
    await _storage.write(key: _spotifyClientIdKey, value: clientId);
    await _storage.write(key: _spotifyClientSecretKey, value: clientSecret);
  }

  Future<void> clearSpotifyCredentials() async {
    await _storage.delete(key: _spotifyClientIdKey);
    await _storage.delete(key: _spotifyClientSecretKey);
  }

  // --- YouTube ---

  Future<String?> readYoutubeApiKey() async {
    return await _storage.read(key: _youtubeApiKeyKey);
  }

  Future<void> writeYoutubeApiKey(String apiKey) async {
    await _storage.write(key: _youtubeApiKeyKey, value: apiKey);
  }

  Future<void> clearYoutubeApiKey() async {
    await _storage.delete(key: _youtubeApiKeyKey);
  }
}

final secureCredentialsProvider = Provider<SecureCredentialsService>((ref) {
  return SecureCredentialsService();
});
