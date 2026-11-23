import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';

/// One person on the team: name ("(you)" for the signed-in person), how
/// to reach them, their role, and Remove for owners.
class BrandMemberTile extends StatelessWidget {
  const new({
    required this.member,
    required this.isYou,
    this.onRemovePressed,
    this.keepsActionSpace = false,
    super.key,
  });

  final BrandMember member;
  final bool isYou;
  final VoidCallback? onRemovePressed;

  /// Leave Remove's room empty, so roles line up when other rows have it.
  final bool keepsActionSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final contact = switch (member) {
      BrandMember(:final String email) => email,
      BrandMember(:final String phone) => PhoneNumber.display(phone),
      _ => null,
    };
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? l10n.memberYou(member.name) : member.name,
                  style: context.text.bodyLarge,
                ),
                if (contact != null)
                  Text(
                    contact,
                    style: context.text.bodySmall.copyWith(
                      color: colors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            member.role == BrandRole.owner
                ? l10n.brandRoleOwner
                : l10n.brandRoleStaff,
            style: context.text.label.copyWith(color: colors.inkMuted),
          ),
          if (onRemovePressed case final onPressed?)
            IconButton(
              tooltip: l10n.removeFromTeam(member.name),
              onPressed: onPressed,
              icon: Icon(
                Icons.person_remove_outlined,
                color: colors.dangerText,
              ),
            )
          else
            SizedBox(
              width: keepsActionSpace ? AppSizes.minTapTarget : AppSpacing.xs,
            ),
        ],
      ),
    );
  }
}
