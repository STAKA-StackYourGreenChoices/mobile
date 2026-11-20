import 'dart:async';

import 'package:dio/dio.dart';

import 'package:staka/core/api_models/auth_response_dto.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/token_store.dart';

/// Swaps the refresh token for a new pair via `POST /auth/refresh`.
///
/// The API rotates refresh tokens and each works exactly once, so two
/// refreshes with the same token would sign the user out. Every caller that
/// arrives while a refresh is running therefore gets the same [Future]
/// (single flight), like the website's `proxy.ts`.
class TokenRefresher {
  new({required this._dio, required this._store, required this._onRejected});

  /// Must be a client WITHOUT the auth interceptor, or a failing refresh
  /// would try to refresh itself.
  final Dio _dio;
  final TokenStore _store;
  final void Function() _onRejected;
  Future<String?>? _inFlight;

  /// The new access token, or null when no refresh happened. Tokens are
  /// cleared and `onRejected` fires only when the API refused the refresh
  /// token; a network error keeps the session so the user can retry.
  Future<String?> refresh() {
    return _inFlight ??= _refresh().whenComplete(() => _inFlight = null);
  }

  Future<String?> _refresh() async {
    final current = await _store.read();
    if (current == null) return null;
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': current.refreshToken},
      );
      final tokens = AuthTokens.fromResponse(
        AuthResponseDto.fromJson(response.data!),
      );
      await _store.save(tokens);
      return tokens.accessToken;
    } on DioException catch (error) {
      if (_isRejection(error)) {
        await _store.clear();
        _onRejected();
      }
      return null;
    }
  }

  /// 400 or 401 from the API: the token is expired, used or revoked.
  bool _isRejection(DioException error) {
    final status = error.response?.statusCode;
    return status == 400 || status == 401;
  }
}
