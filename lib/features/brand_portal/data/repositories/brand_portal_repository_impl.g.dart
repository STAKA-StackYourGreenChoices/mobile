// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_portal_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brandPortalRepository)
final brandPortalRepositoryProvider = BrandPortalRepositoryProvider._();

final class BrandPortalRepositoryProvider
    extends
        $FunctionalProvider<
          BrandPortalRepository,
          BrandPortalRepository,
          BrandPortalRepository
        >
    with $Provider<BrandPortalRepository> {
  BrandPortalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandPortalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandPortalRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandPortalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrandPortalRepository create(Ref ref) {
    return brandPortalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandPortalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandPortalRepository>(value),
    );
  }
}

String _$brandPortalRepositoryHash() =>
    r'7f7161a9e4baf28f1271b628eb2db9b68acdccd2';
