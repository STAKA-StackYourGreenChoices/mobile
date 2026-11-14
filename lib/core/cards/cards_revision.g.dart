// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Goes up whenever the shopper's tags change (added, proven, shared), so
/// screens that list them reload. Features can't import each other, so the
/// one that changes a tag bumps this and the wardrobe listens.

@ProviderFor(CardsRevision)
final cardsRevisionProvider = CardsRevisionProvider._();

/// Goes up whenever the shopper's tags change (added, proven, shared), so
/// screens that list them reload. Features can't import each other, so the
/// one that changes a tag bumps this and the wardrobe listens.
final class CardsRevisionProvider
    extends $NotifierProvider<CardsRevision, int> {
  /// Goes up whenever the shopper's tags change (added, proven, shared), so
  /// screens that list them reload. Features can't import each other, so the
  /// one that changes a tag bumps this and the wardrobe listens.
  CardsRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cardsRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cardsRevisionHash();

  @$internal
  @override
  CardsRevision create() => CardsRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cardsRevisionHash() => r'f60de679e85efaed21c6fbcf65241ee4f5ce3706';

/// Goes up whenever the shopper's tags change (added, proven, shared), so
/// screens that list them reload. Features can't import each other, so the
/// one that changes a tag bumps this and the wardrobe listens.

abstract class _$CardsRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
