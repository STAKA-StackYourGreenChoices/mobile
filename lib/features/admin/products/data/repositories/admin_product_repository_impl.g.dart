// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminProductRepository)
final adminProductRepositoryProvider = AdminProductRepositoryProvider._();

final class AdminProductRepositoryProvider
    extends
        $FunctionalProvider<
          AdminProductRepository,
          AdminProductRepository,
          AdminProductRepository
        >
    with $Provider<AdminProductRepository> {
  AdminProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminProductRepository create(Ref ref) {
    return adminProductRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductRepository>(value),
    );
  }
}

String _$adminProductRepositoryHash() =>
    r'fe8a37fc6a6d97d4d1e1a1b1422a4626c77472d0';
