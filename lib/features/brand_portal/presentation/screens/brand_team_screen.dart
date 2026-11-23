import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/presentation/state/brand_team_controllers.dart';
import 'package:staka/features/brand_portal/presentation/widgets/brand_member_tile.dart';
import 'package:staka/features/brand_portal/presentation/widgets/invite_member_sheet.dart';
import 'package:staka/features/brand_portal/presentation/widgets/remove_member_dialog.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Who runs [brand] (`GET /brand/:brandId/members`), owners first. Owners
/// invite people and remove anyone but themselves (the API refuses to
/// remove the last owner). Changing a role isn't in the API yet.
class BrandTeamScreen extends ConsumerWidget {
  const new({required this.brand, super.key});

  final BrandMembership brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandMembersProvider(brand.id);
    final members = ref.watch(provider);
    final myId = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn ? session.user.id : null,
      ),
    );

    Future<void> invite() async {
      final who = await showInviteMemberSheet(context, brand: brand);
      if (who != null && context.mounted) {
        AppSnackbar.show(context, message: l10n.inviteSent(who));
      }
    }

    Future<void> remove(BrandMember member) async {
      final removed = await showRemoveMemberDialog(
        context,
        brand: brand,
        member: member,
      );
      if (removed && context.mounted) {
        AppSnackbar.show(context, message: l10n.memberRemoved(member.name));
      }
    }

    return AppScaffold(
      title: l10n.brandTeam,
      isScrollable: false,
      body: switch (members) {
        AsyncData(value: Ok(value: final members)) => RefreshIndicator(
          onRefresh: () => ref.refresh(provider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (brand.isOwner)
                AppButton(
                  label: l10n.inviteSomeone,
                  icon: Icons.person_add_alt_outlined,
                  isExpanded: true,
                  onPressed: invite,
                )
              else
                Text(
                  l10n.teamStaffNote,
                  style: context.text.bodyMedium.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.surfaceRaised,
                  border: Border.all(color: context.colors.border),
                  borderRadius: AppRadius.allMd,
                ),
                child: Column(
                  children: [
                    for (final (index, member) in members.indexed) ...[
                      if (index > 0)
                        Divider(height: 1, color: context.colors.border),
                      BrandMemberTile(
                        key: ValueKey(member.userId),
                        member: member,
                        isYou: member.userId == myId,
                        keepsActionSpace: brand.isOwner,
                        onRemovePressed: brand.isOwner && member.userId != myId
                            ? () => remove(member)
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        AsyncData(value: Err(:final failure)) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(provider),
        ),
        _ => const AppLoader(),
      },
    );
  }
}
