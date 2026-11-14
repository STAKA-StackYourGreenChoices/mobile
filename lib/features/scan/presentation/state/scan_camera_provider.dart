import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/scan/presentation/widgets/barcode_camera.dart';

part 'scan_camera_provider.g.dart';

typedef ScanCameraBuilder = Widget Function({
  required ValueChanged<String> onGtinFound,
});

/// Which camera the Scan screen shows. The real one needs a device; tests
/// override this with a fake that "reads" a code on tap.
@riverpod
ScanCameraBuilder scanCamera(Ref ref) =>
    ({required onGtinFound}) => BarcodeCamera(onGtinFound: onGtinFound);
