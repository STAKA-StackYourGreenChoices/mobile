import 'package:staka/core/models/user.dart';

/// Who is using the app. The router decides every redirect from this alone.
sealed class SessionState {
  const new();
}

/// Launch: reading stored tokens and asking the API who they belong to.
final class SessionRestoring extends SessionState {
  const new();
}

final class SignedIn extends SessionState {
  const new(this.user);

  final User user;
}

final class SignedOut extends SessionState {
  const new({this.sessionExpired = false});

  /// True when the API ended the session (refresh token expired or revoked),
  /// so sign-in can say "Your session has ended. Sign in again."
  final bool sessionExpired;
}

/// Tokens exist but the API couldn't be reached at launch. The app is
/// online-only (decision 13), so it offers a retry instead of guessing.
final class SessionUnreachable extends SessionState {
  const new();
}
