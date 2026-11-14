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
  const new(this.user, {this.isNewAccount = false});

  final User user;

  /// True right after registering, so the wardrobe can greet them and say
  /// a confirmation email was sent (the website's `/wardrobe?welcome=1`).
  final bool isNewAccount;
}

/// Why the app signed someone out without them asking. Sign-in explains it.
enum SignedOutReason {
  /// The API refused the refresh token (expired or revoked).
  sessionExpired,

  /// The password was changed but signing back in on this phone failed.
  passwordChanged,
}

final class SignedOut extends SessionState {
  const new({this.reason});

  /// Null when the user signed out themselves.
  final SignedOutReason? reason;

  bool get sessionExpired => reason == SignedOutReason.sessionExpired;
}

/// Tokens exist but the API couldn't be reached at launch. The app is
/// online-only (decision 13), so it offers a retry instead of guessing.
final class SessionUnreachable extends SessionState {
  const new();
}
