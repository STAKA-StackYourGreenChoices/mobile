// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_camera_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which camera the Scan screen shows. The real one needs a device; tests
/// override this with a fake that "reads" a code on tap.

@ProviderFor(scanCamera)
final scanCameraProvider = ScanCameraProvider._();

/// Which camera the Scan screen shows. The real one needs a device; tests
/// override this with a fake that "reads" a code on tap.

final class ScanCameraProvider
    extends
        $FunctionalProvider<
          ScanCameraBuilder,
          ScanCameraBuilder,
          ScanCameraBuilder
        >
    with $Provider<ScanCameraBuilder> {
  /// Which camera the Scan screen shows. The real one needs a device; tests
  /// override this with a fake that "reads" a code on tap.
  ScanCameraProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanCameraProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanCameraHash();

  @$internal
  @override
  $ProviderElement<ScanCameraBuilder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanCameraBuilder create(Ref ref) {
    return scanCamera(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanCameraBuilder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanCameraBuilder>(value),
    );
  }
}

String _$scanCameraHash() => r'1a905d51f8a1c04692d0af92fa8c3e9a5a195f8c';
