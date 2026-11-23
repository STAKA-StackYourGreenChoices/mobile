import 'package:staka/features/auth/domain/models/auth_session.dart';

/// What checking a text-message code gives back.
sealed class OtpVerification {
  const new();
}

/// The code was right: signed in. [isNewUser] when this made the account.
final class OtpSignedIn extends OtpVerification {
  const new(this.session, {required this.isNewUser});

  final AuthSession session;
  final bool isNewUser;
}

/// The code was right, but the number has no account yet: send the same
/// code again with a name to create it.
final class OtpNameRequired extends OtpVerification {
  const new();
}
