// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claims_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped after a claim is approved or rejected, so the claim lists in
/// that [ManageScope] reload (the website's `revalidatePath`).

@ProviderFor(AdminClaimsRevision)
final adminClaimsRevisionProvider = AdminClaimsRevisionFamily._();

/// Bumped after a claim is approved or rejected, so the claim lists in
/// that [ManageScope] reload (the website's `revalidatePath`).
final class AdminClaimsRevisionProvider
    extends $NotifierProvider<AdminClaimsRevision, int> {
  /// Bumped after a claim is approved or rejected, so the claim lists in
  /// that [ManageScope] reload (the website's `revalidatePath`).
  AdminClaimsRevisionProvider._({
    required AdminClaimsRevisionFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'adminClaimsRevisionProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminClaimsRevisionHash();

  @override
  String toString() {
    return r'adminClaimsRevisionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminClaimsRevision create() => AdminClaimsRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminClaimsRevisionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminClaimsRevisionHash() =>
    r'0e2084bb6cf6f6e944a6bf401aca6a14f081f37d';

/// Bumped after a claim is approved or rejected, so the claim lists in
/// that [ManageScope] reload (the website's `revalidatePath`).

final class AdminClaimsRevisionFamily extends $Family
    with $ClassFamilyOverride<AdminClaimsRevision, int, int, int, ManageScope> {
  AdminClaimsRevisionFamily._()
    : super(
        retry: null,
        name: r'adminClaimsRevisionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Bumped after a claim is approved or rejected, so the claim lists in
  /// that [ManageScope] reload (the website's `revalidatePath`).

  AdminClaimsRevisionProvider call(ManageScope scope) =>
      AdminClaimsRevisionProvider._(argument: scope, from: this);

  @override
  String toString() => r'adminClaimsRevisionProvider';
}

/// Bumped after a claim is approved or rejected, so the claim lists in
/// that [ManageScope] reload (the website's `revalidatePath`).

abstract class _$AdminClaimsRevision extends $Notifier<int> {
  late final _$args = ref.$arg as ManageScope;
  ManageScope get scope => _$args;

  int build(ManageScope scope);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
