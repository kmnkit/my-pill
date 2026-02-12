import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _handleGetStarted() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setLanguage(String languageCode) async {
    await ref.read(userSettingsProvider.notifier).updateLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(userSettingsProvider);

    final currentLanguage = settingsAsync.whenOrNull(data: (s) => s.language) ?? 'en';

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
                      'EN',
                      style: textTheme.labelLarge?.copyWith(
                        color: currentLanguage == 'en' ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                  ),
                  Text(
                    ' | ',
                    style: textTheme.labelLarge?.copyWith(color: AppColors.textMuted),
                  ),
                  TextButton(
                    onPressed: () => _setLanguage('ja'),
                    child: Text(
                      'JP',
                      style: textTheme.labelLarge?.copyWith(
                        color: currentLanguage == 'ja' ? AppColors.primary : AppColors.textMuted,
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
                    l10n?.onboardingHeadline ?? 'Your reliable medication companion',
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
                    text: l10n?.onboardingFeature2 ?? 'Works across timezones',
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FeatureRow(
                    icon: Icons.groups,
                    text: l10n?.onboardingFeature3 ?? 'Keep family connected',
                    textTheme: textTheme,
                  ),
                ],
              ),

              const Spacer(),

              // Bottom section
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                MpButton(
                  label: l10n?.getStarted ?? 'Get Started',
                  onPressed: _handleGetStarted,
                  variant: MpButtonVariant.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                MpButton(
                  label: l10n?.alreadyHaveAccount ?? 'I already have an account',
                  onPressed: () => context.push('/login'),
                  variant: MpButtonVariant.text,
                ),
              ],
            ],
          ),
        ),
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
