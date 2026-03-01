import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';

class KdMedicationCard extends StatelessWidget {
  const KdMedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    this.time,
    this.shape = PillShape.round,
    this.color = PillColor.white,
    this.badgeVariant,
    this.badgeLabel,
    this.stockText,
    this.onTap,
  });

  final String name;
  final String dosage;
  final String? time;
  final PillShape shape;
  final PillColor color;
  final MpBadgeVariant? badgeVariant;
  final String? badgeLabel;
  final String? stockText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return KdCard(
      onTap: onTap,
      child: Row(
        children: [
          KdPillIcon(shape: shape, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      dosage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                    if (time != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        time!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
                if (stockText != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    stockText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badgeVariant != null && badgeLabel != null) ...[
            KdBadge(label: badgeLabel!, variant: badgeVariant!),
            const SizedBox(width: AppSpacing.sm),
          ],
          Icon(Icons.chevron_right, color: context.appColors.textMuted),
        ],
      ),
    );
  }
}
