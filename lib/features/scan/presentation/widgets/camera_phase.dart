/// What the camera panel is doing — the website scanner's `CameraState`.
sealed class CameraPhase {
  const new();
}

final class CameraStarting extends CameraPhase {
  const new();
}

/// Looking for a barcode. [notice] says why the last code was ignored.
final class CameraScanning extends CameraPhase {
  const new({this.notice});

  final String? notice;
}

final class CameraFound extends CameraPhase {
  const new(this.gtin);

  final String gtin;
}

/// Camera permission refused.
final class CameraBlocked extends CameraPhase {
  const new();
}

/// No camera, or it couldn't start; [reason] is shown to the shopper.
final class CameraUnavailable extends CameraPhase {
  const new(this.reason);

  final String reason;
}

/// Turned off by the shopper.
final class CameraStopped extends CameraPhase {
  const new();
}
