import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/features/admin/claims/presentation/state/admin_claims_controller.dart';
import 'package:staka/features/admin/claims/presentation/widgets/claims_scroll_view.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/claims`: claims to review (oldest first), and
/// those already approved or rejected.
class AdminClaimsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminClaimsScreen> createState() => _AdminClaimsScreenState();
}

class _AdminClaimsScreenState extends ConsumerState<AdminClaimsScreen> {
  /// Kept while a claim is open above this page, like the website's
  /// `?status=` back link.
  ClaimStatus _status = ClaimStatus.pending;

  @override
  Widget build(BuildContext context) {
    final list = adminClaimsControllerProvider(_status);
    final controller = ref.read(list.notifier);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: ClaimsScrollView(
        status: _status,
        state: ref.watch(list),
        onStatusSelected: (status) => setState(() => _status = status),
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onLoadMore: controller.loadMore,
        onClaimPressed: (claim) => context.goNamed(
          AppRoute.adminClaim.name,
          pathParameters: {'id': claim.id},
        ),
      ),
    );
  }
}
