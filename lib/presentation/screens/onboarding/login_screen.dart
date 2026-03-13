import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/utils/apple_auth_error_messages.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/services/auth_service.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _completeAndNavigate({String? credentialDisplayName}) async {
    final authService = ref.read(authServiceProvider);
    final firebaseUser = authService.currentUser;
    if (firebaseUser != null) {
      await ref
          .read(userSettingsProvider.notifier)
          .syncWithFirebaseUser(
            firebaseUser.uid,
            email: firebaseUser.email,
            displayName: credentialDisplayName ?? firebaseUser.displayName,
          );
    }
    final role =
        ref.read(userSettingsProvider).asData?.value.userRole ?? 'patient';
    if (mounted) {
      if (role == 'caregiver') {
        context.go('/caregiver/patients');
      } else {
        context.go('/home');
      }
    }
  }

  String? _extractDisplayName(UserCredential credential) {
    // Priority 1: FirebaseAuth user displayName (set by provider)
    final userDisplayName = credential.user?.displayName;
    if (userDisplayName != null && userDisplayName.isNotEmpty) {
      return userDisplayName;
    }

    // Priority 2: additionalUserInfo.profile (Apple provides name here on first login)
    final profile = credential.additionalUserInfo?.profile;
    if (profile != null) {
      final name = profile['name'];
      if (name is String && name.isNotEmpty) return name;

      // Apple sometimes nests as firstName/lastName
      final firstName = profile['firstName'] as String? ?? '';
      final lastName = profile['lastName'] as String? ?? '';
      final fullName = '$firstName $lastName'.trim();
      if (fullName.isNotEmpty) return fullName;
    }

    return null;
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

      final extractedName = _extractDisplayName(result);

      await _completeAndNavigate(credentialDisplayName: extractedName);

      // Persist name to Firebase for future logins (best-effort, fire-and-forget)
      if (extractedName != null && result.user?.displayName == null) {
        final user = result.user;
        if (user != null) {
          user.updateDisplayName(extractedName).catchError(
            (e) => debugPrint('updateDisplayName failed: $e'),
          );
        }
      }
    } on AppleSignInException catch (e) {
      if (mounted && e.error.shouldShowSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.error.getLocalizedMessage(context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e, stackTrace) {
      ErrorHandler.captureException(e, stackTrace, 'LoginScreen.signInWithApple');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.genericError),
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
      await _completeAndNavigate(
        credentialDisplayName: _extractDisplayName(result),
      );
    } catch (e, stackTrace) {
      ErrorHandler.captureException(e, stackTrace, 'LoginScreen.signInWithGoogle');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.genericError),
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
    } catch (e, stackTrace) {
      ErrorHandler.captureException(e, stackTrace, 'LoginScreen.continueAnonymously');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.genericError),
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
                    style: textTheme.labelLarge?.copyWith(
                      color: context.appColors.textMuted,
                    ),
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
              Icon(Icons.health_and_safety, size: 56, color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n?.signIn ?? 'Sign In',
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign-in buttons
              if (_isLoading)
                const Center(child: CircularProgressIndicator.adaptive())
              else ...[
                if (Platform.isIOS) ...[
                  KdButton(
                    label: l10n?.signInWithApple ?? 'Sign in with Apple',
                    onPressed: _signInWithApple,
                    variant: MpButtonVariant.primary,
                    icon: Icons.apple,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                KdButton(
                  label: l10n?.signInWithGoogle ?? 'Sign in with Google',
                  onPressed: _signInWithGoogle,
                  variant: Platform.isIOS
                      ? MpButtonVariant.secondary
                      : MpButtonVariant.primary,
                  iconWidget: Image.asset(
                    'assets/icons/google-logo.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
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

                KdButton(
                  label: l10n?.tryWithoutAccount ?? 'Try without an account',
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
