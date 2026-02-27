import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';

enum ReminderAction { take, snooze, skip }

class MpReminderDialog extends StatelessWidget {
  const MpReminderDialog({
    super.key,
    required this.time,
    required this.medicationName,
    required this.dosage,
    this.stockRemaining,
  });

  final String time;
  final String medicationName;
  final String dosage;
  final String? stockRemaining;

  static Future<ReminderAction?> show(
    BuildContext context, {
    required String time,
    required String medicationName,
    required String dosage,
    String? stockRemaining,
  }) {
    return showDialog<ReminderAction>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => MpReminderDialog(
        time: time,
        medicationName: medicationName,
        dosage: dosage,
        stockRemaining: stockRemaining,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.medication,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              time,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              medicationName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              dosage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
            if (stockRemaining != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                stockRemaining!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            MpButton(
              label: l10n.takeNow,
              onPressed: () => Navigator.of(context).pop(ReminderAction.take),
            ),
            const SizedBox(height: AppSpacing.sm),
            MpButton(
              label: l10n.snoozeMinutes(15),
              variant: MpButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(ReminderAction.snooze),
            ),
            const SizedBox(height: AppSpacing.sm),
            MpButton(
              label: l10n.skip,
              variant: MpButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(ReminderAction.skip),
            ),
          ],
        ),
      ),
    );
  }
}
