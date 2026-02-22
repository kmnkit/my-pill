import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<void> _setLanguage(String languageCode) async {
    await ref.read(userSettingsProvider.notifier).updateLanguage(languageCode);
  }

  Future<void> _getStarted() async {
    await ref.read(userSettingsProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(userSettingsProvider);

    final currentLanguage =
        settingsAsync.whenOrNull(data: (s) => s.language) ?? 'en';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language selector
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _setLanguage('en'),
                    child: Text(
                      'English',
                      style: textTheme.labelLarge?.copyWith(
                        color: currentLanguage == 'en'
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  Text(
                    ' | ',
                    style: textTheme.labelLarge
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                  TextButton(
                    onPressed: () => _setLanguage('ja'),
                    child: Text(
                      '\u65E5\u672C\u8A9E',
                      style: textTheme.labelLarge?.copyWith(
                        color: currentLanguage == 'ja'
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
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
                  const SizedBox(height: AppSpacing.xxl),

                  // Headline
                  Text(
                    l10n?.onboardingHeadline ??
                        'Your reliable medication companion',
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  // Features
                  _FeatureRow(
                    icon: Icons.schedule,
                    text: l10n?.onboardingFeature1 ?? 'Never miss a dose',
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FeatureRow(
                    icon: Icons.access_time,
                    text: l10n?.onboardingFeature2 ??
                        'Works across timezones',
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FeatureRow(
                    icon: Icons.groups,
                    text: l10n?.onboardingFeature3 ??
                        'Keep family connected',
                    textTheme: textTheme,
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Role introduction (informational, not selection)
                  Row(
                    children: [
                      Expanded(
                        child: _RoleInfoCard(
                          icon: Icons.person,
                          label: l10n?.onboardingRolePatient ?? 'Patient',
                          description: l10n?.onboardingRolePatientDesc ??
                              "I'm managing my own medications",
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _RoleInfoCard(
                          icon: Icons.favorite,
                          label: l10n?.onboardingRoleCaregiver ?? 'Caregiver',
                          description: l10n?.onboardingRoleCaregiverDesc ??
                              "I'm helping someone else",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Get Started button
              MpButton(
                label: l10n?.getStarted ?? 'Get Started',
                onPressed: _getStarted,
                variant: MpButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleInfoCard extends StatelessWidget {
  const _RoleInfoCard({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.textTheme,
  });

  final IconData icon;
  final String text;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
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
