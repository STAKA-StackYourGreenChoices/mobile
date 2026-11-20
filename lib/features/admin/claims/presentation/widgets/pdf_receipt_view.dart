import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfx/pdfx.dart';

/// A PDF receipt drawn by the phone's own PDF renderer, pages scrolling
/// down, pinch to zoom.
class PdfReceiptView extends StatefulWidget {
  const new({required this.bytes, super.key});

  final Uint8List bytes;

  @override
  State<PdfReceiptView> createState() => _PdfReceiptViewState();
}

class _PdfReceiptViewState extends State<PdfReceiptView> {
  late final _controller = PdfControllerPinch(
    document: PdfDocument.openData(widget.bytes),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PdfViewPinch(controller: _controller);
}
