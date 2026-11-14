import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_repository.dart';

part 'wardrobe_repository_impl.g.dart';

@riverpod
WardrobeRepository wardrobeRepository(Ref ref) =>
    WardrobeRepositoryImpl(WardrobeRemoteDataSource(ref.watch(dioProvider)));

class WardrobeRepositoryImpl implements WardrobeRepository {
  const new(this._remote);

  final WardrobeRemoteDataSource _remote;

  @override
  Future<Result<List<DigitalCard>>> fetchMyCards() => guardApi(() async {
    final cards = await _remote.fetchMyCards();
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
