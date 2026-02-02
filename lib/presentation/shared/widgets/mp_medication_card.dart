import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class MpMedicationCard extends StatelessWidget {
  const MpMedicationCard({
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
    return MpCard(
      onTap: onTap,
      child: Row(
        children: [
          MpPillIcon(shape: shape, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(dosage, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                    if (time != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(time!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ],
                  ],
                ),
                if (stockText != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(stockText!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                ],
              ],
            ),
          ),
          if (badgeVariant != null && badgeLabel != null) ...[
            MpBadge(label: badgeLabel!, variant: badgeVariant!),
            const SizedBox(width: AppSpacing.sm),
          ],
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
