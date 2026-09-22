import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyResultsWidget extends StatelessWidget {
  const EmptyResultsWidget({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
                icon,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}
