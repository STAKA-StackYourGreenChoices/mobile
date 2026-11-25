// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_rewards_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every brand's rewards (Admin → Rewards). Reloads after a switch-off.

@ProviderFor(adminRewards)
final adminRewardsProvider = AdminRewardsProvider._();

/// Every brand's rewards (Admin → Rewards). Reloads after a switch-off.

final class AdminRewardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<AdminReward>>>,
          Result<List<AdminReward>>,
          FutureOr<Result<List<AdminReward>>>
        >
    with
        $FutureModifier<Result<List<AdminReward>>>,
        $FutureProvider<Result<List<AdminReward>>> {
  /// Every brand's rewards (Admin → Rewards). Reloads after a switch-off.
  AdminRewardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRewardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRewardsHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<AdminReward>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<AdminReward>>> create(Ref ref) {
    return adminRewards(ref);
  }
}

String _$adminRewardsHash() => r'453c1f6787833865f88e96b6b8f84f805f600229';

/// Switching one reward off.

@ProviderFor(RewardSwitchOffController)
final rewardSwitchOffControllerProvider = RewardSwitchOffControllerFamily._();

/// Switching one reward off.
final class RewardSwitchOffControllerProvider
    extends $NotifierProvider<RewardSwitchOffController, RequestState<void>> {
  /// Switching one reward off.
  RewardSwitchOffControllerProvider._({
    required RewardSwitchOffControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rewardSwitchOffControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rewardSwitchOffControllerHash();

  @override
  String toString() {
    return r'rewardSwitchOffControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RewardSwitchOffController create() => RewardSwitchOffController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RewardSwitchOffControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rewardSwitchOffControllerHash() =>
    r'006b678f3fa86a8d8c4854a385e56472d3ca79cd';

/// Switching one reward off.

final class RewardSwitchOffControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RewardSwitchOffController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  RewardSwitchOffControllerFamily._()
    : super(
        retry: null,
        name: r'rewardSwitchOffControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Switching one reward off.

  RewardSwitchOffControllerProvider call(String rewardId) =>
      RewardSwitchOffControllerProvider._(argument: rewardId, from: this);

  @override
  String toString() => r'rewardSwitchOffControllerProvider';
}

/// Switching one reward off.

abstract class _$RewardSwitchOffController
    extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get rewardId => _$args;

  RequestState<void> build(String rewardId);
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

@ProviderFor(RewardRulesRevision)
final rewardRulesRevisionProvider = RewardRulesRevisionProvider._();

final class RewardRulesRevisionProvider
    extends $NotifierProvider<RewardRulesRevision, int> {
  RewardRulesRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardRulesRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardRulesRevisionHash();

  @$internal
  @override
  RewardRulesRevision create() => RewardRulesRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$rewardRulesRevisionHash() =>
    r'54d18e65155f4092b92b5874ed3772ff68a94f65';

abstract class _$RewardRulesRevision extends $Notifier<int> {
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

@ProviderFor(rewardRules)
final rewardRulesProvider = RewardRulesProvider._();

final class RewardRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RewardRule>>>,
          Result<List<RewardRule>>,
          FutureOr<Result<List<RewardRule>>>
        >
    with
        $FutureModifier<Result<List<RewardRule>>>,
        $FutureProvider<Result<List<RewardRule>>> {
  RewardRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardRulesHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<RewardRule>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RewardRule>>> create(Ref ref) {
    return rewardRules(ref);
  }
}

String _$rewardRulesHash() => r'69a694388d5156f8c2fdcd69ee99938de92c3874';

/// Saving one rule from its sheet.

@ProviderFor(RuleSaveController)
final ruleSaveControllerProvider = RuleSaveControllerFamily._();

/// Saving one rule from its sheet.
final class RuleSaveControllerProvider
    extends $NotifierProvider<RuleSaveController, RequestState<RewardRule>> {
  /// Saving one rule from its sheet.
  RuleSaveControllerProvider._({
    required RuleSaveControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ruleSaveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ruleSaveControllerHash();

  @override
  String toString() {
    return r'ruleSaveControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RuleSaveController create() => RuleSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<RewardRule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<RewardRule>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RuleSaveControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ruleSaveControllerHash() =>
    r'3ab16e452ccae1bf4ba11164916eb395dbea9b9b';

/// Saving one rule from its sheet.

final class RuleSaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RuleSaveController,
          RequestState<RewardRule>,
          RequestState<RewardRule>,
          RequestState<RewardRule>,
          String
        > {
  RuleSaveControllerFamily._()
    : super(
        retry: null,
        name: r'ruleSaveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Saving one rule from its sheet.

  RuleSaveControllerProvider call(String key) =>
      RuleSaveControllerProvider._(argument: key, from: this);

  @override
  String toString() => r'ruleSaveControllerProvider';
}

/// Saving one rule from its sheet.

abstract class _$RuleSaveController
    extends $Notifier<RequestState<RewardRule>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  RequestState<RewardRule> build(String key);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<RequestState<RewardRule>, RequestState<RewardRule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<RewardRule>, RequestState<RewardRule>>,
              RequestState<RewardRule>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
