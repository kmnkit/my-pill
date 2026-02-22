import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/providers/adherence_provider.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/caregiver_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';

import 'package:my_pill/data/services/cloud_functions_service.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:my_pill/presentation/shared/dialogs/mp_confirm_dialog.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class CaregiverSettingsScreen extends ConsumerStatefulWidget {
  const CaregiverSettingsScreen({super.key});

  @override
  ConsumerState<CaregiverSettingsScreen> createState() => _CaregiverSettingsScreenState();
}

class _CaregiverSettingsScreenState extends ConsumerState<CaregiverSettingsScreen> {
  bool _missedDoseAlerts = true;
  bool _lowStockAlerts = true;

  void _invalidateAllProviders() {
    ref.invalidate(medicationListProvider);
    ref.invalidate(scheduleListProvider);
    ref.invalidate(todayRemindersProvider);
    ref.invalidate(overallAdherenceProvider);
    ref.invalidate(weeklyAdherenceProvider);
    ref.invalidate(caregiverLinksProvider);
    ref.invalidate(userSettingsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MpAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            MpSectionHeader(title: l10n.notifications),
            SwitchListTile(
              title: Text(l10n.missedDoseAlerts),
              subtitle: Text(l10n.missedDoseAlertsSubtitle),
              value: _missedDoseAlerts,
              onChanged: (value) {
                setState(() {
                  _missedDoseAlerts = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(l10n.lowStockAlerts),
              subtitle: Text(l10n.lowStockAlertsSubtitle),
              value: _lowStockAlerts,
              onChanged: (value) {
                setState(() {
                  _lowStockAlerts = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            MpSectionHeader(title: l10n.account),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.switchToPatientView),
              onTap: () {
                context.go('/home');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text(
                l10n.signOut,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.signOut),
                    content: Text(l10n.areYouSureSignOut),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.signOut),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  // 1. Clear user data first (while widget is still mounted)
                  await StorageService().clearUserData();
                  // 2. Invalidate providers (before signOut triggers redirect)
                  _invalidateAllProviders();
                  // 3. Sign out last — router redirect handles navigation to /login
                  await ref.read(authServiceProvider).signOut();
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            MpSectionHeader(title: l10n.advanced),
            ListTile(
              leading: Icon(Icons.logout, size: AppSpacing.iconMd, color: AppColors.error),
              title: Text(
                l10n.deactivateAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.error,
                    ),
              ),
              trailing: Icon(Icons.chevron_right, size: AppSpacing.iconMd, color: AppColors.textMuted),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final confirmed = await MpConfirmDialog.show(
                  context,
                  title: l10n.deactivateAccountTitle,
                  message: l10n.deactivateAccountMessage,
                  confirmLabel: l10n.deactivate,
                  isDestructive: true,
                );

                if (confirmed == true && context.mounted) {
                  try {
                    // 1. Clear user data first (while widget is still mounted)
                    await StorageService().clearUserData();
                    // 2. Invalidate providers (before signOut triggers redirect)
                    _invalidateAllProviders();
                    // 3. Sign out last — router redirect handles navigation
                    await ref.read(authServiceProvider).signOut();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorOccurred),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              leading: Icon(Icons.delete_forever, size: AppSpacing.iconMd, color: AppColors.error),
              title: Text(
                l10n.deleteAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.error,
                    ),
              ),
              trailing: Icon(Icons.chevron_right, size: AppSpacing.iconMd, color: AppColors.textMuted),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                // First confirmation
                final firstConfirm = await MpConfirmDialog.show(
                  context,
                  title: l10n.deleteAccountTitle,
                  message: l10n.deleteAccountMessage,
                  confirmLabel: l10n.continueButton,
                  isDestructive: true,
                );

                if (firstConfirm != true || !context.mounted) return;

                // Second confirmation
                final secondConfirm = await MpConfirmDialog.show(
                  context,
                  title: l10n.deleteAccountConfirmTitle,
                  message: l10n.deleteAccountConfirmMessage,
                  confirmLabel: l10n.deleteEverything,
                  isDestructive: true,
                );

                if (secondConfirm == true && context.mounted) {
                  try {
                    // 1. Re-authenticate before deletion
                    final authService = ref.read(authServiceProvider);
                    final reauthed = await authService.reauthenticate();
                    if (!reauthed) return; // User cancelled
                    // 2. Server-side deletion
                    await CloudFunctionsService().deleteAccount();
                    // 3. Clear local data (while widget is still mounted)
                    await StorageService().clearAll();
                    // 4. Invalidate providers (before signOut triggers redirect)
                    _invalidateAllProviders();
                    // 5. Sign out last — router redirect handles navigation
                    await authService.signOut();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorOccurred),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
