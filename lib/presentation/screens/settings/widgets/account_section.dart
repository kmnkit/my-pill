import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_avatar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/data/services/auth_service.dart';
import 'package:my_pill/core/utils/apple_auth_error_messages.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return authStateAsync.when(
      loading: () => MpCard(
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                l10n.loading,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => MpCard(
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                l10n.errorLoadingAccount,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      data: (user) {
        if (user == null) {
          // No user signed in (should not happen in settings)
          return MpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MpAvatar(initials: '?', size: 56.0),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.notSignedIn,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.signInToAccess,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          );
        }

        final isAnonymous = user.isAnonymous;
        final displayName = user.displayName ??
                           (user.email?.split('@').first ?? 'User');
        final email = user.email ?? 'No email';
        final initials = _getInitials(displayName);

        if (isAnonymous) {
          // Anonymous user - show prompt to sign in
          return MpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const MpAvatar(initials: 'G', size: 56.0),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.guestUser,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.signInToSync,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                MpButton(
                  label: l10n.signIn,
                  onPressed: () => context.push('/login'),
                  variant: MpButtonVariant.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                MpButton(
                  label: l10n.linkWithGoogle,
                  onPressed: () => _linkWithGoogle(context, ref),
                  variant: MpButtonVariant.secondary,
                  icon: Icons.g_mobiledata,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (Platform.isIOS)
                  MpButton(
                    label: l10n.linkWithApple,
                    onPressed: () => _linkWithApple(context, ref),
                    variant: MpButtonVariant.secondary,
                    icon: Icons.apple,
                  ),
              ],
            ),
          );
        }

        // Authenticated user
        final isPrivateEmail = AuthService.isPrivateRelayEmail(user.email);

        return MpCard(
          onTap: () => context.push('/login'),
          child: Row(
            children: [
              MpAvatar(initials: initials, size: 56.0),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (isPrivateEmail)
                      Text(
                        l10n.emailHidden,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                      )
                    else
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: AppSpacing.iconMd, color: AppColors.textMuted),
            ],
          ),
        );
      },
    );
  }

  Future<void> _linkWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.linkWithGoogle();
      if (result == null) return; // cancelled
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountLinked), backgroundColor: AppColors.primary),
        );
        ref.invalidate(authStateProvider);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = e.code == 'credential-already-in-use'
            ? l10n.accountAlreadyLinked
            : l10n.linkFailed(e.message ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _linkWithApple(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.linkWithApple();
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountLinked), backgroundColor: AppColors.primary),
        );
        ref.invalidate(authStateProvider);
      }
    } on AppleSignInException catch (e) {
      if (context.mounted && e.error.shouldShowSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.error.getLocalizedMessage(context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = e.code == 'credential-already-in-use'
            ? l10n.accountAlreadyLinked
            : l10n.linkFailed(e.message ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
