import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_photo_area.dart';

/// A product photo from the network, for the hang tag's photo area. The
/// seeded catalog uses SVG illustrations, brands may upload raster photos;
/// both are cached. Decorative for screen readers: the tag names the piece.
class TagImage extends StatelessWidget {
  const new(this.url, {super.key});

  final String url;

  bool get _isSvg =>
      Uri.tryParse(url)?.path.toLowerCase().endsWith('.svg') ?? false;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(color: context.colors.surfaceSunken);
    return ExcludeSemantics(
      child: _isSvg
          ? SvgPicture.network(
              url,
              fit: BoxFit.cover,
              placeholderBuilder: (_) => placeholder,
              errorBuilder: (_, _, _) => const _ImageUnavailable(),
            )
          : LayoutBuilder(
              builder: (context, constraints) => CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                // Decode at the size shown, not the size uploaded (guide §11).
                memCacheWidth: constraints.maxWidth.isFinite
                    ? (constraints.maxWidth *
                              MediaQuery.devicePixelRatioOf(context))
                          .round()
                    : null,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => const _ImageUnavailable(),
              ),
            ),
    );
  }
}

/// A real error state, never a broken-image glyph (guide §6.4).
class _ImageUnavailable extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) =>
      PhotoPlaceholder(message: context.l10n.imageUnavailable);
}
