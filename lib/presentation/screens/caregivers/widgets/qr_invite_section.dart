import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/qr_scanner_screen.dart';

class QrInviteSection extends ConsumerWidget {
  const QrInviteSection({super.key});

  String _getInviteUrl(WidgetRef ref) {
    final userId = ref.read(authServiceProvider).currentUser?.uid ?? 'GUEST';
    return 'https://mypill.app/invite/$userId';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteUrl = _getInviteUrl(ref);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MpSectionHeader(title: 'Invite Caregiver'),
        MpCard(
          child: Column(
            children: [
              QrImageView(
                data: inviteUrl,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildShareButton(
                    context,
                    Icons.link,
                    'Link',
                    () => _copyLink(context, inviteUrl),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(
                    context,
                    Icons.message,
                    'LINE',
                    () => _shareViaApp(inviteUrl),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(
                    context,
                    Icons.email,
                    'Email',
                    () => _shareViaApp(inviteUrl),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(
                    context,
                    Icons.sms,
                    'SMS',
                    () => _shareViaApp(inviteUrl),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => _scanQrCode(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Code'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _copyLink(BuildContext context, String inviteUrl) async {
    await Clipboard.setData(ClipboardData(text: inviteUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareViaApp(String inviteUrl) async {
    await SharePlus.instance.share(
      ShareParams(
        text: inviteUrl,
        subject: 'Join me on MyPill',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing invite...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Show success message since Firebase integration is pending
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scanned invite code: $code (Firebase integration pending)'),
            backgroundColor: AppColors.success,
          ),
        );
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
