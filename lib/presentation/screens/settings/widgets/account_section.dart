import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_avatar.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_card.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/data/services/auth_service.dart';
import 'package:kusuridoki/core/utils/apple_auth_error_messages.dart';

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
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }

        final isAnonymous = user.isAnonymous;
        final userProfile = ref.watch(userSettingsProvider).value;
        final profileName = userProfile?.name;
        // Fallback chain: profile name (if not null/empty/legacy 'User') -> Firebase displayName -> email prefix -> guest
        final displayName =
            (profileName != null &&
                profileName.isNotEmpty &&
                profileName != 'User')
            ? profileName
            : (user.displayName ??
                  (user.email?.split('@').first ?? l10n.guestUser));
        final email = userProfile?.email ?? user.email ?? l10n.noEmail;
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.appColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                MpButton(
                  label: l10n.linkWithGoogle,
                  onPressed: () => _linkWithGoogle(context, ref),
                  variant: MpButtonVariant.secondary,
                  iconWidget: Image.asset(
                    'assets/icons/google-logo.png',
                    width: 20,
                    height: 20,
                  ),
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
                          color: context.appColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppSpacing.iconMd,
                color: context.appColors.textMuted,
              ),
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
          SnackBar(
            content: Text(l10n.accountLinked),
            backgroundColor: AppColors.primary,
          ),
        );
        ref.invalidate(authStateProvider);
      }
    } on FirebaseAuthException catch (e, st) {
      ErrorHandler.debugLog(e, st, 'linkWithGoogle');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = e.code == 'credential-already-in-use'
            ? l10n.accountAlreadyLinked
            : l10n.linkFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _linkWithApple(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.linkWithApple();
      if (result == null) return; // User cancelled
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountLinked),
            backgroundColor: AppColors.primary,
          ),
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
    } on FirebaseAuthException catch (e, st) {
      ErrorHandler.debugLog(e, st, 'linkWithApple');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = e.code == 'credential-already-in-use'
            ? l10n.accountAlreadyLinked
            : l10n.linkFailed;
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
