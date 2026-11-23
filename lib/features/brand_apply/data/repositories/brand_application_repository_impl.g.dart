// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_application_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brandApplicationRepository)
final brandApplicationRepositoryProvider =
    BrandApplicationRepositoryProvider._();

final class BrandApplicationRepositoryProvider
    extends
        $FunctionalProvider<
          BrandApplicationRepository,
          BrandApplicationRepository,
          BrandApplicationRepository
        >
    with $Provider<BrandApplicationRepository> {
  BrandApplicationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandApplicationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandApplicationRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandApplicationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrandApplicationRepository create(Ref ref) {
    return brandApplicationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandApplicationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandApplicationRepository>(value),
    );
  }
}

String _$brandApplicationRepositoryHash() =>
    r'08a2c675e53a57372df564af0bdfb9c8c7359851';
