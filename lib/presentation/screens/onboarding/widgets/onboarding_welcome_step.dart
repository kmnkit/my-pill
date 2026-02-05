import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class OnboardingWelcomeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const OnboardingWelcomeStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final settingsAsync = ref.watch(userSettingsProvider);
    final currentLanguage = settingsAsync.whenOrNull(
      data: (settings) => settings.language,
    ) ?? 'en';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Language selector at top right
          _LanguageSelector(
            currentLanguage: currentLanguage,
            onLanguageChanged: (language) {
              ref.read(userSettingsProvider.notifier).updateLanguage(language);
            },
          ),

          const Spacer(),

          // Center content
          Column(
            children: [
              // App icon
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Welcome title
              Text(
                l10n.onboardingWelcomeTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingWelcomeSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Features
              _FeatureRow(
                icon: Icons.schedule,
                text: l10n.onboardingFeature1,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FeatureRow(
                icon: Icons.access_time,
                text: l10n.onboardingFeature2,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FeatureRow(
                icon: Icons.groups,
                text: l10n.onboardingFeature3,
              ),
            ],
          ),

          const Spacer(),

          // Next button
          MpButton(
            label: l10n.onboardingNext,
            onPressed: onNext,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const _LanguageSelector({
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _LanguageButton(
          label: 'EN',
          isSelected: currentLanguage == 'en',
          onTap: () => onLanguageChanged('en'),
        ),
        Text(
          ' | ',
          style: textTheme.labelLarge?.copyWith(color: AppColors.textMuted),
        ),
        _LanguageButton(
          label: 'JP',
          isSelected: currentLanguage == 'ja',
          onTap: () => onLanguageChanged('ja'),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: textTheme.labelLarge?.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textMuted,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Text(text, style: textTheme.bodyLarge),
        ),
      ],
    );
  }
}
