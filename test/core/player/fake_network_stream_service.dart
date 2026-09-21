import 'package:ppplayer/core/network_streams/network_stream_service.dart';

class FakeNetworkStreamService implements NetworkStreamService {
  @override
  Future<ExtractedStream?> extractDirectStreamUrl(String url) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ExtractedStream(url: url, httpHeaders: {});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
