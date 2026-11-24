import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/wardrobe/data/datasources/impact_remote_data_source.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';
import 'package:staka/features/wardrobe/domain/repositories/impact_repository.dart';

part 'impact_repository_impl.g.dart';

@riverpod
ImpactRepository impactRepository(Ref ref) =>
    ImpactRepositoryImpl(ImpactRemoteDataSource(ref.watch(dioProvider)));

class ImpactRepositoryImpl implements ImpactRepository {
  const new(this._remote);

  final ImpactRemoteDataSource _remote;

  @override
  Future<Result<Impact>> fetchImpact() => guardApi(_remote.fetchImpact);

  @override
  Future<Result<ActivityPage>> fetchActivity(int page) =>
      guardApi(() => _remote.fetchActivity(page));
}
