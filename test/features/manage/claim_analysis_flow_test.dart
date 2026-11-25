import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Admin → Claims, or Brand → Claims with [asBrand].
Future<void> _openClaims(
  WidgetTester tester,
  FakeAdminClaimRepository claims, {
  bool asBrand = false,
}) async {
  usePhoneScreen(tester, height: 2400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(
        200,
        asBrand ? memberUserJson([membershipJson()]) : userJson(role: 'ADMIN'),
      ),
    ],
    adminClaims: claims,
  );
  await _tap(
    tester,
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(asBrand ? 'Brand' : 'Admin'),
    ),
  );
  await _tap(tester, find.text('Claims'));
}

/// The queue holds [claim]; its page has [analysis]; claim 9 is the
/// earlier one with the same receipt.
FakeAdminClaimRepository _queueWith(Claim claim, {ReceiptAnalysis? analysis}) {
  final earlier = claimFor(
    9,
    status: ClaimStatus.rejected,
    productName: 'Hemp Overshirt',
  );
  return FakeAdminClaimRepository(
    pages: (request) => Ok(
      request.status == claim.status
          ? ClaimPage(items: [claim], total: 1)
          : const ClaimPage(items: [], total: 0),
    ),
    details: {
      claim.id: detailOf(claim, analysis: analysis),
      earlier.id: detailOf(earlier),
    },
    receipts: {
      claim.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
    },
    products: {'p1': Ok(productNamed('Organic Cotton Tee'))},
  );
}

void main() {
  group('list', () {
    testWidgets('score and reused receipt on each claim', (tester) async {
      await _openClaims(
        tester,
        _queueWith(claimFor(1, score: 34, isDuplicate: true)),
      );

      expect(find.text('Score 34'), findsOneWidget);
      expect(find.text('Reused receipt'), findsOneWidget);
    });

    testWidgets('Best match asks for the list by score', (tester) async {
      final claims = _queueWith(claimFor(1, score: 91));
      await _openClaims(tester, claims, asBrand: true);

      expect(claims.sorts.last, ClaimSort.newest);
      await _tap(tester, find.text('Best match'));

      expect(claims.sorts.last, ClaimSort.score);
      expect(claims.requests.last.page, 1);
    });
  });

  group('Automatic check', () {
    testWidgets('a brand sees what was read and the reused flag only', (
      tester,
    ) async {
      final claim = claimFor(1);
      await _openClaims(
        tester,
        _queueWith(claim, analysis: sampleAnalysis),
        asBrand: true,
      );
      await _tap(tester, find.text(claim.product.name));

      expect(find.text('Automatic check'), findsOneWidget);
      expect(find.text('Terra Threads, Bandra West'), findsOneWidget);
      expect(find.text('2 Nov 2026'), findsOneWidget);
      expect(find.text('₹1,299.00'), findsOneWidget);
      expect(find.text('Match score 64 of 100'), findsOneWidget);
      expect(
        find.text('This receipt was used before, for another claim.'),
        findsOneWidget,
      );
      expect(find.text('Open the earlier claim'), findsNothing);
      // Above the decision.
      expect(
        tester.getTopLeft(find.text('Automatic check')).dy,
        lessThan(tester.getTopLeft(find.text('Approve')).dy),
      );
    });

    testWidgets('an admin can open the earlier claim', (tester) async {
      final claim = claimFor(1);
      await _openClaims(tester, _queueWith(claim, analysis: sampleAnalysis));
      await _tap(tester, find.text(claim.product.name));

      await _tap(tester, find.text('Open the earlier claim'));

      expect(find.textContaining('Hemp Overshirt'), findsWidgets);
    });

    testWidgets('still checking, and a receipt it could not read', (
      tester,
    ) async {
      final claim = claimFor(1);
      await _openClaims(
        tester,
        _queueWith(
          claim,
          analysis: const ReceiptAnalysis(status: AnalysisStatus.pending),
        ),
        asBrand: true,
      );
      await _tap(tester, find.text(claim.product.name));

      expect(find.textContaining('Still checking'), findsOneWidget);
      expect(find.text('Shop'), findsNothing);
    });

    testWidgets('no card for a claim sent before the check', (tester) async {
      final claim = claimFor(1);
      await _openClaims(tester, _queueWith(claim), asBrand: true);
      await _tap(tester, find.text(claim.product.name));

      expect(find.text('Automatic check'), findsNothing);
    });
  });

  group('reading the API', () {
    AdminClaimRemoteDataSource source(FakeHttpAdapter adapter) =>
        AdminClaimRemoteDataSource(
          Dio(BaseOptions(baseUrl: 'http://api.test'))
            ..httpClientAdapter = adapter,
          const BrandScope('b1'),
        );

    Map<String, Object?> claimJson({Map<String, Object?> extra = const {}}) => {
      'id': 'c1',
      'method': 'RECEIPT',
      'status': 'PENDING',
      'createdAt': '2026-11-12T10:00:00.000Z',
      'hasReceipt': true,
      'user': {'id': 'u1', 'name': 'Ada', 'email': null},
      'product': {
        'id': 'p1',
        'name': 'Tee',
        'gtin': '1',
        'sku': 's',
        'brandName': 'Terra Threads',
      },
      ...extra,
    };

    test('the list by score, with score and isDuplicate', () async {
      final adapter = FakeHttpAdapter([
        json(200, {
          'items': [
            claimJson(extra: {'score': 34, 'isDuplicate': true}),
          ],
          'total': 1,
        }),
      ]);

      final page = await source(adapter)
          .list(ClaimStatus.pending, 1, sort: ClaimSort.score);

      expect(adapter.requests.single.uri.path, '/brand/b1/claims');
      expect(adapter.requests.single.uri.queryParameters['sort'], 'score');
      expect(page.items.single.score, 34);
      expect(page.items.single.isDuplicate, isTrue);
    });

    test('newest sends no sort; old claims read without V2-8 fields', () async {
      final adapter = FakeHttpAdapter([
        json(200, {
          'items': [claimJson()],
          'total': 1,
        }),
      ]);

      final page = await source(adapter).list(ClaimStatus.pending, 1);

      expect(
        adapter.requests.single.uri.queryParameters,
        isNot(contains('sort')),
      );
      expect(page.items.single.score, isNull);
      expect(page.items.single.isDuplicate, isFalse);
    });

    test('the detail reads the analysis, total as a string', () async {
      final adapter = FakeHttpAdapter([
        json(
          200,
          claimJson(
            extra: {
              'history': <Object>[],
              'analysis': {
                'status': 'DONE',
                'merchant': 'Terra Threads',
                'purchaseDate': '2026-11-02',
                'total': '1299.50',
                'brandMatched': true,
                'productMatched': null,
                'dateOk': false,
                'duplicateOfClaimId': null,
                'score': 71,
              },
            },
          ),
        ),
      ]);

      final detail = await source(adapter).detail('c1');
      final analysis = detail.analysis!;

      expect(analysis.status, AnalysisStatus.done);
      expect(analysis.total, 1299.5);
      expect(analysis.purchaseDate, DateTime(2026, 11, 2));
      expect(analysis.productMatched, isNull);
      expect(analysis.dateOk, isFalse);
      expect(analysis.isDuplicate, isFalse);
      expect(analysis.score, 71);
    });
  });
}
