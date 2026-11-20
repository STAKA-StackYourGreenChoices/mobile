import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';

/// Asks where the receipt is: a new photo, an existing photo, or a PDF.
/// (On the website a single file input covers all three.) Null if the
/// shopper closes the sheet.
Future<ReceiptSource?> showReceiptSourceSheet(BuildContext context) {
  final l10n = context.l10n;
  return showModalBottomSheet<ReceiptSource>(
    context: context,
    // Over the whole app, like dialogs: the tab bar is covered too.
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (source, icon, label) in [
              (
                ReceiptSource.camera,
                Icons.photo_camera_outlined,
                l10n.takePhoto,
              ),
              (
                ReceiptSource.photos,
                Icons.photo_library_outlined,
                l10n.choosePhoto,
              ),
              (
                ReceiptSource.pdf,
                Icons.picture_as_pdf_outlined,
                l10n.choosePdf,
              ),
            ])
              ListTile(
                leading: Icon(icon),
                title: Text(label),
                onTap: () => Navigator.of(context).pop(source),
              ),
          ],
        ),
      ),
    ),
  );
}
