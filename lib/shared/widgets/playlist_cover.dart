import 'package:flutter/material.dart';
import 'pp_image.dart';

class PlaylistCover extends StatelessWidget {
  const PlaylistCover({
    super.key,
    required this.images,
    this.size = 140,
    this.borderRadius = 8,
  });

  final List<String> images;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildCoverContent(context),
      ),
    );
  }

  Widget _buildCoverContent(BuildContext context) {
    if (images.isEmpty) {
      final double iconSize = size.isFinite ? size * 0.4 : 64.0;
      return Center(
        child: Icon(
          Icons.music_note,
          size: iconSize,
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        ),
      );
    }

    if (images.length < 3) {
      return _Image(url: images.first);
    }

    if (images.length == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [Expanded(child: _Image(url: images[0]))],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _Image(url: images[1])),
                Expanded(child: _Image(url: images[2])),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Image(url: images[0])),
              Expanded(child: _Image(url: images[1])),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Image(url: images[2])),
              Expanded(child: _Image(url: images[3])),
            ],
          ),
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return PPImage(imageUrl: url, fit: BoxFit.cover);
  }
}
