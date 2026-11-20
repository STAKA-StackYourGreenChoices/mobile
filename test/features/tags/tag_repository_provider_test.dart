import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  // Found on a phone: the repository provider is disposed as soon as a
  // controller's read finishes, and it used to close its own website
  // client then, so the story image request failed before it was sent.
  test(
    'the story image still downloads after the provider is disposed',
    () async {
      final web = FakeHttpAdapter([
        (_) async => ResponseBody.fromBytes(
          onePixelPng,
          200,
          headers: {
            Headers.contentTypeHeader: ['image/png'],
          },
        ),
      ]);
      final container = ProviderContainer(
        overrides: [
          webDioProvider.overrideWithValue(Dio()..httpClientAdapter = web),
          dioProvider.overrideWithValue(
            Dio()..httpClientAdapter = FakeHttpAdapter([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(tagRepositoryProvider);
      await container.pump(); // nothing watches it: it is disposed here

      final result = await repository.fetchStoryImage('cFLecSqZ6pbg');

      expect((result as Ok).value, onePixelPng);
      expect(web.requests.single.uri.path, '/t/cFLecSqZ6pbg/story');
    },
  );
}
