import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/screens/home/widgets/greeting_header.dart';
import 'package:my_pill/presentation/screens/home/widgets/low_stock_banner.dart';
import 'package:my_pill/presentation/screens/home/widgets/medication_timeline.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: AppSpacing.xxl),
              const MedicationTimeline(),
              const SizedBox(height: AppSpacing.lg),
              const LowStockBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
