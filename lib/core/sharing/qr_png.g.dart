// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_png.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(qrPngRenderer)
final qrPngRendererProvider = QrPngRendererProvider._();

final class QrPngRendererProvider
    extends $FunctionalProvider<QrPngRenderer, QrPngRenderer, QrPngRenderer>
    with $Provider<QrPngRenderer> {
  QrPngRendererProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrPngRendererProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrPngRendererHash();

  @$internal
  @override
  $ProviderElement<QrPngRenderer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QrPngRenderer create(Ref ref) {
    return qrPngRenderer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QrPngRenderer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QrPngRenderer>(value),
    );
  }
}

String _$qrPngRendererHash() => r'39521e4583ce7d64119d7af55200f10f67a80549';
