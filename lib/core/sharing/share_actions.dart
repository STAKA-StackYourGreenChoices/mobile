import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'share_actions.g.dart';

/// What the phone does with a share link: clipboard, the system share
/// sheet (WhatsApp, Instagram, X… — it replaces the website's per-network
/// buttons) and the browser. Tests override this with a fake.
abstract interface class ShareActions {
  Future<void> copy(String text);

  /// [origin]: where the share sheet points from on iPad.
  Future<void> shareLink({
    required String url,
    required String text,
    required String subject,
    Rect? origin,
  });

  Future<void> shareImage({
    required Uint8List png,
    required String fileName,
    required String text,
    Rect? origin,
  });

  /// A file for the share sheet (Save to Files, Drive, email…), e.g. the
  /// account's data export.
  Future<void> shareFile({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    Rect? origin,
  });

  /// False when no app could open it.
  Future<bool> open(String url);
}

@riverpod
ShareActions shareActions(Ref ref) => const DeviceShareActions();

class DeviceShareActions implements ShareActions {
  const new();

  @override
  Future<void> copy(String text) =>
      Clipboard.setData(ClipboardData(text: text));

  @override
  Future<void> shareLink({
    required String url,
    required String text,
    required String subject,
    Rect? origin,
  }) => SharePlus.instance.share(
    ShareParams(
      text: '$text $url',
      subject: subject,
      sharePositionOrigin: origin,
    ),
  );

  @override
  Future<void> shareImage({
    required Uint8List png,
    required String fileName,
    required String text,
    Rect? origin,
  }) => SharePlus.instance.share(
    ShareParams(
      files: [XFile.fromData(png, mimeType: 'image/png', name: fileName)],
      fileNameOverrides: [fileName],
      text: text,
      sharePositionOrigin: origin,
    ),
  );

  @override
  Future<void> shareFile({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    Rect? origin,
  }) => SharePlus.instance.share(
    ShareParams(
      files: [XFile.fromData(bytes, mimeType: mimeType, name: fileName)],
      fileNameOverrides: [fileName],
      sharePositionOrigin: origin,
    ),
  );

  @override
  Future<bool> open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
