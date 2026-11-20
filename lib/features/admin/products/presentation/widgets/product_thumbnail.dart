import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// The 44 dp product photo in a list row, or a shirt when there is none
/// (the website's `Thumb`).
class ProductThumbnail extends StatelessWidget {
  const new({required this.imageUrl, super.key});

  final String? imageUrl;

  static const _size = 44.0;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.allSm,
    child: SizedBox.square(
      dimension: _size,
      child: ColoredBox(
        color: context.colors.surfaceSunken,
        child: switch (imageUrl) {
          final url? => TagImage(url),
          null => Icon(
            Icons.checkroom_rounded,
            size: AppSizes.iconInline,
            color: context.colors.inkMuted,
          ),
        },
      ),
    ),
  );
}
