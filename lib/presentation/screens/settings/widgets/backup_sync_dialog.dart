import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

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
  String _lastSyncText = 'Never';

  Future<void> _syncNow() async {
    setState(() {
      _isSyncing = true;
    });

    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSyncing = false;
      _lastSyncText = 'Just now';
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync complete'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Backup & Sync',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sync your data with the cloud',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last sync:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _lastSyncText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            MpButton(
              label: _isSyncing ? 'Syncing...' : 'Sync Now',
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
              title: const Text('Auto-sync'),
              subtitle: const Text('Automatically sync when changes are made'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.xl),
            MpButton(
              label: 'Close',
              variant: MpButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
