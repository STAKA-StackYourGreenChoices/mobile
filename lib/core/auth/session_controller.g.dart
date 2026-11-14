// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the signed-in state for the whole app. Restores the session on
/// launch; sign-in screens hand it new tokens; any screen can sign out.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// Owns the signed-in state for the whole app. Restores the session on
/// launch; sign-in screens hand it new tokens; any screen can sign out.
final class SessionControllerProvider
    extends $NotifierProvider<SessionController, SessionState> {
  /// Owns the signed-in state for the whole app. Restores the session on
  /// launch; sign-in screens hand it new tokens; any screen can sign out.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$sessionControllerHash() => r'246bd10b691cdea92587480b966f442ed393adaa';

/// Owns the signed-in state for the whole app. Restores the session on
/// launch; sign-in screens hand it new tokens; any screen can sign out.

abstract class _$SessionController extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionState, SessionState>,
              SessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
