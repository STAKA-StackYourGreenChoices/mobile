import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/cards/cards_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_repository.dart';

part 'wardrobe_repository_impl.g.dart';

@riverpod
WardrobeRepository wardrobeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return WardrobeRepositoryImpl(CardsApi(dio), WardrobeRemoteDataSource(dio));
}

class WardrobeRepositoryImpl implements WardrobeRepository {
  const new(this._cards, this._remote);

  final CardsApi _cards;
  final WardrobeRemoteDataSource _remote;

  @override
  Future<Result<List<DigitalCard>>> fetchMyCards() => guardApi(() async {
    final cards = await _cards.fetchMine();
    return [for (final card in cards) card.toDomain()];
  });

  /// The website special-cases the same message.
  @override
  Future<Result<ResendOutcome>> resendVerification() => guardApi(() async {
    final message = await _remote.resendVerification();
    return message == 'Email is already verified'
        ? ResendOutcome.alreadyConfirmed
        : ResendOutcome.sent;
  });
}
