import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class DataSharingDialog extends ConsumerWidget {
  const DataSharingDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const DataSharingDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (settings) => Dialog(
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
                  color: context.appColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SwitchListTile(
                value: settings.shareAdherenceData,
                onChanged: (value) {
                  final updated = settings.copyWith(shareAdherenceData: value);
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateProfile(updated);
                },
                title: Text(l10n.shareAdherenceData),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                value: settings.shareMedicationList,
                onChanged: (value) {
                  final updated = settings.copyWith(shareMedicationList: value);
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateProfile(updated);
                },
                title: Text(l10n.shareMedicationList),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                value: settings.allowCaregiverNotifications,
                onChanged: (value) {
                  final updated = settings.copyWith(
                    allowCaregiverNotifications: value,
                  );
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateProfile(updated);
                },
                title: Text(l10n.allowCaregiverNotifications),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.xxl),
              KdButton(
                label: l10n.close,
                variant: MpButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
