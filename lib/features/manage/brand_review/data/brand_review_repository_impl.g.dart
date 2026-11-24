// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_review_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brandReviewRepository)
final brandReviewRepositoryProvider = BrandReviewRepositoryProvider._();

final class BrandReviewRepositoryProvider
    extends
        $FunctionalProvider<
          BrandReviewRepository,
          BrandReviewRepository,
          BrandReviewRepository
        >
    with $Provider<BrandReviewRepository> {
  BrandReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrandReviewRepository create(Ref ref) {
    return brandReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandReviewRepository>(value),
    );
  }
}

String _$brandReviewRepositoryHash() =>
    r'13f2fb03d82398eb82ca7d9634b1a9df9668be6a';
