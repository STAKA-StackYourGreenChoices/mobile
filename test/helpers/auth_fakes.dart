import 'dart:convert';

import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/token_store.dart';

class InMemoryTokenStore implements TokenStore {
  new([this.tokens]);

  AuthTokens? tokens;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> save(AuthTokens tokens) async => this.tokens = tokens;

  @override
  Future<void> clear() async => tokens = null;
}

/// An unsigned JWT whose payload carries [exp] (and a marker to tell
/// tokens apart). Good enough: the app never verifies signatures.
String fakeJwt({required DateTime exp, String marker = 'a'}) {
  String part(Object json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final seconds = exp.toUtc().millisecondsSinceEpoch ~/ 1000;
  return '${part({'alg': 'none'})}.${part({'exp': seconds, 'm': marker})}.sig';
}

final farFuture = DateTime.utc(2099);

Map<String, Object?> userJson({
  String role = 'USER',
  bool emailVerified = true,
}) => {
  'id': 'u1',
  'email': 'ada@example.com',
  'name': 'Ada Lovelace',
  'role': role,
  'emailVerified': emailVerified,
  'phone': null,
  'status': 'ACTIVE',
};

Map<String, Object?> authJson({
  required String access,
  String refresh = 'r2',
}) => {'accessToken': access, 'refreshToken': refresh, 'user': userJson()};
