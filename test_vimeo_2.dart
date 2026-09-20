import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final resp = await http.get(Uri.parse('https://player.vimeo.com/video/226053498/config'));
  print(resp.statusCode);
  if (resp.statusCode == 200) {
    final data = json.decode(resp.body);
    final mp4s = data['request']?['files']?['progressive'] as List<dynamic>?;
    if (mp4s != null && mp4s.isNotEmpty) {
      print('Progressive: ${mp4s[0]['url']}');
    } else {
      print('No progressive');
    }
  }
}
