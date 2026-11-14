import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/tags/data/datasources/tag_remote_data_source.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';
import 'package:staka/features/tags/domain/repositories/tag_repository.dart';

part 'tag_repository_impl.g.dart';

@riverpod
TagRepository tagRepository(Ref ref) =>
    TagRepositoryImpl(TagRemoteDataSource(ref.watch(dioProvider)));

class TagRepositoryImpl implements TagRepository {
  const new(this._remote);

  final TagRemoteDataSource _remote;

  @override
  Future<Result<DigitalCard>> fetchTag(String cardId) =>
      guardApi(() async => (await _remote.fetchTag(cardId)).toDomain());

  @override
  Future<Result<Ownership>> matchOrder(String cardId) =>
      guardApi(() async => (await _remote.matchOrder(cardId)).toDomain());

  @override
  Future<Result<Ownership>> uploadReceipt(
    String cardId,
    PickedReceipt receipt,
  ) => guardApi(
    () async => (await _remote.uploadReceipt(cardId, receipt)).toDomain(),
  );
}
