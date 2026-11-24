// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shareActions)
final shareActionsProvider = ShareActionsProvider._();

final class ShareActionsProvider
    extends $FunctionalProvider<ShareActions, ShareActions, ShareActions>
    with $Provider<ShareActions> {
  ShareActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareActionsHash();

  @$internal
  @override
  $ProviderElement<ShareActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareActions create(Ref ref) {
    return shareActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareActions>(value),
    );
  }
}

String _$shareActionsHash() => r'e1be78571638ea454b14b49738b95c753dea4e57';
