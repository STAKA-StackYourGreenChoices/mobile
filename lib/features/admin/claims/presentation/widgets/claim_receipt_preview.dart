import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/features/admin/claims/presentation/state/claim_receipt_provider.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// The receipt on the review page: the photo (tap for full size), a card
/// opening the PDF, or why there is none (an order match).
class ClaimReceiptPreview extends StatelessWidget {
  const new({required this.claim, required this.onOpenPressed, super.key});

  final Claim claim;

  /// Opens the full-screen viewer.
  final VoidCallback onOpenPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!claim.hasReceipt) {
      return _Panel(
        child: Text(
          l10n.noReceiptOrder(claim.orderId ?? l10n.orderOnRecord),
          style: context.text.bodyLarge.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      );
    }
    if (claim.isPdf) return _PdfCard(onPressed: onOpenPressed);
    return _ReceiptPhoto(claim: claim, onPressed: onOpenPressed);
  }
}

class _ReceiptPhoto extends ConsumerWidget {
  const new({required this.claim, required this.onPressed});

  final Claim claim;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final receipt = ref.watch(claimReceiptProvider(claim.id));
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        ClipRRect(
          borderRadius: AppRadius.allMd,
          child: ColoredBox(
            color: context.colors.surfaceSunken,
            child: switch (receipt) {
              AsyncData(value: Ok(:final value)) => Semantics(
                image: true,
                button: true,
                label: l10n.receiptImageLabel(claim.user.name),
                excludeSemantics: true,
                child: InkWell(
                  onTap: onPressed,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    // Full width, its own shape, never taller than 75 %
                    // of the screen (the website's `max-h-[75vh]`).
                    child: Image.memory(
                      value.bytes,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          _Panel(child: Text(l10n.receiptUnavailable)),
                    ),
                  ),
                ),
              ),
              AsyncData(value: Err()) ||
              AsyncError() => _Panel(child: Text(l10n.receiptUnavailable)),
              _ => const SizedBox(height: 200, child: AppLoader()),
            },
          ),
        ),
        if (receipt case AsyncData(value: Ok()))
          Row(
            spacing: AppSpacing.xxs,
            children: [
              Icon(
                Icons.open_in_full_rounded,
                size: AppSpacing.md - 2,
                color: context.colors.inkMuted,
              ),
              Expanded(
                child: Text(
                  l10n.tapReceiptFullSize,
                  style: context.text.bodySmall.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PdfCard extends StatelessWidget {
  const new({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceRaised,
      borderRadius: AppRadius.allMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: DashedBorder(
          color: colors.borderStrong,
          radius: AppRadius.md.x,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 160),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: AppSizes.iconFeature + AppSpacing.xxs,
                    color: colors.brandPrimary,
                  ),
                  Text(
                    context.l10n.openPdfReceipt,
                    textAlign: TextAlign.center,
                    style: context.text.label.copyWith(
                      color: colors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceRaised,
      border: Border.all(color: context.colors.border),
      borderRadius: AppRadius.allMd,
    ),
    child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: child),
  );
}
