// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_brands_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every brand with its product count (`GET /brands`).

@ProviderFor(AdminBrandsController)
final adminBrandsControllerProvider = AdminBrandsControllerProvider._();

/// Every brand with its product count (`GET /brands`).
final class AdminBrandsControllerProvider
    extends $NotifierProvider<AdminBrandsController, AdminBrandsState> {
  /// Every brand with its product count (`GET /brands`).
  AdminBrandsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminBrandsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminBrandsControllerHash();

  @$internal
  @override
  AdminBrandsController create() => AdminBrandsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminBrandsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminBrandsState>(value),
    );
  }
}

String _$adminBrandsControllerHash() =>
    r'0ee011d97b5fe3efa2fdc835dd9ff5fac73b6ef2';

/// Every brand with its product count (`GET /brands`).

abstract class _$AdminBrandsController extends $Notifier<AdminBrandsState> {
  AdminBrandsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminBrandsState, AdminBrandsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminBrandsState, AdminBrandsState>,
              AdminBrandsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
