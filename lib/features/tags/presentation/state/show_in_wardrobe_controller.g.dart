// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_in_wardrobe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
/// the API's answer.

@ProviderFor(ShowInWardrobeController)
final showInWardrobeControllerProvider = ShowInWardrobeControllerFamily._();

/// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
/// the API's answer.
final class ShowInWardrobeControllerProvider
    extends $NotifierProvider<ShowInWardrobeController, RequestState<void>> {
  /// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
  /// the API's answer.
  ShowInWardrobeControllerProvider._({
    required ShowInWardrobeControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'showInWardrobeControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$showInWardrobeControllerHash();

  @override
  String toString() {
    return r'showInWardrobeControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShowInWardrobeController create() => ShowInWardrobeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShowInWardrobeControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$showInWardrobeControllerHash() =>
    r'15ba390bf8df34b3949b16ece4f5b8c6d0f16b77';

/// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
/// the API's answer.

final class ShowInWardrobeControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ShowInWardrobeController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  ShowInWardrobeControllerFamily._()
    : super(
        retry: null,
        name: r'showInWardrobeControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
  /// the API's answer.

  ShowInWardrobeControllerProvider call(String cardId) =>
      ShowInWardrobeControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'showInWardrobeControllerProvider';
}

/// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
/// the API's answer.

abstract class _$ShowInWardrobeController
    extends $Notifier<RequestState<void>> {
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
