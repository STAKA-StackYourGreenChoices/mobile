// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_review_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One claim with its history, then its product for the hang tag: what
/// the website's `/admin/claims/[id]` loads.

@ProviderFor(ClaimReviewController)
final claimReviewControllerProvider = ClaimReviewControllerFamily._();

/// One claim with its history, then its product for the hang tag: what
/// the website's `/admin/claims/[id]` loads.
final class ClaimReviewControllerProvider
    extends $NotifierProvider<ClaimReviewController, ClaimReviewState> {
  /// One claim with its history, then its product for the hang tag: what
  /// the website's `/admin/claims/[id]` loads.
  ClaimReviewControllerProvider._({
    required ClaimReviewControllerFamily super.from,
    required (ManageScope, String) super.argument,
  }) : super(
         retry: null,
         name: r'claimReviewControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimReviewControllerHash();

  @override
  String toString() {
    return r'claimReviewControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ClaimReviewController create() => ClaimReviewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaimReviewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaimReviewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimReviewControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimReviewControllerHash() =>
    r'e5d4d3d836da29e2ad39a019a8a7f9db5bbf7f8f';

/// One claim with its history, then its product for the hang tag: what
/// the website's `/admin/claims/[id]` loads.

final class ClaimReviewControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimReviewController,
          ClaimReviewState,
          ClaimReviewState,
          ClaimReviewState,
          (ManageScope, String)
        > {
  ClaimReviewControllerFamily._()
    : super(
        retry: null,
        name: r'claimReviewControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One claim with its history, then its product for the hang tag: what
  /// the website's `/admin/claims/[id]` loads.

  ClaimReviewControllerProvider call(ManageScope scope, String claimId) =>
      ClaimReviewControllerProvider._(argument: (scope, claimId), from: this);

  @override
  String toString() => r'claimReviewControllerProvider';
}

/// One claim with its history, then its product for the hang tag: what
/// the website's `/admin/claims/[id]` loads.

abstract class _$ClaimReviewController extends $Notifier<ClaimReviewState> {
  late final _$args = ref.$arg as (ManageScope, String);
  ManageScope get scope => _$args.$1;
  String get claimId => _$args.$2;

  ClaimReviewState build(ManageScope scope, String claimId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClaimReviewState, ClaimReviewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClaimReviewState, ClaimReviewState>,
              ClaimReviewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
