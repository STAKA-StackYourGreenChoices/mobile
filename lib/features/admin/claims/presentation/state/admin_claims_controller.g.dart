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
    required ClaimStatus super.argument,
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
        '($argument)';
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
    r'c3a407915776fc88cb6e92a487107bb578939df9';

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).

final class AdminClaimsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminClaimsController,
          ClaimListState,
          ClaimListState,
          ClaimListState,
          ClaimStatus
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

  AdminClaimsControllerProvider call(ClaimStatus status) =>
      AdminClaimsControllerProvider._(argument: status, from: this);

  @override
  String toString() => r'adminClaimsControllerProvider';
}

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).

abstract class _$AdminClaimsController extends $Notifier<ClaimListState> {
  late final _$args = ref.$arg as ClaimStatus;
  ClaimStatus get status => _$args;

  ClaimListState build(ClaimStatus status);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
