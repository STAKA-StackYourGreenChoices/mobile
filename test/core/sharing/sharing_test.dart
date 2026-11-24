import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/analytics/event_tracker.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/qr_png.dart';
import 'package:staka/core/sharing/share_image_api.dart';
import 'package:staka/core/sharing/share_target.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

const _tag = ShareTarget(
  kind: ShareKind.tag,
  slug: 'abc123',
  cardId: 'c1',
  webAppUrl: 'http://web.test/',
);
const _wardrobe = ShareTarget(
  kind: ShareKind.wardrobe,
  slug: 'w4rdr0be',
  webAppUrl: 'http://web.test',
);

FakeReply _png() =>
    (_) async => ResponseBody.fromBytes(
      onePixelPng,
      200,
      headers: {
        Headers.contentTypeHeader: ['image/png'],
      },
    );

void main() {
  group('ShareTarget', () {
    test('links carry the channel the API counts', () {
      expect(_tag.url, 'http://web.test/t/abc123');
      expect(_tag.linkFor(ShareChannel.whatsapp), '$_tagUrl?ch=whatsapp');
      expect(
        _wardrobe.linkFor(ShareChannel.qr),
        'http://web.test/w/w4rdr0be?ch=qr',
      );
      expect(ShareChannel.values.map((c) => c.apiName), [
        'whatsapp',
        'instagram',
        'facebook',
        'x',
        'linkedin',
        'copy',
        'qr',
        'embed',
        'other',
      ]);
    });

    test('image addresses and file names per format', () {
      expect(
        _tag.imageUrl(ShareImageFormat.story),
        'http://web.test/t/abc123/story',
      );
      expect(
        _wardrobe.imageUrl(ShareImageFormat.square),
        'http://web.test/w/w4rdr0be/square',
      );
      expect(
        _tag.imageFileName(ShareImageFormat.square),
        'staka-abc123-square.png',
      );
      expect(_wardrobe.qrFileName, 'staka-w4rdr0be-qr.png');
    });
  });

  // Found on a phone in V1: the provider is disposed as soon as a
  // controller's read finishes; a client of its own would be closed then,
  // and the image request would fail before it was sent.
  test('images still download after the provider is disposed', () async {
    final web = FakeHttpAdapter([_png(), _png()]);
    final container = ProviderContainer(
      overrides: [
        webDioProvider.overrideWithValue(Dio()..httpClientAdapter = web),
      ],
    );
    addTearDown(container.dispose);

    final api = container.read(shareImageApiProvider);
    await container.pump(); // nothing watches it: it is disposed here

    final story = await api.fetch(_tag, ShareImageFormat.story);
    final square = await api.fetch(_wardrobe, ShareImageFormat.square);

    expect((story as Ok<Uint8List>).value, onePixelPng);
    expect(square, isA<Ok<Uint8List>>());
    expect(web.requests.map((r) => r.uri.path), [
      '/t/abc123/story',
      '/w/w4rdr0be/square',
    ]);
  });

  group('ApiEventTracker', () {
    test('posts a share click with its card and channel', () async {
      final adapter = FakeHttpAdapter([json(202, null), json(202, null)]);
      ApiEventTracker(
          Dio(BaseOptions(baseUrl: 'http://api.test'))
            ..httpClientAdapter = adapter,
        )
        ..shareClicked(ShareChannel.whatsapp, cardId: 'c1')
        ..shareClicked(ShareChannel.qr);
      await pumpEventQueue();

      expect(adapter.requests.map((r) => r.uri.path), ['/events', '/events']);
      expect(adapter.requests.map((r) => r.data), [
        {'type': 'SHARE_CLICKED', 'cardId': 'c1', 'channel': 'whatsapp'},
        {'type': 'SHARE_CLICKED', 'channel': 'qr'},
      ]);
    });

    test('posts scans, known and unknown, with the code', () async {
      final adapter = FakeHttpAdapter([json(202, null), json(202, null)]);
      ApiEventTracker(
          Dio(BaseOptions(baseUrl: 'http://api.test'))
            ..httpClientAdapter = adapter,
        )
        ..scanned('08901234500019', known: true)
        ..scanned('4006381333931', known: false);
      await pumpEventQueue();

      expect(adapter.requests.map((r) => r.data), [
        {'type': 'SCAN', 'gtin': '08901234500019'},
        {'type': 'SCAN_UNKNOWN', 'gtin': '4006381333931'},
      ]);
    });

    test('a failed event is dropped quietly', () async {
      final adapter = FakeHttpAdapter([json(500, null)]);
      ApiEventTracker(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ).shareClicked(ShareChannel.copy);

      await pumpEventQueue();

      expect(adapter.requests, hasLength(1));
    });
  });

  testWidgets('the QR code renders as a PNG', (tester) async {
    final png = await tester.runAsync(
      () => renderQrPng('http://web.test/t/abc123?ch=qr', size: 200),
    );

    // The PNG signature.
    expect(png!.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
  });
}

const _tagUrl = 'http://web.test/t/abc123';
