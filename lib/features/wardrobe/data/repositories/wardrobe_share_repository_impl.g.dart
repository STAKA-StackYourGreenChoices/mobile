// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_share_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wardrobeShareRepository)
final wardrobeShareRepositoryProvider = WardrobeShareRepositoryProvider._();

final class WardrobeShareRepositoryProvider
    extends
        $FunctionalProvider<
          WardrobeShareRepository,
          WardrobeShareRepository,
          WardrobeShareRepository
        >
    with $Provider<WardrobeShareRepository> {
  WardrobeShareRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeShareRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeShareRepositoryHash();

  @$internal
  @override
  $ProviderElement<WardrobeShareRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WardrobeShareRepository create(Ref ref) {
    return wardrobeShareRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WardrobeShareRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WardrobeShareRepository>(value),
    );
  }
}

String _$wardrobeShareRepositoryHash() =>
    r'803b577c3d34a8bd9ef935e16f29e54987acccb8';
