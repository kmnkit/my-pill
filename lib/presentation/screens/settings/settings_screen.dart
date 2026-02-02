import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/screens/settings/widgets/account_section.dart';
import 'package:my_pill/presentation/screens/settings/widgets/display_settings.dart';
import 'package:my_pill/presentation/screens/settings/widgets/language_selector.dart';
import 'package:my_pill/presentation/screens/settings/widgets/notification_settings.dart';
import 'package:my_pill/presentation/screens/settings/widgets/remove_ads_banner.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingsAsync = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: const MpAppBar(title: 'Settings'),
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
              const MpSectionHeader(title: 'Safety & Privacy'),
              _buildListTile(
                context,
                'Data Sharing Preferences',
                Icons.privacy_tip,
                () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                'Backup & Sync',
                Icons.cloud_upload,
                () {},
              ),
              const SizedBox(height: AppSpacing.xl),
              const MpSectionHeader(title: 'About'),
              _buildListTile(
                context,
                'App Version',
                Icons.info_outline,
                null,
                trailing: Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const MpSectionHeader(title: 'Advanced'),
              _buildListTile(
                context,
                'Deactivate Account',
                Icons.power_settings_new,
                () {},
                textColor: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildListTile(
                context,
                'Delete Account',
                Icons.delete_forever,
                () {},
                textColor: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.xl),
              const RemoveAdsBanner(),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/caregiver/patients');
                  },
                  child: Text(
                    'Switch to Caregiver View',
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
              const Text('Error loading settings'),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => ref.invalidate(userSettingsProvider),
                child: const Text('Retry'),
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
