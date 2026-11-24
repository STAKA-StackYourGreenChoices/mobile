import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/analytics/event_tracker.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/sharing/qr_png.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/core/sharing/share_image_api.dart';
import 'package:staka/core/sharing/share_target.dart';

part 'share_channels_controller.g.dart';

/// The image being prepared, one at a time.
enum SharePreparing { none, instagram, story, square, qr }

@immutable
class ShareChannelsState {
  const new({this.preparing = SharePreparing.none, this.failure});

  final SharePreparing preparing;

  /// The last image that couldn't be prepared; shown once.
  final Failure? failure;
}

/// The channel row and image formats of a share link (V2-4), for a tag or
/// the whole wardrobe. Every share adds `?ch=` and reports the click.
@riverpod
class ShareChannelsController extends _$ShareChannelsController {
  @override
  ShareChannelsState build(ShareTarget target) => const ShareChannelsState();

  ShareActions get _actions => ref.read(shareActionsProvider);

  void _track(ShareChannel channel) => ref
      .read(eventTrackerProvider)
      .shareClicked(channel, cardId: target.cardId);

  Future<void> copy() async {
    _track(ShareChannel.copy);
    await _actions.copy(target.linkFor(ShareChannel.copy));
  }

  /// False when nothing could open WhatsApp's link.
  Future<bool> whatsApp(String text) {
    _track(ShareChannel.whatsapp);
    final message = '$text ${target.linkFor(ShareChannel.whatsapp)}';
    return _actions.open('https://wa.me/?text=${Uri.encodeComponent(message)}');
  }

  /// The system share sheet: the app can't tell where it went.
  Future<void> more({
    required String text,
    required String subject,
    Rect? origin,
  }) {
    _track(ShareChannel.other);
    return _actions.shareLink(
      url: target.linkFor(ShareChannel.other),
      text: text,
      subject: subject,
      origin: origin,
    );
  }

  /// The QR code was shown; the click counts then, like the website's.
  void qrShown() => _track(ShareChannel.qr);

  /// Instagram story: the 9:16 image, handed to the share sheet.
  Future<void> instagram({required String text, Rect? origin}) => _image(
    SharePreparing.instagram,
    ShareImageFormat.story,
    ShareChannel.instagram,
    text: text,
    origin: origin,
  );

  /// "Story (9:16)" or "Post (1:1)".
  Future<void> image(
    ShareImageFormat format, {
    required String text,
    Rect? origin,
  }) => _image(
    switch (format) {
      ShareImageFormat.story => SharePreparing.story,
      ShareImageFormat.square => SharePreparing.square,
    },
    format,
    ShareChannel.other,
    text: text,
    origin: origin,
  );

  /// The QR code as a PNG, to save or send from the share sheet.
  Future<void> saveQr({Rect? origin}) => _prepare(
    SharePreparing.qr,
    () async => Ok(
      await ref.read(qrPngRendererProvider)(target.linkFor(ShareChannel.qr)),
    ),
    (png) => _actions.shareImage(
      png: png,
      fileName: target.qrFileName,
      text: target.linkFor(ShareChannel.qr),
      origin: origin,
    ),
  );

  Future<void> _image(
    SharePreparing preparing,
    ShareImageFormat format,
    ShareChannel channel, {
    required String text,
    Rect? origin,
  }) => _prepare(
    preparing,
    () => ref.read(shareImageApiProvider).fetch(target, format),
    (png) {
      _track(channel);
      return _actions.shareImage(
        png: png,
        fileName: target.imageFileName(format),
        text: '$text ${target.linkFor(channel)}',
        origin: origin,
      );
    },
  );

  Future<void> _prepare(
    SharePreparing preparing,
    Future<Result<Uint8List>> Function() fetch,
    Future<void> Function(Uint8List png) share,
  ) async {
    if (state.preparing != SharePreparing.none) return;
    state = ShareChannelsState(preparing: preparing);
    final result = await fetch();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const ShareChannelsState(),
      Err(:final failure) => ShareChannelsState(failure: failure),
    };
    if (result case Ok(:final value)) await share(value);
  }
}
