import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_typography.dart';

void main() {
  group('AppTypography', () {
    test('scaleForTextSize returns correct scale factors', () {
      expect(AppTypography.scaleForTextSize('normal'), 1.0);
      expect(AppTypography.scaleForTextSize('large'), 1.2);
      expect(AppTypography.scaleForTextSize('xl'), 1.4);
    });

    test('scaleForTextSize defaults to 1.0 for unknown values', () {
      expect(AppTypography.scaleForTextSize('unknown'), 1.0);
      expect(AppTypography.scaleForTextSize(''), 1.0);
    });
  });

  group('AppColors high contrast', () {
    test('HC light theme has sufficient text contrast ratio', () {
      // WCAG AA requires >= 4.5:1 for normal text
      // hcTextPrimary (#000000) on hcBackgroundLight (#FFFFFF) = 21:1
      final textLuminance = AppColors.hcTextPrimary.computeLuminance();
      final bgLuminance = AppColors.hcBackgroundLight.computeLuminance();
      final lighter = textLuminance > bgLuminance ? textLuminance : bgLuminance;
      final darker = textLuminance > bgLuminance ? bgLuminance : textLuminance;
      final ratio = (lighter + 0.05) / (darker + 0.05);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('HC dark theme has sufficient text contrast ratio', () {
      final textLuminance = AppColors.hcTextPrimaryDark.computeLuminance();
      final bgLuminance = AppColors.hcBackgroundDark.computeLuminance();
      final lighter = textLuminance > bgLuminance ? textLuminance : bgLuminance;
      final darker = textLuminance > bgLuminance ? bgLuminance : textLuminance;
      final ratio = (lighter + 0.05) / (darker + 0.05);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });
  });
}
