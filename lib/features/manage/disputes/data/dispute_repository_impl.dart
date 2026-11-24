import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/manage/claims/data/dtos/claim_dto.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';

part 'dispute_repository_impl.g.dart';

@riverpod
DisputeRepository disputeRepository(Ref ref) =>
    DisputeRepositoryImpl(ref.watch(dioProvider));

/// `GET /admin/disputes?status` and `POST /admin/disputes/:id/resolve`.
class DisputeRepositoryImpl implements DisputeRepository {
  const new(this._dio);

  final Dio _dio;

  static String apiStatus(DisputeStatus status) => switch (status) {
    DisputeStatus.open => 'OPEN',
    DisputeStatus.upheld => 'UPHELD',
    DisputeStatus.overturned => 'OVERTURNED',
  };

  @override
  Future<Result<List<AdminDispute>>> fetchDisputes(DisputeStatus status) =>
      guardApi(() async {
        final response = await _dio.get<Object>(
          '/admin/disputes',
          queryParameters: {'status': apiStatus(status)},
        );
        // A plain list, or a page with `items`: the contract doesn't say.
        final items = switch (response.data) {
          final List<dynamic> list => list,
          {'items': final List<dynamic> list} => list,
          _ => const <dynamic>[],
        };
        return [
          for (final item in items)
            adminDisputeFromJson(item as Map<String, dynamic>),
        ]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });

  @override
  Future<Result<void>> resolve(
    String id,
    DisputeOutcome outcome,
    String note,
  ) => guardApi(
    () => _dio.post<void>(
      '/admin/disputes/${Uri.encodeComponent(id)}/resolve',
      data: {'outcome': outcome.apiName, 'note': note},
    ),
  );
}

/// Lenient: the claim comes along when the API includes it in full.
AdminDispute adminDisputeFromJson(Map<String, dynamic> json) {
  final claimJson = json['claim'];
  Claim? claim;
  if (claimJson is Map<String, dynamic>) {
    try {
      claim = ClaimDto.fromJson(claimJson).toDomain();
    } on Object {
      claim = null;
    }
  }
  return AdminDispute(
    id: json['id'] as String,
    claimId: json['claimId'] as String? ?? claim?.id ?? '',
    status: switch (json['status']) {
      'UPHELD' => DisputeStatus.upheld,
      'OVERTURNED' => DisputeStatus.overturned,
      _ => DisputeStatus.open,
    },
    message: json['message'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
    resolution: json['resolution'] as String?,
    resolvedAt: switch (json['resolvedAt']) {
      final String at => DateTime.tryParse(at),
      _ => null,
    },
    claim: claim,
  );
}
