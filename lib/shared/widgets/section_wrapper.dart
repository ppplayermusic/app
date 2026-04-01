import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'shimmer_placeholder.dart';

class SectionWrapper<T> extends StatelessWidget {
  final String title;
  final AsyncValue<List<T>> asyncValue;
  final Widget Function(List<T> data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
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
      loading: () =>
          loadingWidget ??
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerPlaceholder(height: 120),
          ),
      error: (e, _) => errorWidget ?? const SizedBox.shrink(),
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
              color: const Color(0xFF1DB954),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
