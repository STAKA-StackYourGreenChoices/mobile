// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A shared tag's views and clicks (V2-5). Null when they couldn't be
/// loaded (e.g. an API without them): the tag then shows no stats.

@ProviderFor(cardStats)
final cardStatsProvider = CardStatsFamily._();

/// A shared tag's views and clicks (V2-5). Null when they couldn't be
/// loaded (e.g. an API without them): the tag then shows no stats.

final class CardStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<CardStats?>,
          CardStats?,
          FutureOr<CardStats?>
        >
    with $FutureModifier<CardStats?>, $FutureProvider<CardStats?> {
  /// A shared tag's views and clicks (V2-5). Null when they couldn't be
  /// loaded (e.g. an API without them): the tag then shows no stats.
  CardStatsProvider._({
    required CardStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cardStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cardStatsHash();

  @override
  String toString() {
    return r'cardStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CardStats?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CardStats?> create(Ref ref) {
    final argument = this.argument as String;
    return cardStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CardStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cardStatsHash() => r'3e5efcaf4ef0b1f970e5fbbeb5126af8f75cf3de';

/// A shared tag's views and clicks (V2-5). Null when they couldn't be
/// loaded (e.g. an API without them): the tag then shows no stats.

final class CardStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CardStats?>, String> {
  CardStatsFamily._()
    : super(
        retry: null,
        name: r'cardStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A shared tag's views and clicks (V2-5). Null when they couldn't be
  /// loaded (e.g. an API without them): the tag then shows no stats.

  CardStatsProvider call(String cardId) =>
      CardStatsProvider._(argument: cardId, from: this);

  @override
  String toString() => r'cardStatsProvider';
}
