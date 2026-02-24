import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (settings) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MpSectionHeader(title: l10n.notifications),
            MpToggleSwitch(
              value: settings.notificationsEnabled,
              onChanged: (value) {
                final updated = settings.copyWith(notificationsEnabled: value);
                ref.read(userSettingsProvider.notifier).updateProfile(updated);
              },
              label: l10n.pushNotifications,
            ),
            const SizedBox(height: AppSpacing.md),
            MpToggleSwitch(
              value: settings.criticalAlerts,
              onChanged: (value) {
                final updated = settings.copyWith(criticalAlerts: value);
                ref.read(userSettingsProvider.notifier).updateProfile(updated);
              },
              label: l10n.criticalAlerts,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.snoozeDuration,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [5, 10, 15, 30].map((duration) {
                final isSelected = settings.snoozeDuration == duration;
                return Semantics(
                  button: true,
                  selected: isSelected,
                  label: l10n.snoozeMinutesSemanticLabel(
                    duration,
                    isSelected ? l10n.selected : l10n.notSelected,
                  ),
                  child: InkWell(
                    onTap: () {
                      ref.read(userSettingsProvider.notifier).updateSnoozeDuration(duration);
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
                      child: ExcludeSemantics(
                        child: Text(
                          '$duration ${l10n.minuteShort}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
