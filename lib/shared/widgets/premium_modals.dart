import 'package:flutter/material.dart';
import 'dart:ui';

/// A utility function to show a premium, glassmorphic modal dialog.
/// This matches the app's "Hero" design standard with deep blurs and
/// subtle haptic-ready interactions.
Future<T?> showPremiumModal<T>({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF161616).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
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
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );
}
