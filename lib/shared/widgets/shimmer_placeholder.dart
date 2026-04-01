import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 8.0,
    this.margin,
  });

  /// A preset for a standard rectangular card (e.g., for a grid or horizontal list)
  factory ShimmerPlaceholder.card({
    double width = 160,
    double height = 220,
    double borderRadius = 16,
    EdgeInsetsGeometry? margin,
  }) {
    return ShimmerPlaceholder(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  /// A preset for a track tile (thin and wide)
  factory ShimmerPlaceholder.tile({
    double height = 72,
    double borderRadius = 12,
    EdgeInsetsGeometry? margin,
  }) {
    return ShimmerPlaceholder(
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.05),
        );
  }
}

class SectionShimmer extends StatelessWidget {
  final int count;
  final double height;
  final bool isHorizontal;
  final double spacing;

  const SectionShimmer({
    super.key,
    this.count = 5,
    this.height = 200,
    this.isHorizontal = true,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: count,
          separatorBuilder: (_, _) => SizedBox(width: spacing),
          itemBuilder: (_, _) => ShimmerPlaceholder.card(
            height: height,
          ),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: count,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: (_, _) => ShimmerPlaceholder.tile(),
      );
    }
  }
}
