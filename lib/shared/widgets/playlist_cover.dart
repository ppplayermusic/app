import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildCoverContent(),
      ),
    );
  }

  Widget _buildCoverContent() {
    if (images.isEmpty) {
      return Center(
        child: Icon(
          Icons.music_note,
          size: size * 0.4,
          color: Colors.white24,
        ),
      );
    }

    if (images.length < 4) {
      return _Image(url: images.first);
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
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey[900]),
      errorWidget: (context, url, e) => Container(color: Colors.grey[900]),
    );
  }
}
