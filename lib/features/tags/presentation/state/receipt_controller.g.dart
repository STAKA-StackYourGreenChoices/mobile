// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Upload a receipt" for one tag.

@ProviderFor(ReceiptController)
final receiptControllerProvider = ReceiptControllerFamily._();

/// "Upload a receipt" for one tag.
final class ReceiptControllerProvider
    extends $NotifierProvider<ReceiptController, ReceiptState> {
  /// "Upload a receipt" for one tag.
  ReceiptControllerProvider._({
    required ReceiptControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'receiptControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$receiptControllerHash();

  @override
  String toString() {
    return r'receiptControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReceiptController create() => ReceiptController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$receiptControllerHash() => r'12f4cfbcab2710907219f1c9e69d679c7495d997';

/// "Upload a receipt" for one tag.

final class ReceiptControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ReceiptController,
          ReceiptState,
          ReceiptState,
          ReceiptState,
          String
        > {
  ReceiptControllerFamily._()
    : super(
        retry: null,
        name: r'receiptControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Upload a receipt" for one tag.

  ReceiptControllerProvider call(String cardId) =>
      ReceiptControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'receiptControllerProvider';
}

/// "Upload a receipt" for one tag.

abstract class _$ReceiptController extends $Notifier<ReceiptState> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  ReceiptState build(String cardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReceiptState, ReceiptState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReceiptState, ReceiptState>,
              ReceiptState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
