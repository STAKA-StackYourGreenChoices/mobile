// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impact_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The wardrobe's impact summary (V2-5). Null when it couldn't be loaded
/// (e.g. an API without it): the wardrobe then simply has no card.
/// Reloads whenever the tags change.

@ProviderFor(wardrobeImpact)
final wardrobeImpactProvider = WardrobeImpactProvider._();

/// The wardrobe's impact summary (V2-5). Null when it couldn't be loaded
/// (e.g. an API without it): the wardrobe then simply has no card.
/// Reloads whenever the tags change.

final class WardrobeImpactProvider
    extends $FunctionalProvider<AsyncValue<Impact?>, Impact?, FutureOr<Impact?>>
    with $FutureModifier<Impact?>, $FutureProvider<Impact?> {
  /// The wardrobe's impact summary (V2-5). Null when it couldn't be loaded
  /// (e.g. an API without it): the wardrobe then simply has no card.
  /// Reloads whenever the tags change.
  WardrobeImpactProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeImpactProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeImpactHash();

  @$internal
  @override
  $FutureProviderElement<Impact?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Impact?> create(Ref ref) {
    return wardrobeImpact(ref);
  }
}

String _$wardrobeImpactHash() => r'6606068154e59ce2869a10b473ac9bb281c00db5';

/// The activity timeline, 20 entries at a time as the shopper scrolls.

@ProviderFor(ActivityController)
final activityControllerProvider = ActivityControllerProvider._();

/// The activity timeline, 20 entries at a time as the shopper scrolls.
final class ActivityControllerProvider
    extends $NotifierProvider<ActivityController, ActivityState> {
  /// The activity timeline, 20 entries at a time as the shopper scrolls.
  ActivityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityControllerHash();

  @$internal
  @override
  ActivityController create() => ActivityController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityState>(value),
    );
  }
}

String _$activityControllerHash() =>
    r'efbf2975ab26ba57165e86a31f807a4dae105f13';

/// The activity timeline, 20 entries at a time as the shopper scrolls.

abstract class _$ActivityController extends $Notifier<ActivityState> {
  ActivityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActivityState, ActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityState, ActivityState>,
              ActivityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
