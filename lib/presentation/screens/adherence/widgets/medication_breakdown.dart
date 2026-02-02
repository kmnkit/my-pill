import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class MedicationBreakdown extends StatelessWidget {
  const MedicationBreakdown({super.key});

  static const List<_MedicationData> _medications = [
    _MedicationData(
      name: 'Vitamin D',
      percentage: 100,
      shape: PillShape.capsule,
      color: PillColor.yellow,
    ),
    _MedicationData(
      name: 'Omega-3',
      percentage: 85,
      shape: PillShape.oval,
      color: PillColor.orange,
    ),
    _MedicationData(
      name: 'Melatonin',
      percentage: 50,
      shape: PillShape.round,
      color: PillColor.purple,
    ),
  ];

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
          for (int i = 0; i < _medications.length; i++) ...[
            _MedicationRow(medication: _medications[i]),
            if (i < _medications.length - 1) const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.medication});

  final _MedicationData medication;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MpPillIcon(
          shape: medication.shape,
          color: medication.color,
          size: AppSpacing.iconMd,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            medication.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '${medication.percentage}%',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: medication.percentage >= 80
                ? AppColors.success
                : medication.percentage >= 60
                    ? AppColors.warning
                    : AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _MedicationData {
  final String name;
  final int percentage;
  final PillShape shape;
  final PillColor color;

  const _MedicationData({
    required this.name,
    required this.percentage,
    required this.shape,
    required this.color,
  });
}
