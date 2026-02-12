import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (settings) {
        final l10n = AppLocalizations.of(context)!;
        final currentLanguage = settings.language;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MpSectionHeader(title: l10n.language),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageButton(
                    context,
                    ref,
                    'EN',
                    'en',
                    currentLanguage == 'en',
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildLanguageButton(
                    context,
                    ref,
                    'JP',
                    'ja',
                    currentLanguage == 'ja',
                    isDark,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    WidgetRef ref,
    String displayLabel,
    String languageCode,
    bool isSelected,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () async {
        if (!isSelected) {
          await ref.read(userSettingsProvider.notifier).updateLanguage(languageCode);
        }
      },
      child: Container(
        height: AppSpacing.buttonHeight,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Center(
          child: Text(
            displayLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
