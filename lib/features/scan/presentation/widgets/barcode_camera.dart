import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/utils/scan_parser.dart';
import 'package:staka/features/scan/presentation/scan_messages.dart';
import 'package:staka/features/scan/presentation/widgets/camera_panel.dart';
import 'package:staka/features/scan/presentation/widgets/camera_phase.dart';

/// The live camera, reading EAN-13, EAN-8, UPC-A, UPC-E and QR codes — the
/// website's scanner. A code that isn't a product keeps scanning and says
/// why; a product code calls [onGtinFound] once.
///
/// The camera only runs while this screen is actually in front: not while
/// another tab is showing, not under a pushed screen (it restarts on the
/// way back), and not in the background (mobile_scanner handles that).
class BarcodeCamera extends StatefulWidget {
  const new({required this.onGtinFound, super.key});

  final ValueChanged<String> onGtinFound;

  @override
  State<BarcodeCamera> createState() => _BarcodeCameraState();
}

class _BarcodeCameraState extends State<BarcodeCamera> {
  final _controller = MobileScannerController(
    autoStart: false,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.qrCode,
    ],
  );
  bool _isTurnedOff = false;
  bool _isVisible = false;
  String? _foundGtin;
  String? _notice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isVisible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    if (isVisible == _isVisible) return;
    _isVisible = isVisible;
    if (isVisible) _foundGtin = null; // back from the product: scan again
    unawaited(_sync());
  }

  /// Runs the camera exactly when it should be running.
  Future<void> _sync() async {
    final shouldRun = _isVisible && !_isTurnedOff;
    if (shouldRun && !_controller.value.isRunning) {
      await _controller.start();
    } else if (!shouldRun && _controller.value.isRunning) {
      await _controller.stop();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_foundGtin != null) return;
    final raw = capture.barcodes.map((b) => b.rawValue).nonNulls.firstOrNull;
    if (raw == null) return;
    switch (parseScan(raw)) {
      case ScanGtin(:final gtin):
        setState(() => _foundGtin = gtin);
        unawaited(HapticFeedback.lightImpact());
        widget.onGtinFound(gtin);
      case final ScanRejected rejected:
        setState(() => _notice = scanRejectionMessage(rejected, context.l10n));
    }
  }

  void _setTurnedOff({required bool isOff}) {
    setState(() {
      _isTurnedOff = isOff;
      _notice = null;
    });
    unawaited(_sync());
  }

  CameraPhase _phase(MobileScannerState camera) {
    final l10n = context.l10n;
    if (_foundGtin case final gtin?) return CameraFound(gtin);
    if (camera.error case final error?) {
      return switch (error.errorCode) {
        MobileScannerErrorCode.permissionDenied => const CameraBlocked(),
        MobileScannerErrorCode.unsupported => CameraUnavailable(
          l10n.cameraNoCamera,
        ),
        _ => CameraUnavailable(l10n.cameraCouldNotStart),
      };
    }
    if (_isTurnedOff) return const CameraStopped();
    return camera.isRunning
        ? CameraScanning(notice: _notice)
        : const CameraStarting();
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _controller,
    builder: (context, camera, _) => CameraPanel(
      phase: _phase(camera),
      preview: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
        // The panel draws every state itself.
        errorBuilder: (_, _) => const SizedBox.shrink(),
        placeholderBuilder: (_) => const SizedBox.shrink(),
      ),
      onTurnOn: () => _setTurnedOff(isOff: false),
      onTurnOff: () => _setTurnedOff(isOff: true),
      onRetry: () => unawaited(_controller.start()),
    ),
  );
}
