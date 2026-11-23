import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/brand_apply/data/datasources/brand_application_remote_data_source.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';
import 'package:staka/features/brand_apply/domain/repositories/brand_application_repository.dart';

part 'brand_application_repository_impl.g.dart';

@riverpod
BrandApplicationRepository brandApplicationRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return BrandApplicationRepositoryImpl(
    BrandApplicationRemoteDataSource(dio),
    BrandsApi(dio),
  );
}

class BrandApplicationRepositoryImpl implements BrandApplicationRepository {
  const new(this._remote, this._brands);

  final BrandApplicationRemoteDataSource _remote;
  final BrandsApi _brands;

  @override
  Future<Result<List<BrandApplication>>> fetchMine() => guardApi(() async {
    final applications = [
      for (final dto in await _remote.fetchMine()) dto.toDomain(),
    ];
    // Newest first, whatever order the API sends; undated ones last.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    return applications
      ..sort((a, b) => (b.appliedAt ?? epoch).compareTo(a.appliedAt ?? epoch));
  });

  @override
  Future<Result<List<BrandSummary>>> fetchListedBrands() => guardApi(
    () async => [for (final dto in await _brands.fetchAll()) dto.toDomain()],
  );

  @override
  Future<Result<BrandApplication>> apply(BrandApplicationDraft draft) =>
      guardApi(() async => (await _remote.apply(draft)).toDomain());

  @override
  Future<Result<BrandApplication>> resubmit(
    String applicationId,
    BrandApplicationDraft draft,
  ) => guardApi(
    () async => (await _remote.resubmit(applicationId, draft)).toDomain(),
  );
}
