// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creating and stopping a tag's public link. The channels and images are
/// `ShareChannelsController` (core/sharing, V2-4).

@ProviderFor(ShareController)
final shareControllerProvider = ShareControllerFamily._();

/// Creating and stopping a tag's public link. The channels and images are
/// `ShareChannelsController` (core/sharing, V2-4).
final class ShareControllerProvider
    extends $NotifierProvider<ShareController, ShareState> {
  /// Creating and stopping a tag's public link. The channels and images are
  /// `ShareChannelsController` (core/sharing, V2-4).
  ShareControllerProvider._({
    required ShareControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shareControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shareControllerHash();

  @override
  String toString() {
    return r'shareControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShareController create() => ShareController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShareControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shareControllerHash() => r'a0663457bd21f975b19afc3ae2484958b95a7fb7';

/// Creating and stopping a tag's public link. The channels and images are
/// `ShareChannelsController` (core/sharing, V2-4).

final class ShareControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ShareController,
          ShareState,
          ShareState,
          ShareState,
          String
        > {
  ShareControllerFamily._()
    : super(
        retry: null,
        name: r'shareControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Creating and stopping a tag's public link. The channels and images are
  /// `ShareChannelsController` (core/sharing, V2-4).

  ShareControllerProvider call(String cardId) =>
      ShareControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'shareControllerProvider';
}

/// Creating and stopping a tag's public link. The channels and images are
/// `ShareChannelsController` (core/sharing, V2-4).

abstract class _$ShareController extends $Notifier<ShareState> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  ShareState build(String cardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShareState, ShareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShareState, ShareState>,
              ShareState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
