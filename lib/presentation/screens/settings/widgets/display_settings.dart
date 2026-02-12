import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

class DisplaySettings extends ConsumerWidget {
  const DisplaySettings({super.key});

  String _getTextSizeLabel(AppLocalizations l10n, String storedValue) {
    switch (storedValue) {
      case 'normal':
        return l10n.normal;
      case 'large':
        return l10n.large;
      case 'xl':
        return l10n.extraLarge;
      default:
        return l10n.normal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      data: (settings) {
        final l10n = AppLocalizations.of(context)!;
        final highContrast = settings.highContrast;
        final textSize = settings.textSize;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MpSectionHeader(title: l10n.display),
            MpToggleSwitch(
              value: highContrast,
              onChanged: (value) {
                ref.read(userSettingsProvider.notifier).toggleHighContrast();
              },
              label: l10n.highContrast,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.textSize,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: ['normal', 'large', 'xl'].map((storedValue) {
                final isSelected = textSize == storedValue;
                final displayLabel = _getTextSizeLabel(l10n, storedValue);
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Text size $displayLabel${isSelected ? ', selected' : ''}',
                    child: GestureDetector(
                      onTap: () {
                        ref.read(userSettingsProvider.notifier).updateTextSize(storedValue);
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
                          displayLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isSelected ? AppColors.textOnPrimary : null,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
