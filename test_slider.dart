import 'package:flutter/material.dart';

void main() {
  final slider = Slider(value: 0.5, secondaryTrackValue: 0.8, onChanged: (v){});
  print(slider.secondaryTrackValue);
}
