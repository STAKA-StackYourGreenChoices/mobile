@Tags(['live'])
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

import 'live_client.dart';

/// Sharing against a running API (see auth_live_test). Sharing needs a
/// verified owner, so an admin approves a receipt first. Pass the seeded
/// admin with `--dart-define=LIVE_ADMIN_EMAIL=…` and
/// `--dart-define=LIVE_ADMIN_PASSWORD=…` (from the header of
/// api/src/prisma/seed.ts; never commit them).
const _adminEmail = String.fromEnvironment('LIVE_ADMIN_EMAIL');
const _adminPassword = String.fromEnvironment('LIVE_ADMIN_PASSWORD');

void main() {
  final skip =
      liveSkip ??
      (_adminPassword.isEmpty ? 'Set LIVE_ADMIN_PASSWORD to run' : null);

  final png = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
    '60e6kgAAAABJRU5ErkJggg==',
  );

  test(
    'unverified is refused; once approved: share, public page, stop',
    () async {
      final shopper = await signedUpClient();
      final added = await shopper.products.addToWardrobe('8901234500019');
      final cardId = (added as Ok<DigitalCard>).value.id;

      // Not proven yet: the API refuses to share.
      final early = await shopper.tags.share(cardId);
      expect((early as Err<ShareLink>).failure, isA<ConflictFailure>());

      // Receipt in, then the seeded admin approves it.
      await shopper.tags.uploadReceipt(
        cardId,
        PickedReceipt(name: 'receipt.png', bytes: png),
      );
      await _approveClaimOf(shopper.email);
      final tag = await shopper.tags.fetchTag(cardId);
      expect(
        (tag as Ok<DigitalCard>).value.ownership.status,
        OwnershipStatus.verified,
      );

      // Share: a slug the public page (which the website reads) answers for.
      final shared = await shopper.tags.share(cardId);
      final slug = (shared as Ok<ShareLink>).value.slug;
      final public = await _publicTag(slug);
      expect(public.statusCode, 200);
      expect((public.data! as Map)['ownerFirstName'], 'Mobile');

      // Stop: the old link no longer works.
      expect(await shopper.tags.stopSharing(cardId), isA<Ok<void>>());
      expect((await _publicTag(slug)).statusCode, 404);
    },
    skip: skip,
  );
}

/// The public tag as the website fetches it. The full address is written
/// out because `liveApiUrl` is a compile-time constant: passed as a
/// `baseUrl` it looks like the default to the analyzer, and `dart fix`
/// would delete it.
Future<Response<Object?>> _publicTag(String slug) => Dio(
  BaseOptions(validateStatus: (_) => true),
).get<Object?>('$liveApiUrl/public/tags/$slug', options: publicRequest());

/// Signs in as the seeded admin and approves this run's shopper's pending
/// receipt. Matched by their unique email: earlier runs leave pending
/// claims from other throwaway shoppers with the same name.
Future<void> _approveClaimOf(String email) async {
  final admin = LiveClient();
  final login = await admin.auth.login(
    email: _adminEmail,
    password: _adminPassword,
  );
  await admin.session.saveTokens((login as Ok<AuthSession>).value.tokens);
  final claims = await admin.dio.get<Map<String, dynamic>>(
    '/claims',
    queryParameters: {'status': 'PENDING', 'limit': 100},
  );
  final items = (claims.data!['items'] as List).cast<Map<String, dynamic>>();
  final mine = items.firstWhere(
    (claim) => (claim['user'] as Map)['email'] == email,
  );
  await admin.dio.post<Object?>('/claims/${mine['id']}/approve');
}
