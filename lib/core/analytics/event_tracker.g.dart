// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventTracker)
final eventTrackerProvider = EventTrackerProvider._();

final class EventTrackerProvider
    extends $FunctionalProvider<EventTracker, EventTracker, EventTracker>
    with $Provider<EventTracker> {
  EventTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventTrackerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventTrackerHash();

  @$internal
  @override
  $ProviderElement<EventTracker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventTracker create(Ref ref) {
    return eventTracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventTracker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventTracker>(value),
    );
  }
}

String _$eventTrackerHash() => r'acd078206ba8adbde350af57b869bf1ee2e0a07b';
