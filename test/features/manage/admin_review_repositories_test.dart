import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_remote_data_source.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_repository_impl.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/data/dtos/claim_dto.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/disputes/data/dispute_repository_impl.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/features/manage/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/manage/products/data/datasources/product_editor_remote_data_source.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/fake_http_adapter.dart';

Dio _dio(FakeHttpAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;

Map<String, Object?> _brand({
  String id = 'b1',
  String status = 'PENDING',
  String appliedAt = '2026-11-20T10:00:00.000Z',
  Map<String, Object?> extra = const {},
}) => {
  'id': id,
  'name': 'Terra Threads',
  'legalName': 'Terra Threads Pvt Ltd',
  'status': status,
  'appliedAt': appliedAt,
  ...extra,
};

Map<String, Object?> _claim({String status = 'REJECTED', Object? dispute}) => {
  'id': 'c1',
  'method': 'RECEIPT',
  'status': status,
  'createdAt': '2026-11-12T10:00:00.000Z',
  'hasReceipt': true,
  'receiptMimeType': 'image/png',
  'rejectionReason': 'Wrong shop',
  'user': {'id': 'u1', 'name': 'Ada Lovelace', 'email': 'ada@example.com'},
  'product': {
    'id': 'p1',
    'name': 'Organic Cotton Tee',
    'gtin': '08901234500019',
    'sku': 'TT-TEE-01',
    'brandName': 'Terra Threads',
  },
  'dispute': ?dispute,
};

void main() {
  group('brand review', () {
    test('lists by API status, newest first; reads both list shapes', () async {
      final adapter = FakeHttpAdapter([
        json(200, [
          _brand(id: 'old', appliedAt: '2026-11-01T10:00:00.000Z'),
          _brand(
            id: 'new',
            extra: {
              '_count': {'members': 2},
              'verificationDocPath': 'docs/b1.pdf',
            },
          ),
        ]),
        json(200, {
          'items': [
            _brand(
              status: 'ACTIVE',
              extra: {'memberCount': 3, 'hasDocument': false},
            ),
          ],
        }),
      ]);
      final repository = BrandReviewRepositoryImpl(
        BrandReviewRemoteDataSource(_dio(adapter)),
      );

      final pending = await repository.fetchBrands(
        BrandApplicationStatus.pending,
      );
      final active = await repository.fetchBrands(
        BrandApplicationStatus.approved,
      );

      expect(adapter.requests[0].path, '/admin/brand-applications');
      expect(adapter.requests[0].queryParameters, {'status': 'PENDING'});
      expect(adapter.requests[1].queryParameters, {'status': 'ACTIVE'});
      final brands = (pending as Ok<List<ReviewBrand>>).value;
      expect([for (final b in brands) b.id], ['new', 'old']);
      expect(brands.first.memberCount, 2);
      expect(brands.first.hasDocument, isTrue);
      expect(brands.last.memberCount, isNull);
      final activeBrand = (active as Ok<List<ReviewBrand>>).value.single;
      expect(activeBrand.status, BrandApplicationStatus.approved);
      expect((activeBrand.memberCount, activeBrand.hasDocument), (3, false));
    });

    test('decisions post to /admin/brands/:id/<action>', () async {
      final adapter = FakeHttpAdapter([
        for (var i = 0; i < 4; i++) json(201, {}),
      ]);
      final repository = BrandReviewRepositoryImpl(
        BrandReviewRemoteDataSource(_dio(adapter)),
      );

      await repository.approve('b1');
      await repository.reject('b1', 'Document unreadable');
      await repository.suspend('b1', 'Approving its own fakes');
      await repository.reinstate('b1');

      expect([
        for (final r in adapter.requests) r.method,
      ], everyElement('POST'));
      expect(
        [for (final r in adapter.requests) r.path],
        [
          '/admin/brands/b1/approve',
          '/admin/brands/b1/reject',
          '/admin/brands/b1/suspend',
          '/admin/brands/b1/reinstate',
        ],
      );
      expect(
        [for (final r in adapter.requests) r.data],
        [
          isEmpty,
          {'reason': 'Document unreadable'},
          {'reason': 'Approving its own fakes'},
          isEmpty,
        ],
      );
    });
  });

  group('disputes', () {
    test('lists oldest first with the claim; resolves with a note', () async {
      final adapter = FakeHttpAdapter([
        json(200, [
          {
            'id': 'd2',
            'claimId': 'c1',
            'status': 'OPEN',
            'message': 'Later message',
            'createdAt': '2026-11-22T09:00:00.000Z',
          },
          {
            'id': 'd1',
            'status': 'UPHELD',
            'message': 'This is the right shop.',
            'createdAt': '2026-11-21T09:00:00.000Z',
            'resolution': 'Receipt is for another product.',
            'resolvedAt': '2026-11-23T09:00:00.000Z',
            'claim': _claim(),
          },
        ]),
        json(201, {}),
      ]);
      final repository = DisputeRepositoryImpl(_dio(adapter));

      final result = await repository.fetchDisputes(DisputeStatus.open);
      await repository.resolve('d1', DisputeOutcome.overturn, 'Clear receipt.');

      expect(adapter.requests[0].path, '/admin/disputes');
      expect(adapter.requests[0].queryParameters, {'status': 'OPEN'});
      final disputes = (result as Ok<List<AdminDispute>>).value;
      expect([for (final d in disputes) d.id], ['d1', 'd2']);
      final first = disputes.first;
      expect(first.claimId, 'c1'); // from the claim when not sent
      expect(first.status, DisputeStatus.upheld);
      expect(first.claim?.product.name, 'Organic Cotton Tee');
      expect(first.resolution, 'Receipt is for another product.');
      expect(disputes.last.claim, isNull);
      expect(adapter.requests[1].path, '/admin/disputes/d1/resolve');
      expect(adapter.requests[1].data, {
        'outcome': 'OVERTURN',
        'note': 'Clear receipt.',
      });
    });
  });

  test('overrule posts the decision, then reads the claim again', () async {
    final adapter = FakeHttpAdapter([
      json(201, {'ok': true}),
      json(200, _claim(status: 'APPROVED')),
    ]);
    final repository = AdminClaimRepositoryImpl(
      AdminClaimRemoteDataSource(_dio(adapter), const AdminScope()),
    );

    final result = await repository.overrule(
      'c1',
      decision: ClaimStatus.approved,
      reason: 'Brand has no team.',
    );

    expect(adapter.requests[0].path, '/admin/claims/c1/override');
    expect(adapter.requests[0].data, {
      'decision': 'APPROVE',
      'reason': 'Brand has no team.',
    });
    expect(adapter.requests[1].path, '/claims/c1');
    expect(
      (result as Ok<ClaimDetail>).value.claim.status,
      ClaimStatus.approved,
    );
  });

  test('a claim with an open dispute is marked disputed', () {
    expect(
      ClaimDto.fromJson(_claim(dispute: {'status': 'OPEN'}))
          .toDomain()
          .isDisputed,
      isTrue,
    );
    expect(
      ClaimDto.fromJson(_claim(dispute: {'status': 'UPHELD'}))
          .toDomain()
          .isDisputed,
      isFalse,
    );
    expect(ClaimDto.fromJson(_claim()).toDomain().isDisputed, isFalse);
  });

  test('hide and show again use the admin path', () async {
    final adapter = FakeHttpAdapter([json(201, {}), json(201, {})]);
    final dio = _dio(adapter);
    final repository = AdminProductRepositoryImpl(
      AdminProductRemoteDataSource(dio, const AdminScope()),
      BrandsApi(dio),
      ProductEditorRemoteDataSource(dio, const AdminScope()),
    );

    await repository.setHidden('p1', hidden: true);
    await repository.setHidden('p1', hidden: false);

    expect(
      [for (final r in adapter.requests) r.path],
      ['/admin/products/p1/hide', '/admin/products/p1/unhide'],
    );
  });

  test('a product says whether it is hidden; absent means shown', () {
    Map<String, Object?> product({bool? hidden}) => {
      'id': 'p1',
      'gtin': '08901234500019',
      'sku': 'TT-TEE-01',
      'name': 'Organic Cotton Tee',
      'brand': const {'id': 'b1', 'name': 'Terra Threads'},
      'createdAt': '2026-11-01T10:00:00.000Z',
      'updatedAt': '2026-11-01T10:00:00.000Z',
      'hidden': ?hidden,
    };
    expect(
      ProductDto.fromJson(product(hidden: true)).toDomain().isHidden,
      true,
    );
    expect(ProductDto.fromJson(product()).toDomain().isHidden, false);
  });
}
