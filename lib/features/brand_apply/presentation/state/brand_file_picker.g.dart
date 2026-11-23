// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_file_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The device pickers. Tests override this with a fake.

@ProviderFor(brandFilePicker)
final brandFilePickerProvider = BrandFilePickerProvider._();

/// The device pickers. Tests override this with a fake.

final class BrandFilePickerProvider
    extends
        $FunctionalProvider<BrandFilePicker, BrandFilePicker, BrandFilePicker>
    with $Provider<BrandFilePicker> {
  /// The device pickers. Tests override this with a fake.
  BrandFilePickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandFilePickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandFilePickerHash();

  @$internal
  @override
  $ProviderElement<BrandFilePicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrandFilePicker create(Ref ref) {
    return brandFilePicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandFilePicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandFilePicker>(value),
    );
  }
}

String _$brandFilePickerHash() => r'd6b76a8bce2e579aed43a577c6a04cbcb0973861';
