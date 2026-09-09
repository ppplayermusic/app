import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../services/secure_credentials_service.dart';
import '../services/settings_provider.dart';

class SpotifyAuthException implements Exception {
  final String message;
  final Object? originalError;
  SpotifyAuthException(this.message, [this.originalError]);

  @override
  String toString() => 'SpotifyAuthException: $message';
}

abstract class SpotifyAuthHandler {
  Future<String> getAccessToken();
  void invalidate();
}

class PPPlayerSpotifyAuth implements SpotifyAuthHandler {
  final Dio _dio;
  String? _accessToken;
  DateTime? _tokenExpiry;
  Future<void>? _pendingTokenRequest;

  PPPlayerSpotifyAuth(this._dio);

  @override
  void invalidate() {
    _accessToken = null;
    _tokenExpiry = null;
    _pendingTokenRequest = null;
  }

  @override
  Future<String> getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    if (_pendingTokenRequest != null) {
      await _pendingTokenRequest;
      return _accessToken!;
    }

    _pendingTokenRequest = _performTokenRequest();
    try {
      await _pendingTokenRequest;
      return _accessToken!;
    } catch (e) {
      _pendingTokenRequest = null;
      rethrow;
    }
  }

  Future<void> _performTokenRequest() async {
    final tokenUrl = '${AppConfig.apiBaseUrl}/api/spotify/token';

    try {
      final response = await _dio.post(tokenUrl);

      _accessToken = response.data['access_token'] as String;
      final expiresIn = response.data['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
    } on DioException catch (e) {
      debugPrint('DioException in _performTokenRequest: ${e.message} ${e.response?.statusCode} ${e.response?.data}');
      throw SpotifyAuthException('Failed to acquire PPPlayer token. Token server may be down.', e);
    } catch (e) {
      debugPrint('Unexpected error in _performTokenRequest: $e');
      throw SpotifyAuthException('Unexpected error acquiring token: $e', e);
    }
  }
}

class CustomSpotifyAuth implements SpotifyAuthHandler {
  final Dio _dio;
  final SecureCredentialsService _secureStorage;
  String? _accessToken;
  DateTime? _tokenExpiry;
  Future<void>? _pendingTokenRequest;

  CustomSpotifyAuth(this._dio, this._secureStorage);

  @override
  void invalidate() {
    _accessToken = null;
    _tokenExpiry = null;
    _pendingTokenRequest = null;
  }

  @override
  Future<String> getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    if (_pendingTokenRequest != null) {
      await _pendingTokenRequest;
      return _accessToken!;
    }

    _pendingTokenRequest = _performTokenRequest();
    try {
      await _pendingTokenRequest;
      return _accessToken!;
    } catch (e) {
      _pendingTokenRequest = null;
      rethrow;
    }
  }

  Future<void> _performTokenRequest() async {
    final clientId = await _secureStorage.readSpotifyClientId();
    final clientSecret = await _secureStorage.readSpotifyClientSecret();

    if (clientId == null || clientId.isEmpty || clientSecret == null || clientSecret.isEmpty) {
      throw SpotifyAuthException('Missing Custom Spotify Credentials. Please configure them in Settings.');
    }

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    
    try {
      final response = await _dio.post(
        'https://accounts.spotify.com/api/token',
        data: 'grant_type=client_credentials',
        options: Options(
          headers: {
            'Authorization': 'Basic $credentials',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      _accessToken = response.data['access_token'] as String;
      final expiresIn = response.data['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw SpotifyAuthException('Invalid Custom Spotify Credentials.', e);
      }
      throw SpotifyAuthException('Failed to acquire custom token. Network error.', e);
    } catch (e) {
      throw SpotifyAuthException('Unexpected error acquiring token: $e', e);
    }
  }
}

final ppplayerSpotifyAuthProvider = Provider.family<PPPlayerSpotifyAuth, Dio>((ref, dio) {
  return PPPlayerSpotifyAuth(dio);
});

final customSpotifyAuthProvider = Provider.family<CustomSpotifyAuth, Dio>((ref, dio) {
  final secureStorage = ref.watch(secureCredentialsProvider);
  return CustomSpotifyAuth(dio, secureStorage);
});

final spotifyAuthHandlerProvider = Provider.family<SpotifyAuthHandler, Dio>((ref, dio) {
  final providerType = ref.watch(settingsProvider.select((s) => s.spotifyProvider));
  if (providerType == SpotifyProviderType.custom) {
    return ref.watch(customSpotifyAuthProvider(dio));
  } else {
    return ref.watch(ppplayerSpotifyAuthProvider(dio));
  }
});
