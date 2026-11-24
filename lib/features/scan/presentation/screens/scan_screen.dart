import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/scan/presentation/state/scan_camera_provider.dart';
import 'package:staka/features/scan/presentation/widgets/type_number_form.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Scan tab, the website's `/scan`: point the camera at a label, or
/// type the number under the bars. Either way the product opens.
class ScanScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final camera = ref.watch(scanCameraProvider);

    // `scan=1`: the product screen reports the lookup as a scan (V2-5).
    void open(String gtin) => context.pushNamed(
      AppRoute.product.name,
      pathParameters: {'gtin': gtin},
      queryParameters: const {'scan': '1'},
    );

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.scanTitle, style: context.text.headingLarge),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.scanLede,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          camera(onGtinFound: open),
          const SizedBox(height: AppSpacing.lg),
          TypeNumberForm(onGtinFound: open),
        ],
      ),
    );
  }
}
