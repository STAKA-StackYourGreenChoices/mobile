import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/auth_tokens.dart';

part 'token_store.g.dart';

/// Where the token pair lives between launches.
abstract interface class TokenStore {
  Future<AuthTokens?> read();
  Future<void> save(AuthTokens tokens);
  Future<void> clear();
}

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) =>
    SecureTokenStore(const FlutterSecureStorage());

/// Keychain / Android keystore-backed storage, with an in-memory copy so
/// every request doesn't hit the platform channel.
class SecureTokenStore implements TokenStore {
  new(this._storage);

  static const _accessKey = 'staka.accessToken';
  static const _refreshKey = 'staka.refreshToken';

  final FlutterSecureStorage _storage;
  AuthTokens? _cache;
  bool _loaded = false;

  @override
  Future<AuthTokens?> read() async {
    if (_loaded) return _cache;
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    _cache = access == null || refresh == null
        ? null
        : AuthTokens(accessToken: access, refreshToken: refresh);
    _loaded = true;
    return _cache;
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    _cache = tokens;
    _loaded = true;
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    _cache = null;
    _loaded = true;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
