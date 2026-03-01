import 'package:flutter/material.dart';

/// Theme-aware color extension replacing hardcoded [AppColors] references.
///
/// Each theme variant (light, dark, HC light, HC dark) provides values
/// that satisfy WCAG contrast ratios for their respective backgrounds.
///
/// Usage: `context.appColors.textMuted`
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color textMuted;
  final Color textPrimary;

  const AppColorsExtension({
    required this.textMuted,
    required this.textPrimary,
  });

  @override
  AppColorsExtension copyWith({
    Color? textMuted,
    Color? textPrimary,
  }) {
    return AppColorsExtension(
      textMuted: textMuted ?? this.textMuted,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    );
  }
}

/// Convenience accessor for [AppColorsExtension].
///
/// Falls back to light-theme defaults when the extension is not registered
/// (e.g. in widget tests using a plain [ThemeData]).
extension AppColorsX on BuildContext {
  static const _fallback = AppColorsExtension(
    textMuted: Color(0xFF6B7280),
    textPrimary: Color(0xFF1F2937),
  );

  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ?? _fallback;
}
