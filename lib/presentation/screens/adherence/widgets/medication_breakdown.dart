import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_card.dart';

class MedicationBreakdown extends StatelessWidget {
  /// List of medications with their adherence percentage (null if no data).
  final List<({String id, String name, double? percentage})> medications;

  const MedicationBreakdown({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.byMedication,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (medications.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  l10n.noMedicationData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < medications.length; i++) ...[
              _MedicationRow(medication: medications[i]),
              if (i < medications.length - 1)
                const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.medication});

  final ({String id, String name, double? percentage}) medication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = medication.percentage?.round();
    final hasData = percentage != null;

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
          hasData ? '$percentage%' : l10n.noData,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: !hasData
                ? context.appColors.textMuted
                : percentage >= 80
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
