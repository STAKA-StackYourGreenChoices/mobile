import 'dart:typed_data';

import 'package:staka/core/analytics/event_tracker.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/sharing/share_image_api.dart';
import 'package:staka/core/sharing/share_target.dart';

/// Records each event instead of posting it.
class FakeEventTracker implements EventTracker {
  final List<({ShareChannel channel, String? cardId})> shareClicks = [];
  final List<({String gtin, bool known})> scans = [];

  @override
  void scanned(String gtin, {required bool known}) =>
      scans.add((gtin: gtin, known: known));

  @override
  void shareClicked(ShareChannel channel, {String? cardId}) =>
      shareClicks.add((channel: channel, cardId: cardId));
}

/// Answers image downloads from a script (default: an 8-byte "image").
class FakeShareImageApi implements ShareImageApi {
  new([List<Result<Uint8List>> images = const []]) : _images = [...images];

  final List<Result<Uint8List>> _images;

  /// Each image asked for, as its website address.
  final List<String> fetched = [];

  @override
  Future<Result<Uint8List>> fetch(
    ShareTarget target,
    ShareImageFormat format,
  ) async {
    fetched.add(target.imageUrl(format));
    return _images.isEmpty ? Ok(Uint8List(8)) : _images.removeAt(0);
  }
}

/// Stands in for `renderQrPng`, which can't run under the fake clock.
class FakeQrPng {
  final List<String> rendered = [];

  Future<Uint8List> call(String data) async {
    rendered.add(data);
    return Uint8List(8);
  }
}
