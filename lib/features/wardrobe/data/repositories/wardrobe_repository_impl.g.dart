// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wardrobeRepository)
final wardrobeRepositoryProvider = WardrobeRepositoryProvider._();

final class WardrobeRepositoryProvider
    extends
        $FunctionalProvider<
          WardrobeRepository,
          WardrobeRepository,
          WardrobeRepository
        >
    with $Provider<WardrobeRepository> {
  WardrobeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeRepositoryHash();

  @$internal
  @override
  $ProviderElement<WardrobeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WardrobeRepository create(Ref ref) {
    return wardrobeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WardrobeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WardrobeRepository>(value),
    );
  }
}

String _$wardrobeRepositoryHash() =>
    r'6b4e671ddf0eb1381ff9139b3b35647c09ed707c';
