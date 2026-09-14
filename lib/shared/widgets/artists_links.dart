import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'tactile_buttons.dart';
import '../../core/models/track.dart';
import '../../features/local_library/local_artist_detail_screen.dart';

class ArtistsLinks extends StatelessWidget {
  const ArtistsLinks({
    super.key,
    required this.track,
    required this.style,
    this.toUpperCase = false,
  });

  final Track track;
  final TextStyle style;
  final bool toUpperCase;

  @override
  Widget build(BuildContext context) {
    if (track.artistName.isEmpty) return const SizedBox.shrink();

    final names = track.artistName.split(', ');
    final ids = track.artistId.split(',');

    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < names.length; i++) ...[
            if (i > 0) TextSpan(text: ', ', style: style),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: HoverText(
                text: toUpperCase ? names[i].toUpperCase() : names[i],
                style: style,
                onTap: () {
                  if (track.isLocal) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocalArtistDetailScreen(artistName: names[i]),
                      ),
                    );
                  } else {
                    final id =
                        i < ids.length ? ids[i] : (ids.isNotEmpty ? ids[0] : '');
                    if (id.isNotEmpty) {
                      context.push('/artist/$id');
                    }
                  }
                },
              ),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
