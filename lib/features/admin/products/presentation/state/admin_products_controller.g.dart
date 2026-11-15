// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).

@ProviderFor(AdminProductsController)
final adminProductsControllerProvider = AdminProductsControllerProvider._();

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).
final class AdminProductsControllerProvider
    extends $NotifierProvider<AdminProductsController, AdminProductsState> {
  /// The admin product list: search, brand filter, and pages loaded as the
  /// admin scrolls (guide §11: 20 at a time).
  AdminProductsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsControllerHash();

  @$internal
  @override
  AdminProductsController create() => AdminProductsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductsState>(value),
    );
  }
}

String _$adminProductsControllerHash() =>
    r'c82d98c32879114f11ec553863c987c5b97063d6';

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).

abstract class _$AdminProductsController extends $Notifier<AdminProductsState> {
  AdminProductsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminProductsState, AdminProductsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminProductsState, AdminProductsState>,
              AdminProductsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
