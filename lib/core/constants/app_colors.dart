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

  // Borders
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF2D4A47);
}
