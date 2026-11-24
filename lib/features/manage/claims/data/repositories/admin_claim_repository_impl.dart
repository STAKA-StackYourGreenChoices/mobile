import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/domain/repositories/admin_claim_repository.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'admin_claim_repository_impl.g.dart';

/// The claims [scope] decides on: every brand's for an admin, one brand's
/// for its team.
@riverpod
AdminClaimRepository adminClaimRepository(Ref ref, ManageScope scope) =>
    AdminClaimRepositoryImpl(
      AdminClaimRemoteDataSource(ref.watch(dioProvider), scope),
    );

class AdminClaimRepositoryImpl implements AdminClaimRepository {
  const new(this._remote);

  final AdminClaimRemoteDataSource _remote;

  @override
  Future<Result<ClaimPage>> fetchClaims(ClaimStatus status, int page) =>
      guardApi(() => _remote.list(status, page));

  @override
  Future<Result<ClaimDetail>> fetchClaim(String id) =>
      guardApi(() => _remote.detail(id));

  @override
  Future<Result<ClaimReceipt>> fetchReceipt(String claimId) =>
      guardApi(() => _remote.receipt(claimId));

  @override
  Future<Result<Product>> fetchProduct(String productId) =>
      guardApi(() async => (await _remote.product(productId)).toDomain());

  @override
  Future<Result<ClaimDetail>> approve(String id) =>
      guardApi(() => _remote.approve(id));

  @override
  Future<Result<ClaimDetail>> reject(String id, String reason) =>
      guardApi(() => _remote.reject(id, reason));

  @override
  Future<Result<ClaimDetail>> overrule(
    String id, {
    required ClaimStatus decision,
    required String reason,
  }) =>
      guardApi(() => _remote.overrule(id, decision: decision, reason: reason));
}
