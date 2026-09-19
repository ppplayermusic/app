import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 8.0,
    this.margin,
    this.color,
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
            color:
                color ??
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1500.ms,
          curve: Curves.easeInOut,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        );
  }
}

class SectionShimmer extends StatelessWidget {
  final int count;
  final double height;
  final bool isHorizontal;
  final bool isGrid;
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;

  const SectionShimmer({
    super.key,
    this.count = 5,
    this.height = 200,
    this.isHorizontal = true,
    this.isGrid = false,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: count,
        itemBuilder: (_, i) => const ShimmerPlaceholder(
          borderRadius: 16,
        ).animate(delay: (i * 30).ms).fadeIn(duration: 400.ms),
      );
    }

    if (isHorizontal) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: count,
          separatorBuilder: (_, _) => SizedBox(width: spacing),
          itemBuilder: (_, i) => ShimmerPlaceholder.card(
            width: 160,
            height: height,
          ).animate(delay: (i * 30).ms).fadeIn(duration: 400.ms),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: (_, i) =>
            ShimmerPlaceholder.tile(height: height == 200 ? 72 : height)
                .animate(delay: (i * 30).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.1, end: 0),
      );
    }
  }
}

class SliverSectionShimmer extends StatelessWidget {
  final int count;
  final bool isGrid;
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;
  final double tileHeight;
  final double borderRadius;
  final bool isCircular;

  const SliverSectionShimmer({
    super.key,
    this.count = 6,
    this.isGrid = false,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
    this.childAspectRatio = 0.75,
    this.tileHeight = 72,
    this.borderRadius = 20,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => const ShimmerPlaceholder(borderRadius: 20)
                .animate(delay: (i * 40).ms)
                .fadeIn(duration: 500.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                ),
            childCount: count,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) =>
              Padding(
                    padding: EdgeInsets.only(bottom: spacing),
                    child: Row(
                      children: [
                        ShimmerPlaceholder(
                          width: tileHeight,
                          height: tileHeight,
                          borderRadius: isCircular ? 100 : borderRadius,
                        ),
                        if (!isCircular) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ShimmerPlaceholder(
                                  height: 16,
                                  width: 140,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 8),
                                const ShimmerPlaceholder(
                                  height: 12,
                                  width: 80,
                                  borderRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ShimmerPlaceholder(
                                  height: 18,
                                  width: 160,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 6),
                                const ShimmerPlaceholder(
                                  height: 14,
                                  width: 60,
                                  borderRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                  .animate(delay: (i * 40).ms)
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: 0.1, end: 0),
          childCount: count,
        ),
      ),
    );
  }
}

class AlbumDetailsShimmer extends StatelessWidget {
  const AlbumDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            child: Column(
              children: [
                const ShimmerPlaceholder(
                  height: 260,
                  width: 260,
                  borderRadius: 24,
                ).animate().scale(
                  duration: 600.ms,
                  begin: const Offset(0.9, 0.9),
                ),
                const SizedBox(height: 48),
                const ShimmerPlaceholder(
                  height: 40,
                  width: 240,
                  borderRadius: 12,
                ),
                const SizedBox(height: 16),
                const ShimmerPlaceholder(
                  height: 16,
                  width: 120,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const ShimmerPlaceholder(
                  width: 44,
                  height: 44,
                  borderRadius: 22,
                ),
                const SizedBox(width: 20),
                const ShimmerPlaceholder(
                  width: 44,
                  height: 44,
                  borderRadius: 22,
                ),
                const Spacer(),
                const ShimmerPlaceholder(
                  width: 68,
                  height: 68,
                  borderRadius: 34,
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          ),
        ),
        const SliverSectionShimmer(count: 8, spacing: 12, borderRadius: 16),
      ],
    );
  }
}

class ArtistDetailsShimmer extends StatelessWidget {
  const ArtistDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const ShimmerPlaceholder(
                            height: 56,
                            width: 280,
                            borderRadius: 16,
                          )
                          .animate()
                          .fadeIn(delay: 300.ms)
                          .slideY(begin: 0.5, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const ShimmerPlaceholder(
                      width: 100,
                      height: 40,
                      borderRadius: 20,
                    ),
                    const SizedBox(width: 12),
                    const ShimmerPlaceholder(
                      width: 100,
                      height: 40,
                      borderRadius: 20,
                    ),
                  ],
                ),
                const ShimmerPlaceholder(
                  width: 72,
                  height: 72,
                  borderRadius: 36,
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 16),
            child: ShimmerPlaceholder(height: 20, width: 120, borderRadius: 4),
          ),
        ),
        const SliverSectionShimmer(count: 5, spacing: 12, borderRadius: 16),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 16, top: 32, bottom: 16),
            child: ShimmerPlaceholder(height: 20, width: 100, borderRadius: 4),
          ),
        ),
        const SliverToBoxAdapter(child: SectionShimmer(height: 220)),
      ],
    );
  }
}
