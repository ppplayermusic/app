import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/providers/recent_searches_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
