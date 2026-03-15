import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_toggle_switch.dart';

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
            KdSectionHeader(title: l10n.display),
            KdToggleSwitch(
              value: highContrast,
              onChanged: (value) {
                ref.read(userSettingsProvider.notifier).toggleHighContrast();
              },
              label: l10n.highContrast,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.textSize, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: ['normal', 'large', 'xl'].map((storedValue) {
                final isSelected = textSize == storedValue;
                final displayLabel = _getTextSizeLabel(l10n, storedValue);
                return Semantics(
                  button: true,
                  selected: isSelected,
                  label:
                      '${l10n.textSizeSemanticLabel(displayLabel)}${isSelected ? ', selected' : ''}',
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(userSettingsProvider.notifier)
                          .updateTextSize(storedValue);
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.cardDark
                                  : AppColors.cardLight),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: Text(
                        displayLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.textOnPrimary : null,
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
      loading: () => const KdListShimmer(itemCount: 2, itemHeight: 48),
      error: (error, stack) {
        final l10n = AppLocalizations.of(context)!;
        return Center(child: Text(l10n.errorWithMessage(error.toString())));
      },
    );
  }
}
