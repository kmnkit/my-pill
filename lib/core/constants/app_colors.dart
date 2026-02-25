import 'dart:ui';

abstract final class AppColors {
  // Primary
  static const Color primary = Color(0xFF0D968B);
  static const Color primaryBright = Color(0xFF14EBD9);
  static const Color primaryDark = Color(0xFF0EA699);
  static const Color primaryLight = Color(0xFFF0FDFA);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF6F8F8);
  static const Color backgroundDark = Color(0xFF102220);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2C2A);
  static const Color cardLight = Color(0xFFF1F5F9);
  static const Color cardDark = Color(0xFF1E3330);

  // Text
  static const Color textPrimary = Color(0xFF111817);
  static const Color textPrimaryDark = Color(0xFFE8EDEC);
  static const Color textMuted = Color(0xFF618986);
  static const Color textMutedDark = Color(0xFF8BA8A5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color successBright = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFF97316);
  static const Color info = Color(0xFF94A3B8);

  // Pill Colors (for color picker)
  static const Color pillWhite = Color(0xFFFFFFFF);
  static const Color pillBlue = Color(0xFF2196F3);
  static const Color pillYellow = Color(0xFFFFEB3B);
  static const Color pillPink = Color(0xFFE91E63);
  static const Color pillRed = Color(0xFFEF4444);
  static const Color pillGreen = Color(0xFF10B981);
  static const Color pillOrange = Color(0xFFF59E0B);
  static const Color pillPurple = Color(0xFF8B5CF6);

  // Nav Bar Unselected (neutral blue-gray, hue 218-220 — distinct from teal hue 174-176)
  static const Color navUnselectedLight = Color(0xFF6B7280); // H=220 S=9% L=46%
  static const Color navUnselectedDark = Color(0xFF9CA3AF);  // H=218 S=11% L=65%

  // Borders
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF2D4A47);

  // High Contrast - Light
  static const Color hcBackgroundLight = Color(0xFFFFFFFF);
  static const Color hcSurfaceLight = Color(0xFFF5F5F5);
  static const Color hcTextPrimary = Color(0xFF000000);
  static const Color hcTextMuted = Color(0xFF333333);
  static const Color hcBorderLight = Color(0xFF000000);
  static const Color hcPrimary = Color(0xFF006B5E);
  static const Color hcCardLight = Color(0xFFE8E8E8);

  // High Contrast - Dark
  static const Color hcBackgroundDark = Color(0xFF000000);
  static const Color hcSurfaceDark = Color(0xFF1A1A1A);
  static const Color hcTextPrimaryDark = Color(0xFFFFFFFF);
  static const Color hcTextMutedDark = Color(0xFFCCCCCC);
  static const Color hcBorderDark = Color(0xFFFFFFFF);
  static const Color hcPrimaryDark = Color(0xFF14EBD9);
  static const Color hcCardDark = Color(0xFF2A2A2A);

  // Glassmorphism - Light
  static const Color glassWhite = Color(0x26FFFFFF); // 15% white
  static const Color glassWhiteStrong = Color(0x4DFFFFFF); // 30% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white border
  static const Color glassBorderLight = Color(0x1A000000); // 10% black for light mode

  // Glassmorphism - Dark
  static const Color glassDark = Color(0x26000000); // 15% black
  static const Color glassDarkStrong = Color(0x4D000000); // 30% black
  static const Color glassBorderDark = Color(0x33FFFFFF); // 20% white border

  // Gradient Backgrounds - Light
  static const Color gradientLightStart = Color(0xFFE0F7F5); // Subtle teal
  static const Color gradientLightMid = Color(0xFFF0FDFA); // Very light teal
  static const Color gradientLightEnd = Color(0xFFE6FFFA); // Mint tint

  // Gradient Backgrounds - Dark
  static const Color gradientDarkStart = Color(0xFF0D1F1D); // Deep teal
  static const Color gradientDarkMid = Color(0xFF102220); // Dark teal
  static const Color gradientDarkEnd = Color(0xFF1A2C2A); // Slightly lighter
}
