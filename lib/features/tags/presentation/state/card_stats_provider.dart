import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';

part 'card_stats_provider.g.dart';

/// A shared tag's views and clicks (V2-5). Null when they couldn't be
/// loaded (e.g. an API without them): the tag then shows no stats.
@riverpod
Future<CardStats?> cardStats(Ref ref, String cardId) async {
  final result = await ref.read(tagRepositoryProvider).fetchStats(cardId);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
}
