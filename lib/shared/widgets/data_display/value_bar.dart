import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// A name and its figure over a bar as long as its [share] of the largest
/// (our own bars, no chart package: V2-5). Tag stats and analytics.
class ValueBar extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.share,
    this.color,
    this.caption,
    super.key,
  });

  final String label;
  final String value;

  /// 0 to 1.
  final double share;

  /// The bar's colour; the brand primary by default.
  final Color? color;

  /// A line under the bar, e.g. how many dropped off before the next step.
  final String? caption;

  static const _height = 6.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xxs,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.bodyMedium)),
              Text(value, style: context.text.label),
            ],
          ),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_height / 2),
              child: SizedBox(
                height: _height,
                child: ColoredBox(
                  color: colors.surfaceSunken,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: share.isFinite ? share.clamp(0, 1) : 0,
                      heightFactor: 1,
                      child: ColoredBox(color: color ?? colors.brandPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (caption case final caption?)
            Text(
              caption,
              style: context.text.bodySmall.copyWith(color: colors.inkMuted),
            ),
        ],
      ),
    );
  }
}
