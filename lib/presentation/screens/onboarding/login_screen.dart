import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/core/utils/apple_auth_error_messages.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/services/auth_service.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
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
    await ref.read(userSettingsProvider.notifier).updateUserRole(_selectedRole);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithGoogle();
      if (result == null) {
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
      if (mounted) setState(() => _isLoading = false);
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
      if (mounted) setState(() => _isLoading = false);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
              mainAxisSize: MainAxisSize.min,
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
                              : context.appColors.textMuted,
                        ),
                      ),
                    ),
                    Text(
                      ' | ',
                      style: textTheme.labelLarge
                          ?.copyWith(color: context.appColors.textMuted),
                    ),
                    TextButton(
                      onPressed: () => _setLanguage('ja'),
                      child: Text(
                        '\u65E5\u672C\u8A9E',
                        style: textTheme.labelLarge?.copyWith(
                          color: currentLanguage == 'ja'
                              ? AppColors.primary
                              : context.appColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // App icon + title
                Icon(
                  Icons.health_and_safety,
                  size: 56,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n?.signIn ?? 'Sign In',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Role selection
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
                        label: l10n?.onboardingRolePatient ?? 'Patient',
                        description: l10n?.onboardingRolePatientDesc ??
                            "I'm managing my own medications",
                        icon: Icons.person,
                        isSelected: _selectedRole == 'patient',
                        onTap: () => setState(() => _selectedRole = 'patient'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _RoleCard(
                        label: l10n?.onboardingRoleCaregiver ?? 'Caregiver',
                        description: l10n?.onboardingRoleCaregiverDesc ??
                            "I'm helping someone else",
                        icon: Icons.favorite,
                        isSelected: _selectedRole == 'caregiver',
                        onTap: () =>
                            setState(() => _selectedRole = 'caregiver'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Sign-in buttons
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  if (Platform.isIOS) ...[
                    MpButton(
                      label: l10n?.signInWithApple ?? 'Sign in with Apple',
                      onPressed: _signInWithApple,
                      variant: MpButtonVariant.primary,
                      icon: Icons.apple,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  MpButton(
                    label: l10n?.signInWithGoogle ?? 'Sign in with Google',
                    onPressed: _signInWithGoogle,
                    variant: Platform.isIOS
                        ? MpButtonVariant.secondary
                        : MpButtonVariant.primary,
                    iconWidget: Image.asset('assets/icons/google-logo.png',
                        width: 20, height: 20),
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
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

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
                      color: context.appColors.textMuted,
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : context.appColors.textMuted,
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
                color: context.appColors.textMuted,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
