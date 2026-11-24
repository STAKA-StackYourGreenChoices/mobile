import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/admin_claims_controller.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claims_scroll_view.dart';
import 'package:staka/features/manage/shared/manage_routes.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/claims`: claims to review (oldest first), and
/// those already approved or rejected.
class AdminClaimsScreen extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  /// Admin (every brand) or one brand's team.
  final ManageScope scope;

  @override
  ConsumerState<AdminClaimsScreen> createState() => _AdminClaimsScreenState();
}

class _AdminClaimsScreenState extends ConsumerState<AdminClaimsScreen> {
  /// Kept while a claim is open above this page, like the website's
  /// `?status=` back link.
  ClaimStatus _status = ClaimStatus.pending;

  @override
  Widget build(BuildContext context) {
    final list = adminClaimsControllerProvider(widget.scope, _status);
    final controller = ref.read(list.notifier);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: ClaimsScrollView(
        description: switch (widget.scope) {
          AdminScope() => context.l10n.adminClaimsDescription,
          BrandScope() => context.l10n.brandClaimsDescription,
        },
        status: _status,
        state: ref.watch(list),
        onStatusSelected: (status) => setState(() => _status = status),
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onLoadMore: controller.loadMore,
        onClaimPressed: (claim) => context.goNamed(
          widget.scope.claimRoute.name,
          pathParameters: {'id': claim.id},
        ),
      ),
    );
  }
}
