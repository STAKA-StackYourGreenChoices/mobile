import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/features/scan/presentation/widgets/camera_panel.dart';
import 'package:staka/features/scan/presentation/widgets/camera_phase.dart';

import '../../helpers/pump_app.dart';

/// Shows the panel in [phase] and returns the callbacks it fires.
Future<List<String>> _show(WidgetTester tester, CameraPhase phase) async {
  usePhoneScreen(tester, height: 900);
  final log = <String>[];
  await pumpThemed(
    tester,
    SingleChildScrollView(
      child: CameraPanel(
        phase: phase,
        preview: const SizedBox.expand(),
        onTurnOn: () => log.add('on'),
        onTurnOff: () => log.add('off'),
        onRetry: () => log.add('retry'),
      ),
    ),
  );
  return log;
}

void main() {
  testWidgets('starting and scanning say what is happening', (tester) async {
    await _show(tester, const CameraStarting());
    expect(find.text('Starting the camera…'), findsOneWidget);

    final log = await _show(tester, const CameraScanning());
    expect(find.text('Looking for a barcode…'), findsOneWidget);
    await tester.tap(find.text('Turn camera off'));
    expect(log, ['off']);
  });

  testWidgets('an ignored code says why, and scanning continues', (
    tester,
  ) async {
    await _show(
      tester,
      const CameraScanning(notice: "This code isn't a product barcode."),
    );
    expect(find.text("This code isn't a product barcode."), findsOneWidget);
  });

  testWidgets('found: names the code while the product opens', (tester) async {
    await _show(tester, const CameraFound('8901234500019'));
    expect(
      find.text('Found 8901234500019. Opening the product…'),
      findsOneWidget,
    );
  });

  testWidgets('blocked: says how to allow it, offers to try again', (
    tester,
  ) async {
    final log = await _show(tester, const CameraBlocked());
    expect(find.textContaining('Camera access is blocked.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(log, ['retry']);
  });

  testWidgets('unavailable: the reason, then points to typing', (tester) async {
    await _show(
      tester,
      const CameraUnavailable('No camera was found on this device.'),
    );
    expect(
      find.text(
        'No camera was found on this device. Type the barcode number instead.',
      ),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('turned off: one tap turns it back on', (tester) async {
    final log = await _show(tester, const CameraStopped());
    expect(find.text('Camera is off.'), findsOneWidget);
    await tester.tap(find.text('Turn camera on'));
    expect(log, ['on']);
  });
}
