import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

enum PanelTone { success, info, muted }

/// A settled ownership status: icon, title and one paragraph, tinted by
/// [tone] — the website's ownership `Panel`.
class StatusPanel extends StatelessWidget {
  const new({
    required this.tone,
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final PanelTone tone;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = switch (tone) {
      PanelTone.success => colors.success,
      PanelTone.info => colors.brandPrimary,
      PanelTone.muted => colors.inkMuted,
    };
    final isMuted = tone == PanelTone.muted;
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isMuted
              ? colors.surfaceRaised
              : accent.withValues(alpha: 0.08),
          border: Border.all(
            color: isMuted ? colors.border : accent.withValues(alpha: 0.35),
          ),
          borderRadius: AppRadius.allMd,
        ),
        child: Padding(
          padding: AppSpacing.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Icon(icon, size: AppSizes.iconInline, color: accent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(title, style: context.text.headingSmall),
                    Text(
                      body,
                      style: context.text.bodyMedium.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
