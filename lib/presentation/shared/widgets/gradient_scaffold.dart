import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';

/// A scaffold with gradient background for glassmorphism UI.
///
/// Provides the subtle teal gradient background required for glass effects
/// to look correct. Use this instead of regular Scaffold for main screens.
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// A bottom navigation bar to display at the bottom of the scaffold.
  final Widget? bottomNavigationBar;

  /// A floating action button displayed over the content.
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Whether the body should resize to avoid the bottom inset (keyboard).
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if high contrast mode is enabled - skip gradient for solid colors
    final isHighContrast = MediaQuery.of(context).highContrast;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: isHighContrast
          ? body
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? const [
                          AppColors.gradientDarkStart,
                          AppColors.gradientDarkMid,
                          AppColors.gradientDarkEnd,
                        ]
                      : const [
                          AppColors.gradientLightStart,
                          AppColors.gradientLightMid,
                          AppColors.gradientLightEnd,
                        ],
                ),
              ),
              child: body,
            ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
