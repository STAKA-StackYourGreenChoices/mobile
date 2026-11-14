@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/features/scan/presentation/screens/scan_screen.dart';
import 'package:staka/features/scan/presentation/state/scan_camera_provider.dart';
import 'package:staka/features/scan/presentation/widgets/camera_panel.dart';
import 'package:staka/features/scan/presentation/widgets/camera_phase.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

/// A stand-in "camera picture": a soft gradient, so the dimmed area and the
/// aiming frame are visible in the snapshot.
const _fakePicture = DecoratedBox(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF8A8F7E), Color(0xFFC9C2AE)],
    ),
  ),
);

Widget _screenWith(CameraPhase phase) => ProviderScope(
  overrides: [
    scanCameraProvider.overrideWithValue(
      ({required onGtinFound}) => CameraPanel(
        phase: phase,
        preview: _fakePicture,
        onTurnOn: () {},
        onTurnOff: () {},
        onRetry: () {},
      ),
    ),
  ],
  child: const ScanScreen(),
);

void main() {
  setUpAll(loadAppFonts);

  final phases = {
    'scanning': const CameraScanning(),
    'blocked': const CameraBlocked(),
  };

  for (final MapEntry(key: name, value: phase) in phases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('scan $name, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 1100);
        await pumpThemed(tester, _screenWith(phase), brightness: brightness);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/scan_${name}_${brightness.name}.png'),
        );
      });
    }
  }
}
