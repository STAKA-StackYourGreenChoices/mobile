import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/tags/data/datasources/share_remote_data_source.dart';
import 'package:staka/features/tags/data/datasources/tag_remote_data_source.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';
import 'package:staka/features/tags/domain/repositories/tag_repository.dart';

part 'tag_repository_impl.g.dart';

@riverpod
TagRepository tagRepository(Ref ref) {
  final api = ref.watch(dioProvider);
  return TagRepositoryImpl(
    TagRemoteDataSource(api),
    ShareRemoteDataSource(api),
  );
}

class TagRepositoryImpl implements TagRepository {
  const new(this._remote, this._sharing);

  final TagRemoteDataSource _remote;
  final ShareRemoteDataSource _sharing;

  @override
  Future<Result<DigitalCard>> fetchTag(String cardId) =>
      guardApi(() async => (await _remote.fetchTag(cardId)).toDomain());

  @override
  Future<Result<DigitalCard>> setShowInWardrobe(
    String cardId, {
    required bool show,
  }) => guardApi(
    () async =>
        (await _remote.setShowInWardrobe(cardId, show: show)).toDomain(),
  );

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

  @override
  Future<Result<void>> askToLookAgain(String cardId, String message) =>
      guardApi(() => _remote.askToLookAgain(cardId, message));

  @override
  Future<Result<ShareLink>> share(String cardId) =>
      guardApi(() async => (await _sharing.share(cardId)).toDomain());

  @override
  Future<Result<void>> stopSharing(String cardId) =>
      guardApi(() => _sharing.stopSharing(cardId));
}
