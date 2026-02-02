import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

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
    return Scaffold(
      appBar: const MpAppBar(title: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const MpSectionHeader(title: 'Notifications'),
            SwitchListTile(
              title: const Text('Missed Dose Alerts'),
              subtitle: const Text('Get notified when patients miss medications'),
              value: _missedDoseAlerts,
              onChanged: (value) {
                setState(() {
                  _missedDoseAlerts = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Low Stock Alerts'),
              subtitle: const Text('Get notified about low medication inventory'),
              value: _lowStockAlerts,
              onChanged: (value) {
                setState(() {
                  _lowStockAlerts = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            const MpSectionHeader(title: 'Account'),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Switch to Patient View'),
              onTap: () {
                context.go('/home');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'Sign Out',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sign Out'),
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
