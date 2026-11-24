import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brand_review/presentation/state/brand_review_providers.dart';
import 'package:staka/features/manage/claims/presentation/widgets/pdf_receipt_view.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// A brand's business document full screen: a photo to pinch and zoom, or
/// the PDF, like a claim's receipt.
class BrandDocumentScreen extends ConsumerWidget {
  const new({required this.brandId, super.key});

  final String brandId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final document = ref.watch(brandDocumentProvider(brandId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.businessDocumentTitle)),
      backgroundColor: context.colors.surfaceSunken,
      body: switch (document) {
        AsyncData(value: Ok(:final value)) when value.isPdf => PdfReceiptView(
          bytes: value.bytes,
        ),
        AsyncData(value: Ok(:final value)) => InteractiveViewer(
          maxScale: 6,
          child: Center(
            child: Image.memory(
              value.bytes,
              semanticLabel: l10n.businessDocumentTitle,
              errorBuilder: (_, _, _) => Text(l10n.documentUnavailable),
            ),
          ),
        ),
        AsyncData(value: Err()) || AsyncError() => Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FeedbackMessage(
            icon: Icons.description_outlined,
            iconColor: context.colors.inkMuted,
            message: l10n.documentUnavailable,
          ),
        ),
        _ => const AppLoader(),
      },
    );
  }
}
