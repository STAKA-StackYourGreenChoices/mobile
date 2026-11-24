// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Push for the signed-in person (V2-9): starts Firebase once, registers
/// this phone's token after sign-in (and again when it changes) while
/// notifications are allowed, and removes it on sign-out. Never asks for
/// permission by itself: screens call [requestPermission] at a moment that
/// explains itself.

@ProviderFor(PushController)
final pushControllerProvider = PushControllerProvider._();

/// Push for the signed-in person (V2-9): starts Firebase once, registers
/// this phone's token after sign-in (and again when it changes) while
/// notifications are allowed, and removes it on sign-out. Never asks for
/// permission by itself: screens call [requestPermission] at a moment that
/// explains itself.
final class PushControllerProvider
    extends $NotifierProvider<PushController, PushState> {
  /// Push for the signed-in person (V2-9): starts Firebase once, registers
  /// this phone's token after sign-in (and again when it changes) while
  /// notifications are allowed, and removes it on sign-out. Never asks for
  /// permission by itself: screens call [requestPermission] at a moment that
  /// explains itself.
  PushControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushControllerHash();

  @$internal
  @override
  PushController create() => PushController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushState>(value),
    );
  }
}

String _$pushControllerHash() => r'8291a915f5eedd65d2db0063641eea40359ab0fd';

/// Push for the signed-in person (V2-9): starts Firebase once, registers
/// this phone's token after sign-in (and again when it changes) while
/// notifications are allowed, and removes it on sign-out. Never asks for
/// permission by itself: screens call [requestPermission] at a moment that
/// explains itself.

abstract class _$PushController extends $Notifier<PushState> {
  PushState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PushState, PushState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PushState, PushState>,
              PushState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
