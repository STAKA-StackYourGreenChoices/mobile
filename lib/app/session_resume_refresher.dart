import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:staka/core/auth/session_controller.dart';

/// Re-reads the signed-in user whenever the app returns to the foreground,
/// so e.g. confirming the email on the website (decision 7) shows up here.
class SessionResumeRefresher extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SessionResumeRefresher> createState() =>
      _SessionResumeRefresherState();
}

class _SessionResumeRefresherState
    extends ConsumerState<SessionResumeRefresher> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () =>
          ref.read(sessionControllerProvider.notifier).refreshUser(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
