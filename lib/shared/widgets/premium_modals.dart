import 'package:flutter/material.dart';
import 'dart:ui';

/// A utility function to show a premium, glassmorphic modal dialog.
/// This matches the app's "Hero" design standard with deep blurs and
/// subtle haptic-ready interactions.
Future<T?> showPremiumModal<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  bool isDismissible = true,
}) {
  final theme = Theme.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: '',
    barrierColor: theme.colorScheme.scrim.withValues(alpha: 0.6), // Standardized M3 barrier
    transitionDuration: const Duration(milliseconds: 250),
    useRootNavigator: true, // Crucial for apps with ShellRoute (GoRouter)
    pageBuilder: (context, anim1, anim2) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.85), // Adaptive Background
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.scrim.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Builder( 
                  // Provides a dedicated context for the dialog's content.
                  // Use Navigator.of(dialogContext, rootNavigator: true).pop()
                  builder: (dialogContext) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 32),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );
}

