import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MpSectionHeader(title: 'Language'),
        Row(
          children: [
            Expanded(
              child: _buildLanguageButton(
                context,
                'EN',
                _selectedLanguage == 'EN',
                isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildLanguageButton(
                context,
                'JP',
                _selectedLanguage == 'JP',
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
    String language,
    bool isSelected,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedLanguage = language);
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
            language,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
