// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_decision_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Approve or reject one claim. Done holds the decision made.

@ProviderFor(ClaimDecisionController)
final claimDecisionControllerProvider = ClaimDecisionControllerFamily._();

/// Approve or reject one claim. Done holds the decision made.
final class ClaimDecisionControllerProvider
    extends
        $NotifierProvider<ClaimDecisionController, RequestState<ClaimStatus>> {
  /// Approve or reject one claim. Done holds the decision made.
  ClaimDecisionControllerProvider._({
    required ClaimDecisionControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'claimDecisionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimDecisionControllerHash();

  @override
  String toString() {
    return r'claimDecisionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClaimDecisionController create() => ClaimDecisionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<ClaimStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<ClaimStatus>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimDecisionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimDecisionControllerHash() =>
    r'f7fe50d3135f7920ec3083fd2a1560b5ac83b494';

/// Approve or reject one claim. Done holds the decision made.

final class ClaimDecisionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimDecisionController,
          RequestState<ClaimStatus>,
          RequestState<ClaimStatus>,
          RequestState<ClaimStatus>,
          String
        > {
  ClaimDecisionControllerFamily._()
    : super(
        retry: null,
        name: r'claimDecisionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Approve or reject one claim. Done holds the decision made.

  ClaimDecisionControllerProvider call(String claimId) =>
      ClaimDecisionControllerProvider._(argument: claimId, from: this);

  @override
  String toString() => r'claimDecisionControllerProvider';
}

/// Approve or reject one claim. Done holds the decision made.

abstract class _$ClaimDecisionController
    extends $Notifier<RequestState<ClaimStatus>> {
  late final _$args = ref.$arg as String;
  String get claimId => _$args;

  RequestState<ClaimStatus> build(String claimId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<RequestState<ClaimStatus>, RequestState<ClaimStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<ClaimStatus>, RequestState<ClaimStatus>>,
              RequestState<ClaimStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
