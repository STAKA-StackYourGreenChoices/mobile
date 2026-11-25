import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/rewards/domain/reward.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// The brand's logo in a circle, or its first letter when there is none.
class BrandLogo extends StatelessWidget {
  const new({required this.name, this.url, this.size = 40, super.key});

  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = Center(
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: context.text.label.copyWith(color: colors.inkMuted),
      ),
    );
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: ClipOval(
          child: ColoredBox(
            color: colors.surfaceSunken,
            child: switch (url) {
              final url? when url.isNotEmpty => CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                placeholder: (_, _) => const SizedBox.shrink(),
                errorWidget: (_, _, _) => initial,
              ),
              _ => initial,
            },
          ),
        ),
      ),
    );
  }
}

/// The vouchers on the Rewards tab, two to a row.
class RewardsGrid extends StatelessWidget {
  const new({
    required this.rewards,
    required this.onRewardPressed,
    this.balance,
    super.key,
  });

  final List<Reward> rewards;

  /// For "N more points"; null when the balance isn't known.
  final int? balance;
  final ValueChanged<Reward> onRewardPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < rewards.length; i += 2)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.sm,
              children: [
                for (final reward in rewards.skip(i).take(2))
                  Expanded(
                    child: RewardCard(
                      reward: reward,
                      balance: balance,
                      onPressed: () => onRewardPressed(reward),
                    ),
                  ),
                if (i + 1 >= rewards.length) const Spacer(),
              ],
            ),
          ),
      ],
    );
  }
}

/// One voucher: brand, what it's worth, what it costs, and whether the
/// shopper can have it.
class RewardCard extends StatelessWidget {
  const new({
    required this.reward,
    required this.onPressed,
    this.balance,
    super.key,
  });

  final Reward reward;
  final int? balance;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final short = rewardShortfall(reward, balance);
    final status = switch (reward) {
      Reward(inStock: false) => (l10n.rewardOutOfStock, colors.inkMuted),
      _ when short > 0 => (l10n.rewardNeedMore(short), colors.inkMuted),
      _ => null,
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxs,
            children: [
              Row(
                spacing: AppSpacing.xs,
                children: [
                  BrandLogo(
                    name: reward.brandName,
                    url: reward.brandLogoUrl,
                    size: 32,
                  ),
                  Expanded(
                    child: Text(
                      reward.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(reward.valueText, style: context.text.headingSmall),
              if (reward.title != reward.valueText)
                Text(
                  reward.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall,
                ),
              const Spacer(),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.pointsCount(reward.pointsCost),
                style: context.text.label.copyWith(color: colors.brandPrimary),
              ),
              if (status case (final text, final color))
                Text(
                  text,
                  style: context.text.bodySmall.copyWith(color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How many points short the shopper is; 0 when they can afford it or the
/// balance isn't known.
int rewardShortfall(Reward reward, int? balance) {
  if (reward.canAfford || balance == null) return 0;
  final short = reward.pointsCost - balance;
  return short > 0 ? short : 0;
}

/// A redeemed voucher: the code big enough to read out at a till, Copy,
/// and when it must be used by.
class VoucherCodeCard extends StatelessWidget {
  const new({required this.voucher, required this.onCopyPressed, super.key});

  final Voucher voucher;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.xs,
          children: [
            Semantics(
              label: l10n.voucherCodeLabel(voucher.code),
              excludeSemantics: true,
              // One line: a code split across two reads as two codes.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SelectableText(
                  voucher.code,
                  maxLines: 1,
                  style: context.text.numericLarge.copyWith(letterSpacing: 2),
                ),
              ),
            ),
            if (voucher.expiresAt case final expires?)
              Text(
                l10n.voucherUseBy(formatDate(expires)),
                textAlign: TextAlign.center,
                style: context.text.bodySmall.copyWith(color: colors.inkMuted),
              ),
            Center(
              child: TextButton.icon(
                onPressed: onCopyPressed,
                icon: const Icon(Icons.copy_rounded),
                label: Text(l10n.voucherCopy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One line of My vouchers.
class VoucherRow extends StatelessWidget {
  const new({required this.voucher, required this.onCopyPressed, super.key});

  final Voucher voucher;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final details = [
      l10n.voucherGotOn(formatDate(voucher.redeemedAt)),
      if (voucher.expiresAt case final expires?)
        l10n.voucherUseBy(formatDate(expires)),
    ].join(' · ');
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            BrandLogo(name: voucher.brandName, size: 40),
            Expanded(
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${voucher.valueText} · ${voucher.brandName}',
                      style: context.text.bodyLarge,
                    ),
                    Semantics(
                      label: l10n.voucherCodeLabel(voucher.code),
                      excludeSemantics: true,
                      child: Text(
                        voucher.code,
                        style: context.text.label.copyWith(letterSpacing: 1),
                      ),
                    ),
                    Text(
                      details,
                      style: context.text.bodySmall.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onCopyPressed,
              tooltip: l10n.voucherCopy,
              icon: const Icon(Icons.copy_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
