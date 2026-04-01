import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFFFF4B4B); // Original red branding
  static const _bgColor = Color(0xFF0A0A0A);
  static const _surfaceColor = Color(0xFF1A1A1A);
  static const _surface2Color = Color(0xFF242424);

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: _bgColor,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        onPrimary: Colors.black,
        secondary: Color(0xFF1ED760),
        surface: _surfaceColor,
        surfaceContainerHighest: _surface2Color,
        onSurface: Colors.white,
        onSurfaceVariant: Color(0xFFB3B3B3),
        outline: Color(0xFF3A3A3A),
      ),
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF121212),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFFB3B3B3),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface2Color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Color(0xFF6A6A6A)),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: _primaryColor,
        thumbColor: Colors.white,
        inactiveTrackColor: Color(0xFF3A3A3A),
        trackHeight: 3,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.white,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: const Color(0xFFB3B3B3),
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: const Color(0xFF6A6A6A),
        letterSpacing: 0.5,
      ),
    );
  }
}
