import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

Map<String, Object?> _claim({String id = 'c1', String status = 'PENDING'}) => {
  'id': id,
  'method': 'RECEIPT',
  'status': status,
  'createdAt': '2026-11-12T10:00:00.000Z',
  'hasReceipt': true,
  'receiptMimeType': 'image/png',
  'receiptAttempt': 2,
  'user': {'id': 'u1', 'name': 'Ada Lovelace', 'email': 'ada@example.com'},
  'product': {
    'id': 'p1',
    'name': 'Organic Cotton Tee',
    'gtin': '08901234500019',
    'sku': 'TT-TEE-01',
    'brandName': 'Terra Threads',
    'imageUrl': 'http://localhost:3000/catalog-images/tee.svg',
  },
};

(AdminClaimRepositoryImpl, FakeHttpAdapter) _repository(FakeReply reply) {
  final adapter = FakeHttpAdapter([reply]);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = adapter;
  return (
    AdminClaimRepositoryImpl(
      AdminClaimRemoteDataSource(dio, const AdminScope()),
    ),
    adapter,
  );
}

void main() {
  test('list: status, page and 20 per page, like the website', () async {
    final (repository, adapter) = _repository(
      json(200, {
        'items': [_claim()],
        'total': 1,
        'page': 2,
        'limit': 20,
      }),
    );

    final result = await repository.fetchClaims(ClaimStatus.approved, 2);

    final request = adapter.requests.single;
    expect(request.path, '/claims');
    expect(request.queryParameters, {
      'status': 'APPROVED',
      'page': 2,
      'limit': 20,
    });
    final claim = (result as Ok<ClaimPage>).value.items.single;
    expect(
      (claim.method, claim.status),
      (ClaimMethod.receipt, ClaimStatus.pending),
    );
    // Catalog images are re-pointed so a phone can load them.
    expect(claim.product.imageUrl, endsWith('/catalog-images/tee.svg'));
    expect(claim.product.imageUrl, isNot(contains('localhost:3000')));
  });

  test('detail: the claim and its history', () async {
    final (repository, _) = _repository(
      json(200, {
        ..._claim(),
        'history': [_claim(id: 'c0', status: 'REJECTED'), _claim()],
      }),
    );

    final result = await repository.fetchClaim('c1');

    final detail = (result as Ok<ClaimDetail>).value;
    expect(detail.claim.id, 'c1');
    expect(detail.history.map((claim) => claim.status), [
      ClaimStatus.rejected,
      ClaimStatus.pending,
    ]);
  });

  test('receipt: the bytes and their type', () async {
    final (repository, adapter) = _repository(
      (_) async => ResponseBody.fromBytes(
        onePixelPng,
        200,
        headers: {
          Headers.contentTypeHeader: ['image/png'],
        },
      ),
    );

    final result = await repository.fetchReceipt('c1');

    expect(adapter.requests.single.path, '/claims/c1/receipt');
    final receipt = (result as Ok<ClaimReceipt>).value;
    expect((receipt.mimeType, receipt.isPdf), ('image/png', false));
    expect(receipt.bytes, onePixelPng);
  });

  test('reject sends the reason; a second decision is a conflict', () async {
    final (repository, adapter) = _repository(
      json(409, {'message': 'Claim already reviewed', 'statusCode': 409}),
    );

    final result = await repository.reject('c1', 'Part of it is cut off');

    final request = adapter.requests.single;
    expect((request.method, request.path), ('POST', '/claims/c1/reject'));
    expect(request.data, {'reason': 'Part of it is cut off'});
    expect((result as Err<ClaimDetail>).failure, isA<ConflictFailure>());
  });
}
