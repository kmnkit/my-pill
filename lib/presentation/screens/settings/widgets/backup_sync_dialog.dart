import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class BackupSyncDialog extends StatefulWidget {
  const BackupSyncDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const BackupSyncDialog(),
    );
  }

  @override
  State<BackupSyncDialog> createState() => _BackupSyncDialogState();
}

class _BackupSyncDialogState extends State<BackupSyncDialog> {
  bool _autoSync = true;
  bool _isSyncing = false;
  String? _lastSyncText;

  Future<void> _syncNow() async {
    setState(() {
      _isSyncing = true;
    });

    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSyncing = false;
      _lastSyncText = AppLocalizations.of(context)!.justNow;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.syncComplete),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
              l10n.backupAndSync,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.syncWithCloud,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lastSync,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _lastSyncText ?? l10n.never,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            MpButton(
              label: _isSyncing ? l10n.syncing : l10n.syncNow,
              onPressed: _isSyncing ? null : _syncNow,
              icon: _isSyncing ? null : Icons.cloud_upload,
            ),
            const SizedBox(height: AppSpacing.xl),
            SwitchListTile(
              value: _autoSync,
              onChanged: (value) {
                setState(() {
                  _autoSync = value;
                });
              },
              title: Text(l10n.autoSync),
              subtitle: Text(l10n.autoSyncSubtitle),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.xl),
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
