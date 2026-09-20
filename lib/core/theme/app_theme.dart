import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Premium Seed Colors
  static const Color crimsonRed = Color(0xFFFF3E3E);
  static const Color electricViolet = Color(0xFF8B5CF6);
  static const Color oceanBlue = Color(0xFF0EA5E9);
  static const Color emeraldGarden = Color(0xFF10B981);
  static const Color sunsetOrange = Color(0xFFF97316);
  static const Color cyberTeal = Color(0xFF14B8A6);
  static const Color royalPurple = Color(0xFFD946EF);
  static const Color solarGold = Color(0xFFEAB308);
  static const Color neonLime = Color(0xFF84CC16);
  static const Color rosePink = Color(0xFFF43F5E);
  static const Color miamiDusk = Color(0xFFFF2D55);
  static const Color arcticIce = Color(0xFF22D3EE);
  static const Color desertFire = Color(0xFFFB923C);
  static const Color jungleMoss = Color(0xFF65A30D);
  static const Color nebulaDream = Color(0xFF6366F1);

  static const List<Color> themeColors = [
    crimsonRed,
    electricViolet,
    oceanBlue,
    emeraldGarden,
    sunsetOrange,
    cyberTeal,
    royalPurple,
    solarGold,
    neonLime,
    rosePink,
    miamiDusk,
    arcticIce,
    desertFire,
    jungleMoss,
    nebulaDream,
  ];

  static const List<String> themeNames = [
    'Crimson Red',
    'Electric Violet',
    'Deep Ocean',
    'Emerald Garden',
    'Sunset Orange',
    'Cyber Teal',
    'Royal Purple',
    'Solar Gold',
    'Neon Lime',
    'Rose Pink',
    'Miami Dusk',
    'Arctic Ice',
    'Desert Fire',
    'Jungle Moss',
    'Nebula Dream',
  ];

  static const _surfaceColor = Color(0xFF121212);
  static const _surfaceHoverColor = Color(0xFF1A1A1A);
  static const _onSurfaceColor = Color(0xFFFFFFFF);
  static const _onSurfaceVariantColor = Color(0xFFB3B3B3);
  static const _outlineColor = Color(0xFF6A6A6A);
  static const _surface3Color = Color(0xFF3A3A3A);

  static ThemeData dark({Color primaryColor = crimsonRed}) {
    final base = ThemeData.dark(useMaterial3: true);

    // Generate harmonious color scheme from seed
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      // Let the color scheme generator handle surfaces so they are tinted
      outline: _outlineColor,
      onSurface: _onSurfaceColor,
      onSurfaceVariant: _onSurfaceVariantColor,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: _onSurfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedItemColor: _onSurfaceColor,
        unselectedItemColor: _onSurfaceVariantColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceColor,
        indicatorColor: primaryColor.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: _onSurfaceColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: _onSurfaceVariantColor, fontSize: 12);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceHoverColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: _outlineColor),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        thumbColor: _onSurfaceColor,
        inactiveTrackColor: _surface3Color,
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: _onSurfaceColor,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: _onSurfaceColor,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: _onSurfaceColor,
      ),
      bodyMedium: base.bodyMedium?.copyWith(color: _onSurfaceVariantColor),
      labelSmall: base.labelSmall?.copyWith(
        color: _outlineColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
