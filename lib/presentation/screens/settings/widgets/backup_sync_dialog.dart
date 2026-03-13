import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/services/firestore_service.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class BackupSyncDialog extends ConsumerStatefulWidget {
  const BackupSyncDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const BackupSyncDialog(),
    );
  }

  @override
  ConsumerState<BackupSyncDialog> createState() => _BackupSyncDialogState();
}

class _BackupSyncDialogState extends ConsumerState<BackupSyncDialog> {
  bool _autoSync = true;
  bool _isSyncing = false;
  String? _lastSyncText;

  Future<void> _syncNow() async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.signInToSync),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      final medications = await ref.read(medicationListProvider.future);
      final schedules = await ref.read(scheduleListProvider.future);
      final firestoreService = FirestoreService();

      await firestoreService.syncToCloud(medications, schedules);

      if (!mounted) return;

      setState(() {
        _isSyncing = false;
        _lastSyncText = l10n.justNow;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.syncComplete),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e, stackTrace) {
      ErrorHandler.captureException(e, stackTrace, 'BackupSyncDialog.syncNow');
      if (!mounted) return;

      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.genericError),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
                color: context.appColors.textMuted,
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
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            KdButton(
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
            KdButton(
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
