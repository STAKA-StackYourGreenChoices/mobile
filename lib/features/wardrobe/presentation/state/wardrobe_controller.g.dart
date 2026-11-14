// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WardrobeController)
final wardrobeControllerProvider = WardrobeControllerProvider._();

final class WardrobeControllerProvider
    extends $NotifierProvider<WardrobeController, WardrobeState> {
  WardrobeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeControllerHash();

  @$internal
  @override
  WardrobeController create() => WardrobeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WardrobeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WardrobeState>(value),
    );
  }
}

String _$wardrobeControllerHash() =>
    r'0aa5544bf397e18e51b65d4673fa4f75f747dc8a';

abstract class _$WardrobeController extends $Notifier<WardrobeState> {
  WardrobeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WardrobeState, WardrobeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WardrobeState, WardrobeState>,
              WardrobeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
