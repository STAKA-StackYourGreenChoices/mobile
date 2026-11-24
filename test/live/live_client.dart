import 'dart:math';

import 'package:dio/dio.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/cards/cards_api.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/manage/products/data/datasources/product_editor_remote_data_source.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/features/products/data/datasources/product_remote_data_source.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/tags/data/datasources/share_remote_data_source.dart';
import 'package:staka/features/tags/data/datasources/tag_remote_data_source.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';

import '../helpers/auth_fakes.dart';

/// The API address for live tests; empty means "skip".
const liveApiUrl = String.fromEnvironment('LIVE_API_URL');
final String? liveSkip = liveApiUrl.isEmpty ? 'Set LIVE_API_URL to run' : null;

/// The seeded admin, for tests that need one. Pass them with
/// `--dart-define=LIVE_ADMIN_EMAIL=…` and `--dart-define=LIVE_ADMIN_PASSWORD=…`
/// (from the header of api/src/prisma/seed.ts; never commit them).
const _adminEmail = String.fromEnvironment('LIVE_ADMIN_EMAIL');
const _adminPassword = String.fromEnvironment('LIVE_ADMIN_PASSWORD');
final String? liveAdminSkip =
    liveSkip ??
    (_adminPassword.isEmpty ? 'Set LIVE_ADMIN_PASSWORD to run' : null);

/// The app's real network stack (auth interceptor, single-flight refresh,
/// repositories) pointed at a running API, with in-memory token storage.
class LiveClient {
  new() {
    refresher = TokenRefresher(
      dio: buildDio(baseUrl: liveApiUrl),
      store: store,
      onRejected: () => rejections++,
    );
    final dio = buildDio(
      baseUrl: liveApiUrl,
      auth: (dio) =>
          AuthInterceptor(dio: dio, store: store, refresher: refresher),
    );
    this.dio = dio;
    auth = AuthRepositoryImpl(AuthRemoteDataSource(dio));
    wardrobe = WardrobeRepositoryImpl(
      CardsApi(dio),
      WardrobeRemoteDataSource(dio),
    );
    products = ProductRepositoryImpl(
      ProductRemoteDataSource(dio),
      CardsApi(dio),
    );
    tags = TagRepositoryImpl(
      TagRemoteDataSource(dio),
      ShareRemoteDataSource(dio, Dio()),
    );
    adminProducts = AdminProductRepositoryImpl(
      AdminProductRemoteDataSource(dio, const AdminScope()),
      BrandsApi(dio),
      ProductEditorRemoteDataSource(dio, const AdminScope()),
    );
    adminClaims = AdminClaimRepositoryImpl(
      AdminClaimRemoteDataSource(dio, const AdminScope()),
    );
    session = SessionRepository(dio, store);
  }

  /// Set by `signedUpClient`: this run's unique shopper.
  String email = '';
  final store = InMemoryTokenStore();
  late final TokenRefresher refresher;
  late final Dio dio;
  late final AuthRepositoryImpl auth;
  late final WardrobeRepositoryImpl wardrobe;
  late final ProductRepositoryImpl products;
  late final TagRepositoryImpl tags;
  late final AdminProductRepositoryImpl adminProducts;
  late final AdminClaimRepositoryImpl adminClaims;
  late final SessionRepository session;
  int rejections = 0;

  /// What the API answers when [refreshToken] is presented again.
  Future<int?> refreshStatus(String refreshToken) =>
      buildDio(baseUrl: liveApiUrl)
          .post<Object?>(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: publicRequest(),
          )
          .then(
            (response) => response.statusCode,
            onError: (Object e) => (e as DioException).response?.statusCode,
          );
}

/// A fresh address per run: `mobile-live-<ms>@example.com`.
String throwawayEmail() =>
    'mobile-live-${DateTime.now().microsecondsSinceEpoch}@example.com';

String randomPassword() {
  final random = Random.secure();
  return List.generate(
    20,
    (_) => 'abcdefghijkmnpqrstuvwxyz23456789'[random.nextInt(32)],
  ).join();
}

/// Registers a throwaway shopper and keeps their tokens, like sign-up does.
Future<LiveClient> signedUpClient() async {
  final client = LiveClient()..email = throwawayEmail();
  final result = await client.auth.register(
    name: 'Mobile Live Test',
    email: client.email,
    password: randomPassword(),
  );
  await client.session.saveTokens((result as Ok<AuthSession>).value.tokens);
  return client;
}

/// Signs in as the seeded admin (see [liveAdminSkip]).
Future<LiveClient> signedInAdmin() async {
  final admin = LiveClient();
  final login = await admin.auth.login(
    email: _adminEmail,
    password: _adminPassword,
  );
  await admin.session.saveTokens((login as Ok<AuthSession>).value.tokens);
  return admin;
}
