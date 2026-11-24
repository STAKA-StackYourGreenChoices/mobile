// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'look_again_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
/// request as open until STAKA answers.

@ProviderFor(LookAgainController)
final lookAgainControllerProvider = LookAgainControllerFamily._();

/// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
/// request as open until STAKA answers.
final class LookAgainControllerProvider
    extends $NotifierProvider<LookAgainController, RequestState<void>> {
  /// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
  /// request as open until STAKA answers.
  LookAgainControllerProvider._({
    required LookAgainControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lookAgainControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lookAgainControllerHash();

  @override
  String toString() {
    return r'lookAgainControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LookAgainController create() => LookAgainController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LookAgainControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lookAgainControllerHash() =>
    r'851efc989576ac1c32e17010574c4c709627f5e4';

/// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
/// request as open until STAKA answers.

final class LookAgainControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LookAgainController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  LookAgainControllerFamily._()
    : super(
        retry: null,
        name: r'lookAgainControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
  /// request as open until STAKA answers.

  LookAgainControllerProvider call(String cardId) =>
      LookAgainControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'lookAgainControllerProvider';
}

/// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
/// request as open until STAKA answers.

abstract class _$LookAgainController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  RequestState<void> build(String cardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<void>, RequestState<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<void>, RequestState<void>>,
              RequestState<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
