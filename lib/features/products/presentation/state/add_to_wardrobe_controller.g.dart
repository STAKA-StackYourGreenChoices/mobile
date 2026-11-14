// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_wardrobe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Add to my wardrobe" for one product. On success the screen opens the
/// new tag, and the wardrobe is told to reload.

@ProviderFor(AddToWardrobeController)
final addToWardrobeControllerProvider = AddToWardrobeControllerFamily._();

/// "Add to my wardrobe" for one product. On success the screen opens the
/// new tag, and the wardrobe is told to reload.
final class AddToWardrobeControllerProvider
    extends
        $NotifierProvider<AddToWardrobeController, RequestState<DigitalCard>> {
  /// "Add to my wardrobe" for one product. On success the screen opens the
  /// new tag, and the wardrobe is told to reload.
  AddToWardrobeControllerProvider._({
    required AddToWardrobeControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'addToWardrobeControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addToWardrobeControllerHash();

  @override
  String toString() {
    return r'addToWardrobeControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AddToWardrobeController create() => AddToWardrobeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<DigitalCard> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<DigitalCard>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddToWardrobeControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addToWardrobeControllerHash() =>
    r'1e849ac550984cf01af05e2640da85bcb7fae71b';

/// "Add to my wardrobe" for one product. On success the screen opens the
/// new tag, and the wardrobe is told to reload.

final class AddToWardrobeControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AddToWardrobeController,
          RequestState<DigitalCard>,
          RequestState<DigitalCard>,
          RequestState<DigitalCard>,
          String
        > {
  AddToWardrobeControllerFamily._()
    : super(
        retry: null,
        name: r'addToWardrobeControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Add to my wardrobe" for one product. On success the screen opens the
  /// new tag, and the wardrobe is told to reload.

  AddToWardrobeControllerProvider call(String gtin) =>
      AddToWardrobeControllerProvider._(argument: gtin, from: this);

  @override
  String toString() => r'addToWardrobeControllerProvider';
}

/// "Add to my wardrobe" for one product. On success the screen opens the
/// new tag, and the wardrobe is told to reload.

abstract class _$AddToWardrobeController
    extends $Notifier<RequestState<DigitalCard>> {
  late final _$args = ref.$arg as String;
  String get gtin => _$args;

  RequestState<DigitalCard> build(String gtin);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<RequestState<DigitalCard>, RequestState<DigitalCard>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<DigitalCard>, RequestState<DigitalCard>>,
              RequestState<DigitalCard>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
