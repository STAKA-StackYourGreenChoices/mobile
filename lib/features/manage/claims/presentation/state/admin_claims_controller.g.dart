// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claims_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).

@ProviderFor(AdminClaimsController)
final adminClaimsControllerProvider = AdminClaimsControllerFamily._();

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).
final class AdminClaimsControllerProvider
    extends $NotifierProvider<AdminClaimsController, ClaimListState> {
  /// The claims with one [status], 20 at a time as the admin scrolls (the
  /// website pages them with Previous / Next).
  AdminClaimsControllerProvider._({
    required AdminClaimsControllerFamily super.from,
    required (ManageScope, ClaimStatus) super.argument,
  }) : super(
         retry: null,
         name: r'adminClaimsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminClaimsControllerHash();

  @override
  String toString() {
    return r'adminClaimsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AdminClaimsController create() => AdminClaimsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaimListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaimListState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminClaimsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminClaimsControllerHash() =>
    r'c7ca8c23fced0356d4f46792ae9cf16bc236068a';

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).

final class AdminClaimsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminClaimsController,
          ClaimListState,
          ClaimListState,
          ClaimListState,
          (ManageScope, ClaimStatus)
        > {
  AdminClaimsControllerFamily._()
    : super(
        retry: null,
        name: r'adminClaimsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The claims with one [status], 20 at a time as the admin scrolls (the
  /// website pages them with Previous / Next).

  AdminClaimsControllerProvider call(ManageScope scope, ClaimStatus status) =>
      AdminClaimsControllerProvider._(argument: (scope, status), from: this);

  @override
  String toString() => r'adminClaimsControllerProvider';
}

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).

abstract class _$AdminClaimsController extends $Notifier<ClaimListState> {
  late final _$args = ref.$arg as (ManageScope, ClaimStatus);
  ManageScope get scope => _$args.$1;
  ClaimStatus get status => _$args.$2;

  ClaimListState build(ManageScope scope, ClaimStatus status);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClaimListState, ClaimListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClaimListState, ClaimListState>,
              ClaimListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
