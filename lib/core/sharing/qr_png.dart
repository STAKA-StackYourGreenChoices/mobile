import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_png.g.dart';

/// Draws a QR code as a PNG; tests swap it for a fake, since widget tests
/// can't encode images under the fake clock.
typedef QrPngRenderer = Future<Uint8List> Function(String data);

@riverpod
QrPngRenderer qrPngRenderer(Ref ref) => renderQrPng;

/// Black modules on white with a wide white margin (the quiet zone QR
/// readers need) (V2-4: "QR code of the link, savable as an image").
Future<Uint8List> renderQrPng(String data, {double size = 1024}) async {
  final painter = QrPainter(data: data, version: QrVersions.auto);
  final margin = size / 10;
  final total = size + margin * 2;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawRect(Rect.fromLTWH(0, 0, total, total), Paint()..color = Colors.white)
    ..translate(margin, margin);
  painter.paint(canvas, Size.square(size));
  final image = await recorder.endRecording().toImage(
    total.round(),
    total.round(),
  );
  try {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}
