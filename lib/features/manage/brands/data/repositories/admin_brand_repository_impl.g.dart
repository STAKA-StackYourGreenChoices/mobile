// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_brand_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminBrandRepository)
final adminBrandRepositoryProvider = AdminBrandRepositoryProvider._();

final class AdminBrandRepositoryProvider
    extends
        $FunctionalProvider<
          AdminBrandRepository,
          AdminBrandRepository,
          AdminBrandRepository
        >
    with $Provider<AdminBrandRepository> {
  AdminBrandRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminBrandRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminBrandRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminBrandRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminBrandRepository create(Ref ref) {
    return adminBrandRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminBrandRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminBrandRepository>(value),
    );
  }
}

String _$adminBrandRepositoryHash() =>
    r'488bff22797e1d87b50ba47257e22a6cfe09b71c';
