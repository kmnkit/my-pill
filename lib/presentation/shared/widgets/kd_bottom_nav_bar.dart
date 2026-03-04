import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/glass_decoration.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

enum KdNavMode { patient, caregiver }

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class KdBottomNavBar extends StatelessWidget {
  const KdBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.mode = KdNavMode.patient,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final KdNavMode mode;

  List<_NavItem> _patientItems(AppLocalizations l10n) => [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: l10n.home,
    ),
    _NavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: l10n.adherence,
    ),
    _NavItem(
      icon: Icons.medication_outlined,
      activeIcon: Icons.medication,
      label: l10n.medications,
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: l10n.settings,
    ),
  ];

  List<_NavItem> _caregiverItems(AppLocalizations l10n) => [
    _NavItem(
      icon: Icons.people_outlined,
      activeIcon: Icons.people,
      label: l10n.patients,
    ),
    _NavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: l10n.notifications,
    ),
    _NavItem(
      icon: Icons.warning_amber_outlined,
      activeIcon: Icons.warning_amber,
      label: l10n.alerts,
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: l10n.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighContrast = MediaQuery.of(context).highContrast;

    if (isHighContrast) {
      return _buildSolidNavBar(context, l10n, isDark);
    }

    return _buildGlassNavBar(context, l10n, isDark);
  }

  Widget _buildNavItems({
    required BuildContext context,
    required List<_NavItem> items,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return SizedBox(
      height: 56,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          final color = isSelected ? selectedColor : unselectedColor;

          return Expanded(
            child: Semantics(
              selected: isSelected,
              label: item.label,
              button: true,
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: 24,
                      color: color,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGlassNavBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final blurAmount = GlassDecoration.getBlurAmount(context, strong: true);
    final items = mode == KdNavMode.patient
        ? _patientItems(l10n)
        : _caregiverItems(l10n);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.glassDarkStrong
                  : AppColors.glassWhiteStrong,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildNavItems(
              context: context,
              items: items,
              selectedColor: isDark
                  ? AppColors.primaryBright
                  : AppColors.primary,
              unselectedColor: isDark
                  ? AppColors.navUnselectedDark
                  : AppColors.navUnselectedLight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolidNavBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final items = mode == KdNavMode.patient
        ? _patientItems(l10n)
        : _caregiverItems(l10n);

    return Container(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: _buildNavItems(
        context: context,
        items: items,
        selectedColor: isDark ? AppColors.hcPrimaryDark : AppColors.hcPrimary,
        unselectedColor: isDark
            ? AppColors.hcTextMutedDark
            : AppColors.hcTextMuted,
      ),
    );
  }
}
