import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_constants.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';

import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/services/cloud_functions_service.dart';
import 'package:kusuridoki/data/services/storage_service.dart';
import 'package:kusuridoki/core/utils/screenshot_seeder.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/account_section.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/backup_sync_dialog.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/data_sharing_dialog.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/display_settings.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/language_selector.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/notification_settings.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/premium_banner.dart';
import 'package:kusuridoki/presentation/shared/dialogs/mp_confirm_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_app_bar.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_section_header.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userSettingsAsync = ref.watch(userSettingsProvider);

    return GradientScaffold(
      appBar: MpAppBar(title: l10n.settingsTitle),
      body: userSettingsAsync.when(
        data: (userSettings) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.navBarClearance,
          ),
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
              MpSectionHeader(title: l10n.features),
              _buildListTile(
                context,
                l10n.familyCaregivers,
                Icons.family_restroom,
                () => context.goNamed(RouteNames.familyCaregivers),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.travelMode,
                Icons.flight_takeoff,
                () => context.goNamed(RouteNames.travelMode),
              ),
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
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.privacyPolicy,
                Icons.shield_outlined,
                () => launchUrl(Uri.parse(AppConstants.privacyPolicyUrl)),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.termsOfService,
                Icons.description_outlined,
                () => launchUrl(Uri.parse(AppConstants.termsOfServiceUrl)),
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
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.xl),
                MpSectionHeader(title: 'Debug Tools'),
                _buildListTile(
                  context,
                  'Seed Screenshot Data',
                  Icons.photo_library_outlined,
                  () async {
                    final seeder = ScreenshotSeeder(StorageService());
                    await seeder.seed();
                    _invalidateUserProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Screenshot data seeded!'),
                        ),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const PremiumBanner(),
              const SizedBox(height: AppSpacing.xl),
              MpSectionHeader(title: l10n.advanced),
              _buildListTile(
                context,
                l10n.deactivateAccount,
                Icons.logout,
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
                      // 1. Clear user data first (while widget is still mounted)
                      await StorageService().clearUserData();
                      // 2. Invalidate all user-data providers (before signOut triggers redirect)
                      _invalidateUserProviders(ref);
                      // 3. Sign out last — router redirect handles navigation to /login
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
                      if (FirebaseAuth.instance.currentUser?.isAnonymous ==
                          true) {
                        // Anonymous path: no server data, delete auth account directly
                        // 1. Clear local data first (while widget is still mounted)
                        await StorageService().clearAll();
                        // 2. Invalidate providers first (before auth deletion triggers redirect)
                        _invalidateUserProviders(ref);
                        // 3. Delete auth account — triggers auth stream null → router auto-redirects
                        try {
                          await FirebaseAuth.instance.currentUser?.delete();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'requires-recent-login') {
                            // Refresh anonymous token and retry
                            await FirebaseAuth.instance.signInAnonymously();
                            await FirebaseAuth.instance.currentUser?.delete();
                          } else {
                            rethrow;
                          }
                        }
                      } else {
                        // Authenticated path: re-authenticate, delete server data, then sign out
                        final authService = ref.read(authServiceProvider);
                        final reauthed = await authService.reauthenticate();
                        if (!reauthed) return; // User cancelled
                        // 1. Server-side deletion of all user data + auth account
                        await CloudFunctionsService().deleteAccount();
                        // 2. Clear local data first (while widget is still mounted)
                        await StorageService().clearAll();
                        // 3. Invalidate all providers (before signOut triggers redirect)
                        _invalidateUserProviders(ref);
                        // 4. Sign out last — router redirect handles navigation
                        await authService.signOut();
                      }
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
                textColor: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/caregiver/patients');
                  },
                  child: Text(
                    l10n.switchToCaregiverView,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
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

  void _invalidateUserProviders(WidgetRef ref) {
    ref.invalidate(medicationListProvider);
    ref.invalidate(scheduleListProvider);
    ref.invalidate(todayRemindersProvider);
    ref.invalidate(overallAdherenceProvider);
    ref.invalidate(weeklyAdherenceProvider);
    ref.invalidate(caregiverLinksProvider);
    ref.invalidate(userSettingsProvider);
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
      leading: Icon(
        icon,
        size: AppSpacing.iconMd,
        color: textColor ?? context.appColors.textPrimary,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: textColor),
      ),
      trailing:
          trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  size: AppSpacing.iconMd,
                  color: context.appColors.textMuted,
                )
              : null),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
