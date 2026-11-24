import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/push/push_controller.dart';

part 'account_controller.g.dart';

/// The Account tab's one action. State is "signing out right now", so the
/// button can show it while the API revokes the refresh token.
@riverpod
class AccountController extends _$AccountController {
  @override
  bool build() => false;

  /// Like the website, a failed revoke never keeps the user signed in; the
  /// router then moves to the welcome screen.
  Future<void> signOut() async {
    if (state) return;
    final session = ref.read(sessionControllerProvider.notifier);
    state = true;
    // While the API still accepts the session: stop pushes to this phone.
    await ref.read(pushControllerProvider.notifier).beforeSignOut();
    await session.signOut();
  }
}
