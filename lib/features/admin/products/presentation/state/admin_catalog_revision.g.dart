// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_catalog_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped whenever a product is added, changed or deleted, so the product
/// list (kept under the form) reloads, like the website's `revalidatePath`.

@ProviderFor(AdminCatalogRevision)
final adminCatalogRevisionProvider = AdminCatalogRevisionProvider._();

/// Bumped whenever a product is added, changed or deleted, so the product
/// list (kept under the form) reloads, like the website's `revalidatePath`.
final class AdminCatalogRevisionProvider
    extends $NotifierProvider<AdminCatalogRevision, int> {
  /// Bumped whenever a product is added, changed or deleted, so the product
  /// list (kept under the form) reloads, like the website's `revalidatePath`.
  AdminCatalogRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminCatalogRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminCatalogRevisionHash();

  @$internal
  @override
  AdminCatalogRevision create() => AdminCatalogRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$adminCatalogRevisionHash() =>
    r'a02c165bea239c03276ad8df9c0c92ca0b693bd3';

/// Bumped whenever a product is added, changed or deleted, so the product
/// list (kept under the form) reloads, like the website's `revalidatePath`.

abstract class _$AdminCatalogRevision extends $Notifier<int> {
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
