import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final resp = await http.get(Uri.parse('https://player.vimeo.com/video/76979871/config'));
  final data = json.decode(resp.body);
  print(data['request']['files']['dash']);
}
