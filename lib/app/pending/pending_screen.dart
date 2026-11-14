import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// TEMPORARY. Stands in for a route whose screen arrives in a later slice,
/// so navigation can be built and tested first. Each feature slice replaces
/// one; PROGRESS.md lists those left. Must be deleted before Phase 5.
class PendingScreen extends StatelessWidget {
  const new({required this.route, super.key});

  final AppRoute route;

  @override
  Widget build(BuildContext context) => AppScaffold(
    body: AppEmptyState(
      icon: Icons.construction_rounded,
      title: context.l10n.pendingScreenTitle,
      message: route.path,
    ),
  );
}
