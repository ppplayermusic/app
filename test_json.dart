import 'dart:convert';
void main() {
  final map = {'origin': 'https://www.youtube.com', 'autoplay': 1};
  print(map.toString());
  print(jsonEncode(map));
}
