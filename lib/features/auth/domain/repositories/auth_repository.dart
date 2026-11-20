import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

/// Signing in and creating accounts. Session storage and sign-out live in
/// `core/auth`, because every feature depends on them.
abstract interface class AuthRepository {
  /// `UnauthorizedFailure` means the email and password don't match.
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  /// `ConflictFailure` means an account already uses this email.
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Emails a reset link (it opens the website). The API answers the same
  /// whether or not the email has an account.
  Future<Result<void>> requestPasswordReset({required String email});

  /// `UnauthorizedFailure` means [currentPassword] is wrong. On success the
  /// API revokes every session, including this one.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
