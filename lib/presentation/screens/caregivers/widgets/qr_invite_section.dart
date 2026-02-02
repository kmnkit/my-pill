import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/screens/caregivers/widgets/qr_scanner_screen.dart';

class QrInviteSection extends StatelessWidget {
  const QrInviteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MpSectionHeader(title: 'Invite Caregiver'),
        MpCard(
          child: Column(
            children: [
              QrImageView(
                data: 'https://mypill.app/invite/MOCK_CODE',
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildShareButton(context, Icons.link, 'Link'),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(context, Icons.message, 'LINE'),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(context, Icons.email, 'Email'),
                  const SizedBox(width: AppSpacing.lg),
                  _buildShareButton(context, Icons.sms, 'SMS'),
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

  Future<void> _scanQrCode(BuildContext context) async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const QrScannerScreen(),
      ),
    );

    if (code != null && context.mounted) {
      // TODO: Process invite code with Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned invite code: $code')),
      );
    }
  }

  Widget _buildShareButton(BuildContext context, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
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
    );
  }
}
