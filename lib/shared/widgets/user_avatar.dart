import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/services/settings_provider.dart';
import '../../core/theme/app_theme.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.settings,
    this.size = 32,
    this.fontSize = 12,
  });

  final SettingsState settings;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (settings.userAvatarBase64 != null &&
        settings.userAvatarBase64!.isNotEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Image.memory(
            base64Decode(settings.userAvatarBase64!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (settings.userName.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.themeColors[settings.userAvatarColorIndex],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          settings.userName
              .trim()
              .split(RegExp(r'\s+'))
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .take(2)
              .join(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
