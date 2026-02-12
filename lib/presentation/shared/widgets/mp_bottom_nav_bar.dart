import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/l10n/app_localizations.dart';

enum MpNavMode { patient, caregiver }

class MpBottomNavBar extends StatelessWidget {
  const MpBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.mode = MpNavMode.patient,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final MpNavMode mode;

  List<BottomNavigationBarItem> _patientItems(AppLocalizations l10n) => [
    BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: l10n.home),
    BottomNavigationBarItem(icon: const Icon(Icons.calendar_today_outlined), activeIcon: const Icon(Icons.calendar_today), label: l10n.adherence),
    BottomNavigationBarItem(icon: const Icon(Icons.medication_outlined), activeIcon: const Icon(Icons.medication), label: l10n.medications),
    BottomNavigationBarItem(icon: const Icon(Icons.settings_outlined), activeIcon: const Icon(Icons.settings), label: l10n.settings),
  ];

  List<BottomNavigationBarItem> _caregiverItems(AppLocalizations l10n) => [
    BottomNavigationBarItem(icon: const Icon(Icons.people_outlined), activeIcon: const Icon(Icons.people), label: l10n.patients),
    BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), activeIcon: const Icon(Icons.notifications), label: l10n.notifications),
    BottomNavigationBarItem(icon: const Icon(Icons.warning_amber_outlined), activeIcon: const Icon(Icons.warning_amber), label: l10n.alerts),
    BottomNavigationBarItem(icon: const Icon(Icons.settings_outlined), activeIcon: const Icon(Icons.settings), label: l10n.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: mode == MpNavMode.patient ? _patientItems(l10n) : _caregiverItems(l10n),
      elevation: 0,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    );
  }
}
