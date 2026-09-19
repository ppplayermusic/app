import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/cache/image_cache_manager.dart';

class PPImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const PPImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget(context);
    }

    Widget image;
    if (imageUrl!.startsWith('asset:')) {
      final assetPath = imageUrl!.substring(6); // Remove 'asset:'
      image = Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorWidget(context),
      );
    } else if (imageUrl!.startsWith('/') || imageUrl!.startsWith('file://')) {
      final path = imageUrl!.startsWith('file://') ? imageUrl!.replaceFirst('file://', '') : imageUrl!;
      image = Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorWidget(context),
      );
    } else {
      image = CachedNetworkImage(
        cacheManager: PPImageCacheManager.instance,
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder:
            (context, url) => placeholder ?? _buildPlaceholder(context),
        errorWidget:
            (context, url, error) => errorWidget ?? _buildErrorWidget(context),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      child: Icon(
        Icons.music_note_rounded,
        color: Theme.of(
          context,
        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
      ),
    );
  }

  static ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/images/placeholder.png');
    }

    if (imageUrl.startsWith('asset:')) {
      return AssetImage(imageUrl.substring(6));
    } else if (imageUrl.startsWith('/') || imageUrl.startsWith('file://')) {
      final path = imageUrl.startsWith('file://') ? imageUrl.replaceFirst('file://', '') : imageUrl;
      return FileImage(File(path));
    } else {
      return CachedNetworkImageProvider(
        imageUrl,
        cacheManager: PPImageCacheManager.instance,
      );
    }
  }
}
