import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class MedicationBreakdown extends StatelessWidget {
  final List<({String id, String name, double percentage})> medications;

  const MedicationBreakdown({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return MpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By Medication',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (medications.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'No medication data available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < medications.length; i++) ...[
              _MedicationRow(medication: medications[i]),
              if (i < medications.length - 1) const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.medication});

  final ({String id, String name, double percentage}) medication;

  @override
  Widget build(BuildContext context) {
    final percentage = medication.percentage.round();

    return Row(
      children: [
        Icon(
          Icons.medication,
          size: AppSpacing.iconMd,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            medication.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '$percentage%',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: percentage >= 80
                ? AppColors.success
                : percentage >= 60
                    ? AppColors.warning
                    : AppColors.error,
          ),
        ),
      ],
    );
  }
}
