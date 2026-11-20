import 'package:flutter/foundation.dart';

import 'package:staka/core/api_models/auth_response_dto.dart';

/// The API's token pair. Kept only in secure storage and memory, never in
/// logs, analytics or app state (guide §10.3, §15).
@immutable
class AuthTokens {
  const new({required this.accessToken, required this.refreshToken});

  factory fromResponse(AuthResponseDto response) => AuthTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );

  final String accessToken;
  final String refreshToken;

  @override
  bool operator ==(Object other) =>
      other is AuthTokens &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);
}
