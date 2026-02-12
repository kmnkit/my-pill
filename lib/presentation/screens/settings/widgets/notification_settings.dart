import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _pushNotifications = true;
  bool _criticalAlerts = true;
  int _snoozeDuration = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MpSectionHeader(title: l10n.notifications),
        MpToggleSwitch(
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
          },
          label: l10n.pushNotifications,
        ),
        const SizedBox(height: AppSpacing.md),
        MpToggleSwitch(
          value: _criticalAlerts,
          onChanged: (value) {
            setState(() => _criticalAlerts = value);
          },
          label: l10n.criticalAlerts,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.snoozeDuration,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [5, 10, 15, 30].map((duration) {
            final isSelected = _snoozeDuration == duration;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () {
                  setState(() => _snoozeDuration = duration);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Text(
                    '$duration ${l10n.minuteShort}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
