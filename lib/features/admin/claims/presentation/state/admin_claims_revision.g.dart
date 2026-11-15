// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claims_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped after a claim is approved or rejected, so the claim lists reload
/// (the website's `revalidatePath('/admin/claims')`).

@ProviderFor(AdminClaimsRevision)
final adminClaimsRevisionProvider = AdminClaimsRevisionProvider._();

/// Bumped after a claim is approved or rejected, so the claim lists reload
/// (the website's `revalidatePath('/admin/claims')`).
final class AdminClaimsRevisionProvider
    extends $NotifierProvider<AdminClaimsRevision, int> {
  /// Bumped after a claim is approved or rejected, so the claim lists reload
  /// (the website's `revalidatePath('/admin/claims')`).
  AdminClaimsRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminClaimsRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminClaimsRevisionHash();

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
}

String _$adminClaimsRevisionHash() =>
    r'95d7e4b3cb9b9c38e3c8797dae53000d9a8aff9b';

/// Bumped after a claim is approved or rejected, so the claim lists reload
/// (the website's `revalidatePath('/admin/claims')`).

abstract class _$AdminClaimsRevision extends $Notifier<int> {
  int build();
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
    return element.handleCreate(ref, build);
  }
}
