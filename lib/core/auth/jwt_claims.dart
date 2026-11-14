import 'dart:convert';

/// Reads the expiry from an access token without verifying it, like the
/// website's `decodeClaims`. Safe because it only decides *when* to refresh;
/// the API verifies the signature on every call.
///
/// Returns null for anything that isn't a readable JWT.
DateTime? accessTokenExpiry(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    if (payload is! Map<String, dynamic>) return null;
    final exp = payload['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  } on FormatException {
    return null;
  }
}

/// True when the token's known expiry is within [leeway] of [now]. The
/// website refreshes 30 s early; so does the app.
///
/// An unreadable token is NOT treated as expiring: refreshing before every
/// request would burn single-use refresh tokens. A 401 still triggers the
/// refresh for it.
bool isExpiringSoon(
  String token, {
  required DateTime now,
  Duration leeway = const Duration(seconds: 30),
}) {
  final expiry = accessTokenExpiry(token);
  return expiry != null && expiry.difference(now) < leeway;
}
