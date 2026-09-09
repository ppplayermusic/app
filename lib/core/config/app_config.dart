class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'PPPLAYER_API_BASE_URL',
    defaultValue: 'https://ppplayer.com',
  );
}
