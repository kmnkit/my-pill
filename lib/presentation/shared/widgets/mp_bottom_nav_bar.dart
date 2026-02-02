import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';

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

  List<BottomNavigationBarItem> get _patientItems => const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Adherence'),
    BottomNavigationBarItem(icon: Icon(Icons.medication_outlined), activeIcon: Icon(Icons.medication), label: 'Medications'),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<BottomNavigationBarItem> get _caregiverItems => const [
    BottomNavigationBarItem(icon: Icon(Icons.people_outlined), activeIcon: Icon(Icons.people), label: 'Patients'),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Notifications'),
    BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), activeIcon: Icon(Icons.warning_amber), label: 'Alerts'),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: mode == MpNavMode.patient ? _patientItems : _caregiverItems,
      elevation: 0,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    );
  }
}
