import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/services/auth_service.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:my_pill/presentation/screens/settings/widgets/account_section.dart';
import 'package:my_pill/presentation/screens/settings/widgets/backup_sync_dialog.dart';
import 'package:my_pill/presentation/screens/settings/widgets/data_sharing_dialog.dart';
import 'package:my_pill/presentation/screens/settings/widgets/display_settings.dart';
import 'package:my_pill/presentation/screens/settings/widgets/language_selector.dart';
import 'package:my_pill/presentation/screens/settings/widgets/notification_settings.dart';
import 'package:my_pill/presentation/screens/settings/widgets/premium_banner.dart';
import 'package:my_pill/presentation/shared/dialogs/mp_confirm_dialog.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userSettingsAsync = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: MpAppBar(title: l10n.settingsTitle),
      body: userSettingsAsync.when(
        data: (userSettings) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AccountSection(),
              const SizedBox(height: AppSpacing.xl),
              const LanguageSelector(),
              const SizedBox(height: AppSpacing.xl),
              const NotificationSettings(),
              const SizedBox(height: AppSpacing.xl),
              const DisplaySettings(),
              const SizedBox(height: AppSpacing.xl),
              MpSectionHeader(title: l10n.safetyPrivacy),
              _buildListTile(
                context,
                l10n.dataSharingPreferences,
                Icons.privacy_tip,
                () => DataSharingDialog.show(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.backupAndSync,
                Icons.cloud_upload,
                () => BackupSyncDialog.show(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              MpSectionHeader(title: l10n.about),
              _buildListTile(
                context,
                l10n.appVersion,
                Icons.info_outline,
                null,
                trailing: Text(
                  l10n.version('1.0.0'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              MpSectionHeader(title: l10n.advanced),
              _buildListTile(
                context,
                l10n.deactivateAccount,
                Icons.power_settings_new,
                () async {
                  final confirmed = await MpConfirmDialog.show(
                    context,
                    title: l10n.deactivateAccountTitle,
                    message: l10n.deactivateAccountMessage,
                    confirmLabel: l10n.deactivate,
                    isDestructive: true,
                  );

                  if (confirmed == true && context.mounted) {
                    try {
                      await AuthService().signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.errorDeactivatingAccount(e.toString())),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  }
                },
                textColor: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.deleteAccount,
                Icons.delete_forever,
                () async {
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
                      // Clear local data first
                      await StorageService().clearAll();
                      // Delete Firebase account
                      await AuthService().deleteAccount();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.errorDeletingAccount(e.toString())),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  }
                },
                textColor: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.xl),
              const PremiumBanner(),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/caregiver/patients');
                  },
                  child: Text(
                    l10n.switchToCaregiverView,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.errorLoadingSettings),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => ref.invalidate(userSettingsProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback? onTap, {
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: AppSpacing.iconMd, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, size: AppSpacing.iconMd, color: AppColors.textMuted)
              : null),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
