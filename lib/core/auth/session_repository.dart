import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/token_store.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';

part 'session_repository.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) =>
    SessionRepository(ref.watch(dioProvider), ref.watch(tokenStoreProvider));

/// Session data access: stored tokens, `GET /auth/me`, `POST /auth/logout`.
class SessionRepository {
  new(this._dio, this._store);

  final Dio _dio;
  final TokenStore _store;

  Future<bool> hasTokens() async => await _store.read() != null;

  Future<void> saveTokens(AuthTokens tokens) => _store.save(tokens);

  Future<void> clearTokens() => _store.clear();

  Future<Result<User>> currentUser() => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return UserDto.fromJson(response.data!).toDomain();
  });

  /// Revokes the refresh token on the server, then forgets both tokens.
  /// Like the website, a failed revoke never keeps the user signed in.
  Future<void> signOut() async {
    final tokens = await _store.read();
    if (tokens != null) {
      await guardApi(
        () => _dio.post<void>(
          '/auth/logout',
          data: {'refreshToken': tokens.refreshToken},
          options: publicRequest(),
        ),
      );
    }
    await _store.clear();
  }
}
