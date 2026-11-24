// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_share_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The whole-wardrobe link: load it, create it, stop it.

@ProviderFor(WardrobeShareController)
final wardrobeShareControllerProvider = WardrobeShareControllerProvider._();

/// The whole-wardrobe link: load it, create it, stop it.
final class WardrobeShareControllerProvider
    extends $NotifierProvider<WardrobeShareController, WardrobeShareState> {
  /// The whole-wardrobe link: load it, create it, stop it.
  WardrobeShareControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeShareControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeShareControllerHash();

  @$internal
  @override
  WardrobeShareController create() => WardrobeShareController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WardrobeShareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WardrobeShareState>(value),
    );
  }
}

String _$wardrobeShareControllerHash() =>
    r'b7f9954ef1723446b0ceaca73a0a2e1c2f39ad7d';

/// The whole-wardrobe link: load it, create it, stop it.

abstract class _$WardrobeShareController extends $Notifier<WardrobeShareState> {
  WardrobeShareState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WardrobeShareState, WardrobeShareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WardrobeShareState, WardrobeShareState>,
              WardrobeShareState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
