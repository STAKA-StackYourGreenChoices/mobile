import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/user.dart';

part 'session_controller.g.dart';

/// Owns the signed-in state for the whole app. Restores the session on
/// launch; sign-in screens hand it new tokens; any screen can sign out.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  SessionState build() {
    unawaited(Future.microtask(restore));
    return const SessionRestoring();
  }

  SessionRepository get _repository => ref.read(sessionRepositoryProvider);

  /// Launch, and the retry button when the API was unreachable.
  Future<void> restore() async {
    state = const SessionRestoring();
    if (!await _repository.hasTokens()) {
      state = const SignedOut();
      return;
    }
    await _loadUser(whenUnreachable: const SessionUnreachable());
  }

  /// Called by login and register (with [isNewAccount]) with the API's
  /// response.
  Future<void> signIn({
    required AuthTokens tokens,
    required User user,
    bool isNewAccount = false,
  }) async {
    await _repository.saveTokens(tokens);
    state = SignedIn(user, isNewAccount: isNewAccount);
  }

  /// Re-reads the user, e.g. on app resume after confirming the email on
  /// the website. Offline, the current user is kept as is.
  Future<void> refreshUser() async {
    final current = state;
    if (current is! SignedIn) return;
    await _loadUser(
      whenUnreachable: current,
      isNewAccount: current.isNewAccount,
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const SignedOut();
  }

  /// The API refused the refresh token: tokens are already cleared.
  void onSessionExpired() =>
      state = const SignedOut(reason: SignedOutReason.sessionExpired);

  /// After a password change the API has already revoked every session,
  /// so there is nothing to revoke here: forget the tokens and ask for the
  /// new password.
  Future<void> signOutAfterPasswordChange() async {
    await _repository.clearTokens();
    state = const SignedOut(reason: SignedOutReason.passwordChanged);
  }

  Future<void> _loadUser({
    required SessionState whenUnreachable,
    bool isNewAccount = false,
  }) async {
    final result = await _repository.currentUser();
    state = await result.fold(
      onSuccess: (user) async => SignedIn(user, isNewAccount: isNewAccount),
      onFailure: (failure) async => switch (failure) {
        UnauthorizedFailure() ||
        ForbiddenFailure() ||
        NotFoundFailure() => await _expire(),
        _ => whenUnreachable,
      },
    );
  }

  Future<SessionState> _expire() async {
    await _repository.clearTokens();
    return const SignedOut(reason: SignedOutReason.sessionExpired);
  }
}
