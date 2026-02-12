import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
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
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) {
                    context.go('/onboarding');
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
