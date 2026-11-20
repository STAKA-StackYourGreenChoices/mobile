import 'package:flutter/foundation.dart';

import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/models/user.dart';

/// What signing in or registering gives back: who it is, and their tokens.
@immutable
class AuthSession {
  const new({required this.tokens, required this.user});

  final AuthTokens tokens;
  final User user;
}
