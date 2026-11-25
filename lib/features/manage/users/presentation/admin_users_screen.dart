import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/manage/users/data/admin_users_repository.dart';
import 'package:staka/features/manage/users/presentation/admin_users_controllers.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Admin → Users (V2-6): find a shopper by name, email or phone to see
/// and adjust their points.
class AdminUsersScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _search() => unawaited(
    ref.read(userSearchControllerProvider.notifier).search(_query.text),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.adminUsersTitle,
      isScrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          TextField(
            controller: _query,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: l10n.adminUsersSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                tooltip: l10n.adminUsersSearch,
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: _search,
              ),
            ),
          ),
          Expanded(
            child: UserSearchResults(
              state: ref.watch(userSearchControllerProvider),
              onRetry: _search,
              onUserPressed: (user) => context.goNamed(
                AppRoute.adminUser.name,
                pathParameters: {'id': user.id},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchResults extends StatelessWidget {
  const new({
    required this.state,
    required this.onRetry,
    required this.onUserPressed,
    super.key,
  });

  final UserSearchState state;
  final VoidCallback onRetry;
  final ValueChanged<AdminUser> onUserPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return switch (state) {
      UserSearchIdle() => AppEmptyState(
        icon: Icons.person_search_outlined,
        title: l10n.adminUsersIdleTitle,
        message: l10n.adminUsersIdleBody,
      ),
      UserSearchLoading() => const AppLoader(),
      UserSearchFailed(:final failure) => AppErrorState(
        failure: failure,
        onRetryPressed: onRetry,
      ),
      UserSearchDone(:final query, page: AdminUserPage(items: [])) =>
        AppEmptyState(
          icon: Icons.person_off_outlined,
          title: l10n.adminUsersNoneTitle,
          message: l10n.adminUsersNoneBody(query),
        ),
      UserSearchDone(:final page) => ListView(
        children: [
          for (final (index, user) in page.items.indexed) ...[
            if (index > 0) const Divider(height: 1),
            InkWell(
              onTap: () => onUserPressed(user),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: context.text.bodyLarge),
                            Text(
                              userContact(user),
                              style: context.text.bodySmall.copyWith(
                                color: colors.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l10n.pointsCount(user.pointsBalance),
                        style: context.text.label,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (page.total > page.items.length)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                l10n.adminUsersMore(
                  page.items.length,
                  NumberFormat.decimalPattern().format(page.total),
                ),
                textAlign: TextAlign.center,
                style: context.text.bodySmall.copyWith(color: colors.inkMuted),
              ),
            ),
        ],
      ),
    };
  }
}

/// Email and phone, whichever the shopper has.
String userContact(AdminUser user) => [
  ?user.email,
  if (user.phone case final phone?) PhoneNumber.display(phone),
].join(' · ');
