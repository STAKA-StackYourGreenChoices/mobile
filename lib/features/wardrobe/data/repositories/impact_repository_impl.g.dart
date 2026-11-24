// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impact_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(impactRepository)
final impactRepositoryProvider = ImpactRepositoryProvider._();

final class ImpactRepositoryProvider
    extends
        $FunctionalProvider<
          ImpactRepository,
          ImpactRepository,
          ImpactRepository
        >
    with $Provider<ImpactRepository> {
  ImpactRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'impactRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$impactRepositoryHash();

  @$internal
  @override
  $ProviderElement<ImpactRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImpactRepository create(Ref ref) {
    return impactRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImpactRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImpactRepository>(value),
    );
  }
}

String _$impactRepositoryHash() => r'f7a3e73023535eb7fc8e29a8d0eb0ed24fe71ad3';
