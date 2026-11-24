// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_image_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shareImageApi)
final shareImageApiProvider = ShareImageApiProvider._();

final class ShareImageApiProvider
    extends $FunctionalProvider<ShareImageApi, ShareImageApi, ShareImageApi>
    with $Provider<ShareImageApi> {
  ShareImageApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareImageApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareImageApiHash();

  @$internal
  @override
  $ProviderElement<ShareImageApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareImageApi create(Ref ref) {
    return shareImageApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareImageApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareImageApi>(value),
    );
  }
}

String _$shareImageApiHash() => r'27344c139e5c15f9534a053e2aa742d122333bef';
