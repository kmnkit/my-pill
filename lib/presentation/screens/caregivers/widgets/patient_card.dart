import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/shared/widgets/mp_avatar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.name,
    required this.initials,
    required this.adherence,
    required this.medications,
  });

  final String name;
  final String initials;
  final String adherence;
  final List<Map<String, dynamic>> medications;

  @override
  Widget build(BuildContext context) {
    return MpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MpAvatar(initials: initials, size: 48.0),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Daily Adherence: $adherence',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          ...medications.map((med) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  MpPillIcon(
                    shape: med['shape'] as PillShape,
                    color: med['color'] as PillColor,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      med['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  MpBadge(
                    label: med['status'] as String,
                    variant: med['variant'] as MpBadgeVariant,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
