import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(userSettingsProvider);

    final selectedLanguage = settingsAsync.whenOrNull(
      data: (settings) => settings.language,
    ) ?? 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MpSectionHeader(title: 'Language'),
        Row(
          children: [
            Expanded(
              child: _buildLanguageButton(
                context,
                ref,
                'en',
                'EN',
                selectedLanguage == 'en',
                isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildLanguageButton(
                context,
                ref,
                'ja',
                'JP',
                selectedLanguage == 'ja',
                isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
    String displayLabel,
    bool isSelected,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(userSettingsProvider.notifier).updateLanguage(languageCode);
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
