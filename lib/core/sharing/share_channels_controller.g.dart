// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_channels_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The channel row and image formats of a share link (V2-4), for a tag or
/// the whole wardrobe. Every share adds `?ch=` and reports the click.

@ProviderFor(ShareChannelsController)
final shareChannelsControllerProvider = ShareChannelsControllerFamily._();

/// The channel row and image formats of a share link (V2-4), for a tag or
/// the whole wardrobe. Every share adds `?ch=` and reports the click.
final class ShareChannelsControllerProvider
    extends $NotifierProvider<ShareChannelsController, ShareChannelsState> {
  /// The channel row and image formats of a share link (V2-4), for a tag or
  /// the whole wardrobe. Every share adds `?ch=` and reports the click.
  ShareChannelsControllerProvider._({
    required ShareChannelsControllerFamily super.from,
    required ShareTarget super.argument,
  }) : super(
         retry: null,
         name: r'shareChannelsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shareChannelsControllerHash();

  @override
  String toString() {
    return r'shareChannelsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShareChannelsController create() => ShareChannelsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareChannelsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareChannelsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShareChannelsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shareChannelsControllerHash() =>
    r'ee49739aa8a4c05bc6ae82a26d934d77ad0403a4';

/// The channel row and image formats of a share link (V2-4), for a tag or
/// the whole wardrobe. Every share adds `?ch=` and reports the click.

final class ShareChannelsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ShareChannelsController,
          ShareChannelsState,
          ShareChannelsState,
          ShareChannelsState,
          ShareTarget
        > {
  ShareChannelsControllerFamily._()
    : super(
        retry: null,
        name: r'shareChannelsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The channel row and image formats of a share link (V2-4), for a tag or
  /// the whole wardrobe. Every share adds `?ch=` and reports the click.

  ShareChannelsControllerProvider call(ShareTarget target) =>
      ShareChannelsControllerProvider._(argument: target, from: this);

  @override
  String toString() => r'shareChannelsControllerProvider';
}

/// The channel row and image formats of a share link (V2-4), for a tag or
/// the whole wardrobe. Every share adds `?ch=` and reports the click.

abstract class _$ShareChannelsController extends $Notifier<ShareChannelsState> {
  late final _$args = ref.$arg as ShareTarget;
  ShareTarget get target => _$args;

  ShareChannelsState build(ShareTarget target);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShareChannelsState, ShareChannelsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShareChannelsState, ShareChannelsState>,
              ShareChannelsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
