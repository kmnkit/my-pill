import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.badgeVariant,
    required this.badgeLabel,
    required this.pillShape,
    required this.pillColor,
    required this.medicationId,
  });

  final String medicationName;
  final String dosage;
  final String time;
  final MpBadgeVariant badgeVariant;
  final String badgeLabel;
  final PillShape pillShape;
  final PillColor pillColor;
  final String medicationId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MpCard(
      onTap: () => context.go('/medications/$medicationId'),
      child: Row(
        children: [
          // Pill icon
          MpPillIcon(
            shape: pillShape,
            color: pillColor,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(width: AppSpacing.md),

          // Medication info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicationName,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  dosage,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // Time and badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              MpBadge(
                label: badgeLabel,
                variant: badgeVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
