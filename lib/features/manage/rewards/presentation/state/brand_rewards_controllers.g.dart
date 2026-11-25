// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_rewards_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped after a save or a codes upload, so lists, details and stats
/// reload.

@ProviderFor(BrandRewardsRevision)
final brandRewardsRevisionProvider = BrandRewardsRevisionProvider._();

/// Bumped after a save or a codes upload, so lists, details and stats
/// reload.
final class BrandRewardsRevisionProvider
    extends $NotifierProvider<BrandRewardsRevision, int> {
  /// Bumped after a save or a codes upload, so lists, details and stats
  /// reload.
  BrandRewardsRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandRewardsRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandRewardsRevisionHash();

  @$internal
  @override
  BrandRewardsRevision create() => BrandRewardsRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$brandRewardsRevisionHash() =>
    r'88a3811f5b5b7e4f015a4ec4d76a6f0df3b50dcd';

/// Bumped after a save or a codes upload, so lists, details and stats
/// reload.

abstract class _$BrandRewardsRevision extends $Notifier<int> {
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

@ProviderFor(brandRewards)
final brandRewardsProvider = BrandRewardsFamily._();

final class BrandRewardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<BrandReward>>>,
          Result<List<BrandReward>>,
          FutureOr<Result<List<BrandReward>>>
        >
    with
        $FutureModifier<Result<List<BrandReward>>>,
        $FutureProvider<Result<List<BrandReward>>> {
  BrandRewardsProvider._({
    required BrandRewardsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandRewardsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandRewardsHash();

  @override
  String toString() {
    return r'brandRewardsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<BrandReward>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BrandReward>>> create(Ref ref) {
    final argument = this.argument as String;
    return brandRewards(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandRewardsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandRewardsHash() => r'81cadbb87df1c7898a6a1d48edd9d5e9cc9801cc';

final class BrandRewardsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<BrandReward>>>, String> {
  BrandRewardsFamily._()
    : super(
        retry: null,
        name: r'brandRewardsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BrandRewardsProvider call(String brandId) =>
      BrandRewardsProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandRewardsProvider';
}

@ProviderFor(brandReward)
final brandRewardProvider = BrandRewardFamily._();

final class BrandRewardProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<BrandReward>>,
          Result<BrandReward>,
          FutureOr<Result<BrandReward>>
        >
    with
        $FutureModifier<Result<BrandReward>>,
        $FutureProvider<Result<BrandReward>> {
  BrandRewardProvider._({
    required BrandRewardFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'brandRewardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandRewardHash();

  @override
  String toString() {
    return r'brandRewardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<BrandReward>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<BrandReward>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return brandReward(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandRewardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandRewardHash() => r'ec690090f0339608e05902f31acd30fd404a3e56';

final class BrandRewardFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<BrandReward>>,
          (String, String)
        > {
  BrandRewardFamily._()
    : super(
        retry: null,
        name: r'brandRewardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BrandRewardProvider call(String brandId, String rewardId) =>
      BrandRewardProvider._(argument: (brandId, rewardId), from: this);

  @override
  String toString() => r'brandRewardProvider';
}

/// The codes behind a reward; null when they can't load (the screen then
/// leaves the numbers out).

@ProviderFor(brandRewardStats)
final brandRewardStatsProvider = BrandRewardStatsFamily._();

/// The codes behind a reward; null when they can't load (the screen then
/// leaves the numbers out).

final class BrandRewardStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RewardStats?>,
          RewardStats?,
          FutureOr<RewardStats?>
        >
    with $FutureModifier<RewardStats?>, $FutureProvider<RewardStats?> {
  /// The codes behind a reward; null when they can't load (the screen then
  /// leaves the numbers out).
  BrandRewardStatsProvider._({
    required BrandRewardStatsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'brandRewardStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandRewardStatsHash();

  @override
  String toString() {
    return r'brandRewardStatsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RewardStats?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RewardStats?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return brandRewardStats(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandRewardStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandRewardStatsHash() => r'8355093f213b42ab1cc167002c14fb436d9fadb1';

/// The codes behind a reward; null when they can't load (the screen then
/// leaves the numbers out).

final class BrandRewardStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RewardStats?>, (String, String)> {
  BrandRewardStatsFamily._()
    : super(
        retry: null,
        name: r'brandRewardStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The codes behind a reward; null when they can't load (the screen then
  /// leaves the numbers out).

  BrandRewardStatsProvider call(String brandId, String rewardId) =>
      BrandRewardStatsProvider._(argument: (brandId, rewardId), from: this);

  @override
  String toString() => r'brandRewardStatsProvider';
}

/// Creates a reward (no [rewardId]) or saves changes to one.

@ProviderFor(BrandRewardSaveController)
final brandRewardSaveControllerProvider = BrandRewardSaveControllerFamily._();

/// Creates a reward (no [rewardId]) or saves changes to one.
final class BrandRewardSaveControllerProvider
    extends
        $NotifierProvider<
          BrandRewardSaveController,
          RequestState<BrandReward>
        > {
  /// Creates a reward (no [rewardId]) or saves changes to one.
  BrandRewardSaveControllerProvider._({
    required BrandRewardSaveControllerFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'brandRewardSaveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandRewardSaveControllerHash();

  @override
  String toString() {
    return r'brandRewardSaveControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  BrandRewardSaveController create() => BrandRewardSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<BrandReward> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<BrandReward>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandRewardSaveControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandRewardSaveControllerHash() =>
    r'58f4f96fc668dd4d4e9c25138a6f56a5afecec90';

/// Creates a reward (no [rewardId]) or saves changes to one.

final class BrandRewardSaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandRewardSaveController,
          RequestState<BrandReward>,
          RequestState<BrandReward>,
          RequestState<BrandReward>,
          (String, String?)
        > {
  BrandRewardSaveControllerFamily._()
    : super(
        retry: null,
        name: r'brandRewardSaveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Creates a reward (no [rewardId]) or saves changes to one.

  BrandRewardSaveControllerProvider call(String brandId, String? rewardId) =>
      BrandRewardSaveControllerProvider._(
        argument: (brandId, rewardId),
        from: this,
      );

  @override
  String toString() => r'brandRewardSaveControllerProvider';
}

/// Creates a reward (no [rewardId]) or saves changes to one.

abstract class _$BrandRewardSaveController
    extends $Notifier<RequestState<BrandReward>> {
  late final _$args = ref.$arg as (String, String?);
  String get brandId => _$args.$1;
  String? get rewardId => _$args.$2;

  RequestState<BrandReward> build(String brandId, String? rewardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<RequestState<BrandReward>, RequestState<BrandReward>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<BrandReward>, RequestState<BrandReward>>,
              RequestState<BrandReward>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Pick a CSV of voucher codes and send it. The file is checked here first
/// (CSV, not empty, 2 MB at most), like the product import.

@ProviderFor(CodesUploadController)
final codesUploadControllerProvider = CodesUploadControllerFamily._();

/// Pick a CSV of voucher codes and send it. The file is checked here first
/// (CSV, not empty, 2 MB at most), like the product import.
final class CodesUploadControllerProvider
    extends $NotifierProvider<CodesUploadController, CodesUploadState> {
  /// Pick a CSV of voucher codes and send it. The file is checked here first
  /// (CSV, not empty, 2 MB at most), like the product import.
  CodesUploadControllerProvider._({
    required CodesUploadControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'codesUploadControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$codesUploadControllerHash();

  @override
  String toString() {
    return r'codesUploadControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  CodesUploadController create() => CodesUploadController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodesUploadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodesUploadState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CodesUploadControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$codesUploadControllerHash() =>
    r'a8c93350bf7176308dfa558c5e829516d6614e04';

/// Pick a CSV of voucher codes and send it. The file is checked here first
/// (CSV, not empty, 2 MB at most), like the product import.

final class CodesUploadControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CodesUploadController,
          CodesUploadState,
          CodesUploadState,
          CodesUploadState,
          (String, String)
        > {
  CodesUploadControllerFamily._()
    : super(
        retry: null,
        name: r'codesUploadControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Pick a CSV of voucher codes and send it. The file is checked here first
  /// (CSV, not empty, 2 MB at most), like the product import.

  CodesUploadControllerProvider call(String brandId, String rewardId) =>
      CodesUploadControllerProvider._(
        argument: (brandId, rewardId),
        from: this,
      );

  @override
  String toString() => r'codesUploadControllerProvider';
}

/// Pick a CSV of voucher codes and send it. The file is checked here first
/// (CSV, not empty, 2 MB at most), like the product import.

abstract class _$CodesUploadController extends $Notifier<CodesUploadState> {
  late final _$args = ref.$arg as (String, String);
  String get brandId => _$args.$1;
  String get rewardId => _$args.$2;

  CodesUploadState build(String brandId, String rewardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CodesUploadState, CodesUploadState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CodesUploadState, CodesUploadState>,
              CodesUploadState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
