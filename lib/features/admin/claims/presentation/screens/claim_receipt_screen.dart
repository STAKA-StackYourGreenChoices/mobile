import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/claims/presentation/state/claim_receipt_provider.dart';
import 'package:staka/features/admin/claims/presentation/widgets/pdf_receipt_view.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// A claim's receipt full screen: a photo to pinch and zoom, or the PDF
/// (the website opens both in a new tab).
class ClaimReceiptScreen extends ConsumerWidget {
  const new({required this.claimId, super.key});

  final String claimId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final receipt = ref.watch(claimReceiptProvider(claimId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptViewerTitle)),
      backgroundColor: context.colors.surfaceSunken,
      body: switch (receipt) {
        AsyncData(value: Ok(:final value)) when value.isPdf => PdfReceiptView(
          bytes: value.bytes,
        ),
        AsyncData(value: Ok(:final value)) => InteractiveViewer(
          maxScale: 6,
          child: Center(
            child: Image.memory(
              value.bytes,
              errorBuilder: (_, _, _) => Text(l10n.receiptUnavailable),
            ),
          ),
        ),
        AsyncData(value: Err()) || AsyncError() => Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FeedbackMessage(
            icon: Icons.receipt_long_outlined,
            iconColor: context.colors.inkMuted,
            message: l10n.receiptUnavailable,
          ),
        ),
        _ => const AppLoader(),
      },
    );
  }
}
