import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/wardrobe/data/datasources/wardrobe_share_remote_data_source.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_share_repository.dart';

part 'wardrobe_share_repository_impl.g.dart';

@riverpod
WardrobeShareRepository wardrobeShareRepository(Ref ref) =>
    WardrobeShareRepositoryImpl(
      WardrobeShareRemoteDataSource(ref.watch(dioProvider)),
    );

class WardrobeShareRepositoryImpl implements WardrobeShareRepository {
  const new(this._remote);

  final WardrobeShareRemoteDataSource _remote;

  @override
  Future<Result<ShareLink?>> fetchShare() =>
      guardApi(() async => (await _remote.fetch())?.toDomain());

  @override
  Future<Result<ShareLink>> share() =>
      guardApi(() async => (await _remote.create()).toDomain());

  @override
  Future<Result<void>> stopSharing() => guardApi(_remote.delete);
}
