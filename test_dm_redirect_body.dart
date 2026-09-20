import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final metaResp = await http.get(Uri.parse('https://www.dailymotion.com/player/metadata/video/xb9u9r6'));
  final data = json.decode(metaResp.body);
  final url = data['qualities']['auto'][0]['url'];
  
  final cookies = metaResp.headers['set-cookie'];
  
  final client = http.Client();
  final req = http.Request('GET', Uri.parse(url));
  if (cookies != null) {
    req.headers['Cookie'] = cookies.split(',').map((c) => c.split(';')[0]).join('; ');
  }
  
  final finalResp = await client.send(req);
  final body = await finalResp.stream.bytesToString();
  print('Body: ${body.substring(0, 100)}');
}
