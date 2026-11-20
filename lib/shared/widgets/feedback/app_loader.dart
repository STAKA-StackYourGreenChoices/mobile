import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

enum AppLoaderSize {
  /// Inline, next to text.
  sm,

  /// A screen or section that is loading.
  md,
}

/// The brand spinner, centred, announced as "Loading" to screen readers.
class AppLoader extends StatelessWidget {
  const new({this.size = AppLoaderSize.md, super.key});

  final AppLoaderSize size;

  @override
  Widget build(BuildContext context) {
    final dimension = switch (size) {
      AppLoaderSize.sm => AppSizes.iconInline,
      AppLoaderSize.md => AppSizes.iconFeature,
    };
    return Center(
      child: SizedBox.square(
        dimension: dimension,
        child: CircularProgressIndicator(
          color: context.colors.brandPrimary,
          strokeWidth: size == AppLoaderSize.sm ? 2 : 3,
          semanticsLabel: context.l10n.loading,
        ),
      ),
    );
  }
}
