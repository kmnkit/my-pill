import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/presentation/shared/widgets/mp_alert_banner.dart';

class LowStockBanner extends StatelessWidget {
  const LowStockBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MpAlertBanner(
      title: 'Vitamin D - 2 pills remaining',
      icon: Icons.warning_amber_rounded,
      color: AppColors.warning,
      onTap: () {
        // Navigate to medication detail or stock management
      },
    );
  }
}
