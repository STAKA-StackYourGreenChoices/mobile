// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The device pickers. Tests override this with a fake.

@ProviderFor(receiptPicker)
final receiptPickerProvider = ReceiptPickerProvider._();

/// The device pickers. Tests override this with a fake.

final class ReceiptPickerProvider
    extends $FunctionalProvider<ReceiptPicker, ReceiptPicker, ReceiptPicker>
    with $Provider<ReceiptPicker> {
  /// The device pickers. Tests override this with a fake.
  ReceiptPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptPickerHash();

  @$internal
  @override
  $ProviderElement<ReceiptPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReceiptPicker create(Ref ref) {
    return receiptPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptPicker>(value),
    );
  }
}

String _$receiptPickerHash() => r'd500f3535b19160bd6bc52ff7d4782cbf2cb9979';
