import 'package:flutter/material.dart';

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
    if (type == PromotionType.horizontal) {
      return _buildHorizontalCard(context);
    }
    return _buildVerticalListTile(context);
  }

  Widget _buildVerticalListTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildImageFrame(64, 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSponsoredBadge(),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildCTA(context, isCompact: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageFrame(double.infinity, 100),
              const SizedBox(height: 8),
              _buildSponsoredBadge(),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              _buildCTA(context, isCompact: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageFrame(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null && imageUrl!.startsWith('http')
          ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : Container(
              width: width,
              height: height,
              color: Colors.white.withValues(alpha: 0.1),
              child: const Icon(Icons.star, color: Colors.amber, size: 24),
            ),
    );
  }

  Widget _buildSponsoredBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: const Text(
        'SPONSORED',
        style: TextStyle(
          color: Colors.amber,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCTA(BuildContext context, {required bool isCompact}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ctaText.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: isCompact ? 10 : 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
