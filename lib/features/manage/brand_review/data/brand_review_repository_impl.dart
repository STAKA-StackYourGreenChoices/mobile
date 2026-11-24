import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_remote_data_source.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/brand_review/domain/repositories/brand_review_repository.dart';

part 'brand_review_repository_impl.g.dart';

@riverpod
BrandReviewRepository brandReviewRepository(Ref ref) =>
    BrandReviewRepositoryImpl(
      BrandReviewRemoteDataSource(ref.watch(dioProvider)),
    );

class BrandReviewRepositoryImpl implements BrandReviewRepository {
  const new(this._remote);

  final BrandReviewRemoteDataSource _remote;

  @override
  Future<Result<List<ReviewBrand>>> fetchBrands(
    BrandApplicationStatus status,
  ) => guardApi(() async {
    final brands = await _remote.list(status);
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    return brands..sort(
      (a, b) => (b.application.appliedAt ?? epoch).compareTo(
        a.application.appliedAt ?? epoch,
      ),
    );
  });

  @override
  Future<Result<ReviewBrand>> fetchBrand(String id) =>
      guardApi(() => _remote.detail(id));

  @override
  Future<Result<BrandDocument>> fetchDocument(String id) =>
      guardApi(() => _remote.document(id));

  @override
  Future<Result<void>> approve(String id) =>
      guardApi(() => _remote.decide(id, 'approve'));

  @override
  Future<Result<void>> reject(String id, String reason) =>
      guardApi(() => _remote.decide(id, 'reject', reason: reason));

  @override
  Future<Result<void>> suspend(String id, String reason) =>
      guardApi(() => _remote.decide(id, 'suspend', reason: reason));

  @override
  Future<Result<void>> reinstate(String id) =>
      guardApi(() => _remote.decide(id, 'reinstate'));
}
