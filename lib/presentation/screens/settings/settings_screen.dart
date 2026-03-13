import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_constants.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/core/utils/screenshot_data_seeder.dart';
import 'package:kusuridoki/core/utils/screenshot_seeder.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/account_section.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/backup_sync_dialog.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/data_sharing_dialog.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/display_settings.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/language_selector.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/notification_settings.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/premium_banner.dart';
import 'package:kusuridoki/presentation/shared/dialogs/kd_confirm_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';
import 'package:kusuridoki/core/utils/provider_invalidation.dart';

@visibleForTesting
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userSettingsAsync = ref.watch(userSettingsProvider);
    final appVersionAsync = ref.watch(appVersionProvider);

    bool isAnonymous;
    try {
      isAnonymous = ref.read(authServiceProvider).currentUser?.isAnonymous ?? false;
    } catch (_) {
      isAnonymous = false;
    }

    return GradientScaffold(
      appBar: KdAppBar(title: l10n.settingsTitle),
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
              KdSectionHeader(title: l10n.features),
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
              KdSectionHeader(title: l10n.safetyPrivacy),
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
              KdSectionHeader(title: l10n.about),
              _buildListTile(
                context,
                l10n.appVersion,
                Icons.info_outline,
                null,
                trailing: Text(
                  appVersionAsync.when(
                    data: (v) => l10n.version(v),
                    loading: () => l10n.version('...'),
                    error: (e, s) => l10n.version('—'),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.xl),
                KdSectionHeader(title: 'Debug Tools'),
                _buildListTile(
                  context,
                  'Seed Screenshot Data (日本語)',
                  Icons.photo_library_outlined,
                  () async {
                    final seeder = ScreenshotSeeder(ref.read(storageServiceProvider));
                    await seeder.clearAndSeed();
                    invalidateUserProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Screenshot data seeded (ja)!'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildListTile(
                  context,
                  'Seed Screenshot Data (English)',
                  Icons.photo_library_outlined,
                  () async {
                    final storage = ref.read(storageServiceProvider);
                    await storage.clearAll();
                    await ScreenshotDataSeeder(storage).seed();
                    invalidateUserProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Screenshot data seeded (en)!'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildListTile(
                  context,
                  'Clear All Data',
                  Icons.delete_sweep_outlined,
                  () async {
                    final confirmed = await KdConfirmDialog.show(
                      context,
                      title: l10n.clearAllDataTitle,
                      message: l10n.clearAllDataMessage,
                      confirmLabel: l10n.clearAllDataConfirm,
                      isDestructive: true,
                    );
                    if (confirmed != true) return;

                    await ref.read(storageServiceProvider).clearUserData();
                    invalidateUserProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All data cleared!')),
                      );
                    }
                  },
                  textColor: AppColors.error,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const PremiumBanner(),
              const SizedBox(height: AppSpacing.xl),
              KdSectionHeader(title: l10n.advanced),
              _buildListTile(
                context,
                l10n.changeName,
                Icons.edit,
                () => _showChangeNameDialog(context, ref),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                l10n.deactivateAccount,
                Icons.logout,
                () async {
                  final isAnon = ref.read(authServiceProvider).currentUser?.isAnonymous ?? false;
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
                      // 1. Clear user data first (while widget is still mounted)
                      await ref.read(storageServiceProvider).clearUserData();
                      // 2. Invalidate all user-data providers (before signOut triggers redirect)
                      invalidateUserProviders(ref);
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
              if (!isAnonymous) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildListTile(
                  context,
                  l10n.deleteAccount,
                  Icons.delete_forever,
                  () async {
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
                        final deleteUser = ref.read(authServiceProvider).currentUser;
                        if (deleteUser == null || deleteUser.isAnonymous) {
                          // Null/anonymous path: local data only, sign out
                          await ref.read(storageServiceProvider).clearUserData();
                          invalidateUserProviders(ref);
                          await ref.read(authServiceProvider).signOut();
                        } else {
                          // Authenticated path: delete server data, then sign out
                          final authService = ref.read(authServiceProvider);
                          // 1. Server-side deletion of all user data + auth account
                          await ref.read(cloudFunctionsServiceProvider).deleteAccount();
                          // 2. Clear local data first (while widget is still mounted)
                          await ref.read(storageServiceProvider).clearUserData();
                          // 3. Invalidate all providers (before signOut triggers redirect)
                          invalidateUserProviders(ref);
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
              ],
              if (userSettings.userRole == 'caregiver') ...[
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
              ],
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: KdListShimmer(itemCount: 6),
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

  Future<void> _showChangeNameDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeNameTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.changeNameHint),
          autofocus: true,
          maxLength: 50,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    // Sanitize: trim, collapse whitespace, strip control characters
    final newName = controller.text
        .trim()
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
    if (newName.isEmpty) return;

    await ref.read(userSettingsProvider.notifier).updateName(newName);
    // Fire-and-forget for authenticated users
    ref.read(authServiceProvider).currentUser?.updateDisplayName(newName);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nameSaved)),
      );
    }
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
