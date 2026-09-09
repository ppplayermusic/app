import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final streamProvider = StreamProvider<int>((ref) async* {
  throw Exception('DB Crash');
});

final futureProvider = StreamProvider<int>((ref) async* {
  final value = await ref.watch(streamProvider.future);
  yield value + 1;
});

void main() async {
  final container = ProviderContainer();
  try {
    await container.read(futureProvider.future);
    print('futureProvider completed');
  } catch (e) {
    print('futureProvider threw: $e');
  }
}
