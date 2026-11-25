// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_rewards_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brandRewardsRepository)
final brandRewardsRepositoryProvider = BrandRewardsRepositoryProvider._();

final class BrandRewardsRepositoryProvider
    extends
        $FunctionalProvider<
          BrandRewardsRepository,
          BrandRewardsRepository,
          BrandRewardsRepository
        >
    with $Provider<BrandRewardsRepository> {
  BrandRewardsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandRewardsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandRewardsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandRewardsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrandRewardsRepository create(Ref ref) {
    return brandRewardsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandRewardsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandRewardsRepository>(value),
    );
  }
}

String _$brandRewardsRepositoryHash() =>
    r'50e1eeb95fafaad6df94a4c744780fe7df7fa6d6';
