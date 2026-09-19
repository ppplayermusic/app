import 'dart:ui';
import 'package:flutter/material.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/pp_image.dart';

enum PromotionType { horizontal, vertical }

class PromotionTile extends StatelessWidget {
  const PromotionTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.ctaText = 'Check it out',
    this.imageUrl,
    this.type = PromotionType.vertical,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String ctaText;
  final String? imageUrl;
  final PromotionType type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (type == PromotionType.horizontal) {
      return _buildHorizontalCard(context, colorScheme);
    }
    return _buildVerticalListTile(context, colorScheme);
  }

  Widget _buildVerticalListTile(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TactileTap(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              child: Row(
                children: [
                  _buildImageFrame(context, 64, 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSponsoredBadge(colorScheme),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCTA(context, colorScheme, isCompact: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: TactileTap(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageFrame(context, double.infinity, 100),
                  const SizedBox(height: 12),
                  _buildSponsoredBadge(colorScheme),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  _buildCTA(context, colorScheme, isCompact: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageFrame(BuildContext context, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null && imageUrl!.startsWith('http')
          ? PPImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.35),
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.stars_rounded,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.8),
                size: 32,
              ),
            ),
    );
  }

  Widget _buildSponsoredBadge(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.3)),
      ),
      child: Text(
        'SPONSORED',
        style: TextStyle(
          color: colorScheme.tertiary,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCTA(
    BuildContext context,
    ColorScheme colorScheme, {
    required bool isCompact,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        ctaText.toUpperCase(),
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: isCompact ? 11 : 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
