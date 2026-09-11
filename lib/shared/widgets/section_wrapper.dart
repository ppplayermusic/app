import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'shimmer_placeholder.dart';
export 'shimmer_placeholder.dart' show SectionShimmer, ShimmerPlaceholder;

class SectionWrapper<T> extends StatelessWidget {
  final String title;
  final AsyncValue<List<T>> asyncValue;
  final Widget Function(List<T> data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onRetry;
  final double topPadding;
  final double bottomPadding;
  final Widget Function(String title)? headerBuilder;

  const SectionWrapper({
    super.key,
    required this.title,
    required this.asyncValue,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    this.onRetry,
    this.topPadding = 32.0,
    this.bottomPadding = 0.0,
    this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (headerBuilder != null)
                headerBuilder!(title)
              else
                _DefaultHeader(title: title),
              const SizedBox(height: 16),
              builder(data),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
      loading:
          () =>
              loadingWidget ??
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ShimmerPlaceholder(height: 120),
              ),
      error:
          (e, _) =>
              errorWidget ??
              _SectionErrorWidget(
                title: title,
                topPadding: topPadding,
                onRetry: onRetry,
              ),
    );
  }
}

/// A subtle error state shown when a section's data fetch fails.
class _SectionErrorWidget extends StatelessWidget {
  final String title;
  final double topPadding;
  final VoidCallback? onRetry;

  const _SectionErrorWidget({
    required this.title,
    required this.topPadding,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 20, right: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Could not load this section.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text('Retry', style: TextStyle(fontSize: 13)),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class _DefaultHeader extends StatelessWidget {
  final String title;
  const _DefaultHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
