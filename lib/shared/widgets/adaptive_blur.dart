import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/settings_provider.dart';

class AdaptiveBlur extends ConsumerWidget {
  const AdaptiveBlur({
    super.key,
    required this.child,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.fallbackOpacity = 0.08,
    this.borderRadius,
    this.enabled = true,
  });

  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double fallbackOpacity;
  final BorderRadius? borderRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceMode = ref.watch(settingsProvider).performanceMode;
    final isLowPerformance = performanceMode == PerformanceMode.powerSaver;

    // If explicitly disabled or in powerSaver mode, don't use BackdropFilter
    if (!enabled || isLowPerformance) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: fallbackOpacity),
          ),
          child: child,
        ),
      );
    }

    // Standard glassmorphic blur for high/balanced performance
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.02),
          ),
          child: child,
        ),
      ),
    );
  }
}
