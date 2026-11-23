// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_receipt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A claim's receipt, fetched with the admin's token. Shared by the review
/// page's preview and the full-screen viewer above it, so it loads once.

@ProviderFor(claimReceipt)
final claimReceiptProvider = ClaimReceiptFamily._();

/// A claim's receipt, fetched with the admin's token. Shared by the review
/// page's preview and the full-screen viewer above it, so it loads once.

final class ClaimReceiptProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<ClaimReceipt>>,
          Result<ClaimReceipt>,
          FutureOr<Result<ClaimReceipt>>
        >
    with
        $FutureModifier<Result<ClaimReceipt>>,
        $FutureProvider<Result<ClaimReceipt>> {
  /// A claim's receipt, fetched with the admin's token. Shared by the review
  /// page's preview and the full-screen viewer above it, so it loads once.
  ClaimReceiptProvider._({
    required ClaimReceiptFamily super.from,
    required (ManageScope, String) super.argument,
  }) : super(
         retry: null,
         name: r'claimReceiptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimReceiptHash();

  @override
  String toString() {
    return r'claimReceiptProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<ClaimReceipt>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<ClaimReceipt>> create(Ref ref) {
    final argument = this.argument as (ManageScope, String);
    return claimReceipt(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimReceiptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimReceiptHash() => r'0475a651b14256fc41ba398d19719cce5f4d6221';

/// A claim's receipt, fetched with the admin's token. Shared by the review
/// page's preview and the full-screen viewer above it, so it loads once.

final class ClaimReceiptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<ClaimReceipt>>,
          (ManageScope, String)
        > {
  ClaimReceiptFamily._()
    : super(
        retry: null,
        name: r'claimReceiptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A claim's receipt, fetched with the admin's token. Shared by the review
  /// page's preview and the full-screen viewer above it, so it loads once.

  ClaimReceiptProvider call(ManageScope scope, String claimId) =>
      ClaimReceiptProvider._(argument: (scope, claimId), from: this);

  @override
  String toString() => r'claimReceiptProvider';
}
