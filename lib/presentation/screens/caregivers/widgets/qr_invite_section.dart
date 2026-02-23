import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:my_pill/core/utils/error_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/invite_provider.dart';
import 'package:my_pill/data/providers/caregiver_provider.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/premium_gate.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/qr_scanner_screen.dart';
import 'package:my_pill/presentation/router/route_names.dart';

class QrInviteSection extends ConsumerStatefulWidget {
  const QrInviteSection({super.key});

  @override
  ConsumerState<QrInviteSection> createState() => _QrInviteSectionState();
}

class _QrInviteSectionState extends ConsumerState<QrInviteSection> {
  bool _isGenerating = false;
  String? _generatedUrl;
  String? _generatedCode;

  Future<void> _generateInvite() async {
    // Check if user can add more caregivers
    final canAdd = await ref.read(canAddCaregiverProvider.future);

    if (!canAdd) {
      if (mounted) {
        _showPremiumLimitDialog();
      }
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final cfService = ref.read(cloudFunctionsServiceProvider);
      final result = await cfService.generateInviteLink();

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _generatedUrl = result.url;
          _generatedCode = result.code;
          _isGenerating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.inviteLinkGenerated),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isGenerating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToGenerateInvite(e.toString())),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showPremiumLimitDialog() {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.read(isPremiumProvider);

    if (isPremium) {
      // Should not happen, but show generic error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotAddMoreCaregivers),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: AppColors.warning,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.caregiverLimitReached),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.upgradeToPremium),
            const SizedBox(height: AppSpacing.md),
            PremiumInlineUpsell(
              message: l10n.unlimitedCaregivers,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RouteNames.premium);
            },
            icon: const Icon(Icons.upgrade, size: AppSpacing.iconSm),
            label: Text(l10n.tryPremium),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MpSectionHeader(title: l10n.inviteCaregiver),
        MpCard(
          child: _generatedUrl == null
              ? _buildGenerateButton(l10n)
              : _buildInviteContent(l10n),
        ),
      ],
    );
  }

  Widget _buildGenerateButton(AppLocalizations l10n) {
    return Column(
      children: [
        Icon(
          Icons.qr_code_2,
          size: 80,
          color: AppColors.textMuted,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.generateInviteLinkDesc,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : _generateInvite,
          icon: _isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_link),
          label: Text(_isGenerating ? l10n.generating : l10n.generateInviteLink),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => _scanQrCode(context),
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l10n.scanQrCode),
        ),
      ],
    );
  }

  Widget _buildInviteContent(AppLocalizations l10n) {
    return Column(
      children: [
        QrImageView(
          data: _generatedUrl!,
          version: QrVersions.auto,
          size: 200,
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Code: $_generatedCode',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontFamily: 'monospace',
              ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShareButton(
              context,
              Icons.link,
              l10n.link,
              () => _copyLink(context, _generatedUrl!),
            ),
            const SizedBox(width: AppSpacing.lg),
            _buildShareButton(
              context,
              Icons.message,
              l10n.line,
              () => _shareViaApp(_generatedUrl!),
            ),
            const SizedBox(width: AppSpacing.lg),
            _buildShareButton(
              context,
              Icons.email,
              'Email',
              () => _shareViaApp(_generatedUrl!),
            ),
            const SizedBox(width: AppSpacing.lg),
            _buildShareButton(
              context,
              Icons.sms,
              l10n.sms,
              () => _shareViaApp(_generatedUrl!),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _scanQrCode(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.scanQrCode),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _generateInvite,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.newLink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _copyLink(BuildContext context, String inviteUrl) async {
    await Clipboard.setData(ClipboardData(text: inviteUrl));
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.linkCopied),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareViaApp(String inviteUrl) async {
    final l10n = AppLocalizations.of(context)!;
    await SharePlus.instance.share(
      ShareParams(
        text: inviteUrl,
        subject: l10n.joinMeOnMyPill,
      ),
    );
  }

  Future<void> _scanQrCode(BuildContext context) async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const QrScannerScreen(),
      ),
    );

    if (code != null && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.processingInvite),
          duration: const Duration(seconds: 2),
        ),
      );

      try {
        final cfService = ref.read(cloudFunctionsServiceProvider);
        await cfService.acceptInvite(code);

        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.inviteAccepted),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e, st) {
        ErrorHandler.debugLog(e, st, 'acceptInviteQr');
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToAcceptInvite),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Widget _buildShareButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconMd,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
