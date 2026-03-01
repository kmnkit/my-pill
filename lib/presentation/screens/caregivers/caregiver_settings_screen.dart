import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';

import 'package:kusuridoki/data/services/cloud_functions_service.dart';
import 'package:kusuridoki/data/services/storage_service.dart';
import 'package:kusuridoki/presentation/shared/dialogs/kd_confirm_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/language_selector.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class CaregiverSettingsScreen extends ConsumerStatefulWidget {
  const CaregiverSettingsScreen({super.key});

  @override
  ConsumerState<CaregiverSettingsScreen> createState() =>
      _CaregiverSettingsScreenState();
}

class _CaregiverSettingsScreenState
    extends ConsumerState<CaregiverSettingsScreen> {
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
    return GradientScaffold(
      appBar: KdAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.navBarClearance,
          ),
          children: [
            const LanguageSelector(),
            const SizedBox(height: AppSpacing.xl),
            KdSectionHeader(title: l10n.notifications),
            ref
                .watch(userSettingsProvider)
                .when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, st) => const SizedBox.shrink(),
                  data: (settings) => Column(
                    children: [
                      SwitchListTile(
                        title: Text(l10n.missedDoseAlerts),
                        subtitle: Text(l10n.missedDoseAlertsSubtitle),
                        value: settings.missedDoseAlerts,
                        onChanged: (value) {
                          final updated = settings.copyWith(
                            missedDoseAlerts: value,
                          );
                          ref
                              .read(userSettingsProvider.notifier)
                              .updateProfile(updated);
                        },
                      ),
                      SwitchListTile(
                        title: Text(l10n.lowStockAlerts),
                        subtitle: Text(l10n.lowStockAlertsSubtitle),
                        value: settings.lowStockAlerts,
                        onChanged: (value) {
                          final updated = settings.copyWith(
                            lowStockAlerts: value,
                          );
                          ref
                              .read(userSettingsProvider.notifier)
                              .updateProfile(updated);
                        },
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: AppSpacing.xl),
            KdSectionHeader(title: l10n.account),
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
                bool isAnonymous;
                try {
                  isAnonymous =
                      FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
                } catch (_) {
                  isAnonymous = false;
                }
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.signOut),
                    content: Text(isAnonymous
                        ? l10n.logOutMessageAnonymous
                        : l10n.logOutMessageAuthenticated),
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
            KdSectionHeader(title: l10n.advanced),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: AppSpacing.iconMd,
                color: AppColors.error,
              ),
              title: Text(
                l10n.deactivateAccount,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: AppSpacing.iconMd,
                color: context.appColors.textMuted,
              ),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                bool isAnon;
                try {
                  isAnon =
                      FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
                } catch (_) {
                  isAnon = false;
                }
                final confirmed = await KdConfirmDialog.show(
                  context,
                  title: l10n.deactivateAccountTitle,
                  message: isAnon
                      ? l10n.logOutMessageAnonymous
                      : l10n.logOutMessageAuthenticated,
                  confirmLabel: l10n.deactivate,
                  isDestructive: true,
                );

                if (confirmed == true && context.mounted) {
                  try {
                    // 1. Revoke all caregiver links server-side
                    final links = ref.read(caregiverLinksProvider).value ?? [];
                    for (final link in links) {
                      try {
                        await CloudFunctionsService().revokeAccess(
                          caregiverId: link.caregiverId,
                          linkId: link.id,
                        );
                      } catch (_) {
                        // Best-effort cleanup — continue with remaining links
                      }
                    }
                    // 2. Clear user data (while widget is still mounted)
                    await StorageService().clearUserData();
                    // 3. Invalidate providers (before signOut triggers redirect)
                    _invalidateAllProviders();
                    // 4. Sign out last — router redirect handles navigation
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
              leading: Icon(
                Icons.delete_forever,
                size: AppSpacing.iconMd,
                color: AppColors.error,
              ),
              title: Text(
                l10n.deleteAccount,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: AppSpacing.iconMd,
                color: context.appColors.textMuted,
              ),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                // First confirmation
                final firstConfirm = await KdConfirmDialog.show(
                  context,
                  title: l10n.deleteAccountTitle,
                  message: l10n.deleteAccountMessage,
                  confirmLabel: l10n.continueButton,
                  isDestructive: true,
                );

                if (firstConfirm != true || !context.mounted) return;

                // Second confirmation
                final secondConfirm = await KdConfirmDialog.show(
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
