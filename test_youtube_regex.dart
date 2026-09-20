void main() {
  final links = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=60s',
  ];

  for (final url in links) {
    String? finalId;
    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?(?:.*&)?v=([_\-a-zA-Z0-9]{11})(?:&.*)?$"),
      RegExp(r"^https:\/\/(?:music\.)?youtube\.com\/watch\?(?:.*&)?v=([_\-a-zA-Z0-9]{11})(?:&.*)?$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11})(?:\?.*)?$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11})(?:\?.*)?$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11})(?:\?.*)?$")
    ]) {
      final match = exp.firstMatch(url.trim());
      if (match != null && match.groupCount >= 1) {
        finalId = match.group(1)!;
        break;
      }
    }
    print('Url: $url => Id: $finalId');
  }
}
