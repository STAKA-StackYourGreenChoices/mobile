// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_revision.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Goes up when points may have changed (a reward redeemed, a phone
/// verified...), so the Rewards tab reloads its balance (V2-6). Tag changes
/// already reload it through `cardsRevisionProvider`.

@ProviderFor(PointsRevision)
final pointsRevisionProvider = PointsRevisionProvider._();

/// Goes up when points may have changed (a reward redeemed, a phone
/// verified...), so the Rewards tab reloads its balance (V2-6). Tag changes
/// already reload it through `cardsRevisionProvider`.
final class PointsRevisionProvider
    extends $NotifierProvider<PointsRevision, int> {
  /// Goes up when points may have changed (a reward redeemed, a phone
  /// verified...), so the Rewards tab reloads its balance (V2-6). Tag changes
  /// already reload it through `cardsRevisionProvider`.
  PointsRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointsRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointsRevisionHash();

  @$internal
  @override
  PointsRevision create() => PointsRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pointsRevisionHash() => r'9a80d66f3420fd92fbccc755025d42edb933ac86';

/// Goes up when points may have changed (a reward redeemed, a phone
/// verified...), so the Rewards tab reloads its balance (V2-6). Tag changes
/// already reload it through `cardsRevisionProvider`.

abstract class _$PointsRevision extends $Notifier<int> {
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
