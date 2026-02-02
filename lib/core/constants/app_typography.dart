import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextTheme get textTheme => scaledTextTheme();

  /// Canonical text size to scale factor mapping.
  /// UserProfile.textSize stores lowercase: 'normal', 'large', 'xl'.
  static double scaleForTextSize(String textSize) {
    switch (textSize) {
      case 'large':
        return 1.2;
      case 'xl':
        return 1.4;
      case 'normal':
      default:
        return 1.0;
    }
  }

  /// Returns a scaled text theme. For high-contrast, bump font weights.
  static TextTheme scaledTextTheme({
    double scaleFactor = 1.0,
    bool bold = false,
  }) {
    FontWeight w(FontWeight base) {
      if (!bold) return base;
      // Bump weight by one level for high-contrast
      const weights = [
        FontWeight.w100, FontWeight.w200, FontWeight.w300,
        FontWeight.w400, FontWeight.w500, FontWeight.w600,
        FontWeight.w700, FontWeight.w800, FontWeight.w900,
      ];
      final idx = weights.indexOf(base);
      if (idx < 0 || idx >= weights.length - 1) return base;
      return weights[idx + 1];
    }

    double s(double base) => base * scaleFactor;

    return TextTheme(
      headlineLarge: GoogleFonts.lexend(fontSize: s(28), fontWeight: w(FontWeight.w700), height: 1.2),
      headlineMedium: GoogleFonts.lexend(fontSize: s(24), fontWeight: w(FontWeight.w600), height: 1.25),
      headlineSmall: GoogleFonts.lexend(fontSize: s(20), fontWeight: w(FontWeight.w600), height: 1.3),
      titleLarge: GoogleFonts.lexend(fontSize: s(18), fontWeight: w(FontWeight.w500), height: 1.35),
      titleMedium: GoogleFonts.lexend(fontSize: s(16), fontWeight: w(FontWeight.w500), height: 1.4),
      titleSmall: GoogleFonts.lexend(fontSize: s(14), fontWeight: w(FontWeight.w500), height: 1.4),
      bodyLarge: GoogleFonts.lexend(fontSize: s(16), fontWeight: w(FontWeight.w400), height: 1.5),
      bodyMedium: GoogleFonts.lexend(fontSize: s(14), fontWeight: w(FontWeight.w400), height: 1.5),
      bodySmall: GoogleFonts.lexend(fontSize: s(12), fontWeight: w(FontWeight.w400), height: 1.5),
      labelLarge: GoogleFonts.lexend(fontSize: s(16), fontWeight: w(FontWeight.w600), height: 1.4),
      labelMedium: GoogleFonts.lexend(fontSize: s(14), fontWeight: w(FontWeight.w500), height: 1.4),
      labelSmall: GoogleFonts.lexend(fontSize: s(12), fontWeight: w(FontWeight.w500), height: 1.4),
    );
  }
}
