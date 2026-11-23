// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_catalog_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped whenever a product or brand is added, changed or deleted, so the
/// lists in that [ManageScope] reload, like the website's `revalidatePath`.

@ProviderFor(AdminCatalogRevision)
final adminCatalogRevisionProvider = AdminCatalogRevisionFamily._();

/// Bumped whenever a product or brand is added, changed or deleted, so the
/// lists in that [ManageScope] reload, like the website's `revalidatePath`.
final class AdminCatalogRevisionProvider
    extends $NotifierProvider<AdminCatalogRevision, int> {
  /// Bumped whenever a product or brand is added, changed or deleted, so the
  /// lists in that [ManageScope] reload, like the website's `revalidatePath`.
  AdminCatalogRevisionProvider._({
    required AdminCatalogRevisionFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'adminCatalogRevisionProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminCatalogRevisionHash();

  @override
  String toString() {
    return r'adminCatalogRevisionProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is AdminCatalogRevisionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminCatalogRevisionHash() =>
    r'f06431f1a0a6b54110a299d72a091edd89614536';

/// Bumped whenever a product or brand is added, changed or deleted, so the
/// lists in that [ManageScope] reload, like the website's `revalidatePath`.

final class AdminCatalogRevisionFamily extends $Family
    with
        $ClassFamilyOverride<AdminCatalogRevision, int, int, int, ManageScope> {
  AdminCatalogRevisionFamily._()
    : super(
        retry: null,
        name: r'adminCatalogRevisionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Bumped whenever a product or brand is added, changed or deleted, so the
  /// lists in that [ManageScope] reload, like the website's `revalidatePath`.

  AdminCatalogRevisionProvider call(ManageScope scope) =>
      AdminCatalogRevisionProvider._(argument: scope, from: this);

  @override
  String toString() => r'adminCatalogRevisionProvider';
}

/// Bumped whenever a product or brand is added, changed or deleted, so the
/// lists in that [ManageScope] reload, like the website's `revalidatePath`.

abstract class _$AdminCatalogRevision extends $Notifier<int> {
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
