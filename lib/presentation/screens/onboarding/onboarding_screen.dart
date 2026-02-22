import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/utils/apple_auth_error_messages.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/services/auth_service.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  // Role selection state: 'patient' or 'caregiver', defaults to patient
  String _selectedRole = 'patient';

  Future<void> _completeAndNavigate() async {
    final authService = ref.read(authServiceProvider);
    final firebaseUser = authService.currentUser;
    if (firebaseUser != null) {
      await ref.read(userSettingsProvider.notifier).syncWithFirebaseUser(
            firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName,
          );
    }
    // Save the selected role before completing onboarding
    await ref.read(userSettingsProvider.notifier).updateUserRole(_selectedRole);
    await ref.read(userSettingsProvider.notifier).completeOnboarding();
    if (mounted) {
      if (_selectedRole == 'caregiver') {
        context.go('/caregiver/patients');
      } else {
        context.go('/home');
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithApple();
      if (result == null) {
        // User cancelled
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      await _completeAndNavigate();
    } on AppleSignInException catch (e) {
      if (mounted && e.error.shouldShowSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.error.getLocalizedMessage(context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.appleSignInFailed(e.toString())),
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

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithGoogle();
      if (result == null) {
        // User cancelled
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      await _completeAndNavigate();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.googleSignInFailed(e.toString())),
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

  Future<void> _continueAnonymously() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
      await _completeAndNavigate();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToStart(e.toString())),
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
                      '日本語',
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
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Role selection
              _RoleSelector(
                selectedRole: _selectedRole,
                onRoleSelected: (role) {
                  setState(() {
                    _selectedRole = role;
                  });
                },
                l10n: l10n,
                textTheme: textTheme,
              ),

              const Spacer(),

              // Bottom section: Sign-in buttons
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Apple Sign-In (iOS only, primary CTA)
                if (Platform.isIOS) ...[
                  MpButton(
                    label: l10n?.signInWithApple ?? 'Sign in with Apple',
                    onPressed: _signInWithApple,
                    variant: MpButtonVariant.primary,
                    icon: Icons.apple,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Google Sign-In
                MpButton(
                  label: l10n?.signInWithGoogle ?? 'Sign in with Google',
                  onPressed: _signInWithGoogle,
                  variant: Platform.isIOS
                      ? MpButtonVariant.secondary
                      : MpButtonVariant.primary,
                  iconWidget: Image.asset('assets/icons/google-logo.png', width: 20, height: 20),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md),
                      child: Text(
                        l10n?.or ?? 'or',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Anonymous / try without account
                MpButton(
                  label: l10n?.tryWithoutAccount ??
                      'Try without an account',
                  onPressed: _continueAnonymously,
                  variant: MpButtonVariant.text,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Disclaimer
                Text(
                  l10n?.localDataOnlyNotice ??
                      'Without an account, your data is stored only on this device.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selectedRole,
    required this.onRoleSelected,
    required this.l10n,
    required this.textTheme,
  });

  final String selectedRole;
  final ValueChanged<String> onRoleSelected;
  final AppLocalizations? l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n?.onboardingRoleTitle ?? 'How will you use Kusuridoki?',
          style: textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _RoleCard(
                role: 'patient',
                label: l10n?.onboardingRolePatient ?? 'Patient',
                description: l10n?.onboardingRolePatientDesc ??
                    "I'm managing my own medications",
                icon: Icons.person,
                isSelected: selectedRole == 'patient',
                onTap: () => onRoleSelected('patient'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _RoleCard(
                role: 'caregiver',
                label: l10n?.onboardingRoleCaregiver ?? 'Caregiver',
                description: l10n?.onboardingRoleCaregiverDesc ??
                    "I'm helping someone else",
                icon: Icons.favorite,
                isSelected: selectedRole == 'caregiver',
                onTap: () => onRoleSelected('caregiver'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String role;
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: textTheme.titleSmall?.copyWith(
                color: isSelected ? AppColors.primary : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
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
