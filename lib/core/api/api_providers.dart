import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const bool _kDebugMode = !bool.fromEnvironment('dart.vm.product');

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  if (_kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  return dio;
});
