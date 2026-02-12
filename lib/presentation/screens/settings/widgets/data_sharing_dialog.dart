import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class DataSharingDialog extends StatefulWidget {
  const DataSharingDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const DataSharingDialog(),
    );
  }

  @override
  State<DataSharingDialog> createState() => _DataSharingDialogState();
}

class _DataSharingDialogState extends State<DataSharingDialog> {
  bool _shareAdherenceData = true;
  bool _shareMedicationList = true;
  bool _allowCaregiverNotifications = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dataSharingPreferences,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.dataSharingSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SwitchListTile(
              value: _shareAdherenceData,
              onChanged: (value) {
                setState(() {
                  _shareAdherenceData = value;
                });
              },
              title: Text(l10n.shareAdherenceData),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              value: _shareMedicationList,
              onChanged: (value) {
                setState(() {
                  _shareMedicationList = value;
                });
              },
              title: Text(l10n.shareMedicationList),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              value: _allowCaregiverNotifications,
              onChanged: (value) {
                setState(() {
                  _allowCaregiverNotifications = value;
                });
              },
              title: Text(l10n.allowCaregiverNotifications),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.xxl),
            MpButton(
              label: l10n.close,
              variant: MpButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
