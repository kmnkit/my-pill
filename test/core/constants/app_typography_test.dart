import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/constants/app_typography.dart';

// Helper: build a minimal widget that exercises AppTypography inside the
// widget tree so that google_fonts' async font loading is drained by
// pumpAndSettle before the test ends — preventing "failed after completed".
Widget _buildWithTheme(TextTheme theme) {
  return MaterialApp(
    theme: ThemeData(textTheme: theme),
    home: const Scaffold(body: SizedBox.shrink()),
  );
}

void main() {
  // AppTypography.scaleForTextSize — pure Dart, no binding needed.
  group('AppTypography.scaleForTextSize', () {
    test('returns 1.0 for normal', () {
      expect(AppTypography.scaleForTextSize('normal'), 1.0);
    });

    test('returns 1.2 for large', () {
      expect(AppTypography.scaleForTextSize('large'), 1.2);
    });

    test('returns 1.4 for xl', () {
      expect(AppTypography.scaleForTextSize('xl'), 1.4);
    });

    test('returns 1.0 for unknown value (default)', () {
      expect(AppTypography.scaleForTextSize('unknown'), 1.0);
    });

    test('returns 1.0 for empty string (default)', () {
      expect(AppTypography.scaleForTextSize(''), 1.0);
    });

    test('scale values are ordered: normal < large < xl', () {
      final normal = AppTypography.scaleForTextSize('normal');
      final large = AppTypography.scaleForTextSize('large');
      final xl = AppTypography.scaleForTextSize('xl');
      expect(normal, lessThan(large));
      expect(large, lessThan(xl));
    });

    test('returns 1.0 for case-sensitive mismatch', () {
      // Keys are lowercase only
      expect(AppTypography.scaleForTextSize('Normal'), 1.0);
      expect(AppTypography.scaleForTextSize('LARGE'), 1.0);
      expect(AppTypography.scaleForTextSize('XL'), 1.0);
    });
  });

  // AppTypography.textTheme and scaledTextTheme — use testWidgets so that
  // google_fonts' async font-load futures are drained by pumpAndSettle.
  group('AppTypography.textTheme', () {
    testWidgets('returns a non-null TextTheme', (tester) async {
      final theme = AppTypography.textTheme;
      expect(theme, isNotNull);
      expect(theme, isA<TextTheme>());
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('textTheme has all required text styles', (tester) async {
      final theme = AppTypography.textTheme;
      expect(theme.headlineLarge, isNotNull);
      expect(theme.headlineMedium, isNotNull);
      expect(theme.headlineSmall, isNotNull);
      expect(theme.titleLarge, isNotNull);
      expect(theme.titleMedium, isNotNull);
      expect(theme.titleSmall, isNotNull);
      expect(theme.bodyLarge, isNotNull);
      expect(theme.bodyMedium, isNotNull);
      expect(theme.bodySmall, isNotNull);
      expect(theme.labelLarge, isNotNull);
      expect(theme.labelMedium, isNotNull);
      expect(theme.labelSmall, isNotNull);
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });
  });

  group('AppTypography.scaledTextTheme', () {
    testWidgets('default parameters return a valid TextTheme', (tester) async {
      final theme = AppTypography.scaledTextTheme();
      expect(theme, isNotNull);
      expect(theme, isA<TextTheme>());
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('all text styles have correct base font sizes (scaleFactor=1.0)',
        (tester) async {
      final theme = AppTypography.scaledTextTheme();
      expect(theme.headlineLarge!.fontSize, closeTo(28, 0.01));
      expect(theme.headlineMedium!.fontSize, closeTo(24, 0.01));
      expect(theme.headlineSmall!.fontSize, closeTo(20, 0.01));
      expect(theme.titleLarge!.fontSize, closeTo(18, 0.01));
      expect(theme.titleMedium!.fontSize, closeTo(16, 0.01));
      expect(theme.titleSmall!.fontSize, closeTo(14, 0.01));
      expect(theme.bodyLarge!.fontSize, closeTo(16, 0.01));
      expect(theme.bodyMedium!.fontSize, closeTo(14, 0.01));
      expect(theme.bodySmall!.fontSize, closeTo(12, 0.01));
      expect(theme.labelLarge!.fontSize, closeTo(16, 0.01));
      expect(theme.labelMedium!.fontSize, closeTo(14, 0.01));
      expect(theme.labelSmall!.fontSize, closeTo(12, 0.01));
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('scaleFactor scales font sizes proportionally', (tester) async {
      final normal = AppTypography.scaledTextTheme();
      final scaled = AppTypography.scaledTextTheme(scaleFactor: 2.0);

      final normalSize = normal.headlineLarge!.fontSize!;
      final scaledSize = scaled.headlineLarge!.fontSize!;
      expect(scaledSize, closeTo(normalSize * 2.0, 0.01));

      await tester.pumpWidget(_buildWithTheme(scaled));
      await tester.pumpAndSettle();
    });

    testWidgets('scaleFactor=1.2 (large) scales font sizes', (tester) async {
      final normal = AppTypography.scaledTextTheme();
      final scaled = AppTypography.scaledTextTheme(scaleFactor: 1.2);

      final normalSize = normal.bodyMedium!.fontSize!;
      final scaledSize = scaled.bodyMedium!.fontSize!;
      expect(scaledSize, closeTo(normalSize * 1.2, 0.01));

      await tester.pumpWidget(_buildWithTheme(scaled));
      await tester.pumpAndSettle();
    });

    testWidgets('scaleFactor=1.4 (xl) scales font sizes', (tester) async {
      final normal = AppTypography.scaledTextTheme();
      final scaled = AppTypography.scaledTextTheme(scaleFactor: 1.4);

      final normalSize = normal.bodyMedium!.fontSize!;
      final scaledSize = scaled.bodyMedium!.fontSize!;
      expect(scaledSize, closeTo(normalSize * 1.4, 0.01));

      await tester.pumpWidget(_buildWithTheme(scaled));
      await tester.pumpAndSettle();
    });

    testWidgets('bold=false keeps base font weights', (tester) async {
      final theme = AppTypography.scaledTextTheme(bold: false);
      // headlineLarge base is w700
      expect(theme.headlineLarge!.fontWeight, FontWeight.w700);
      // headlineMedium base is w600
      expect(theme.headlineMedium!.fontWeight, FontWeight.w600);
      // titleLarge base is w500
      expect(theme.titleLarge!.fontWeight, FontWeight.w500);
      // bodyMedium base is w400
      expect(theme.bodyMedium!.fontWeight, FontWeight.w400);
      // labelLarge base is w600
      expect(theme.labelLarge!.fontWeight, FontWeight.w600);
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('bold=true bumps font weights by one level', (tester) async {
      final theme = AppTypography.scaledTextTheme(bold: true);
      // headlineLarge base w700 -> bumped to w800
      expect(theme.headlineLarge!.fontWeight, FontWeight.w800);
      // headlineMedium base w600 -> bumped to w700
      expect(theme.headlineMedium!.fontWeight, FontWeight.w700);
      // headlineSmall base w600 -> bumped to w700
      expect(theme.headlineSmall!.fontWeight, FontWeight.w700);
      // titleLarge base w500 -> bumped to w600
      expect(theme.titleLarge!.fontWeight, FontWeight.w600);
      // titleMedium base w500 -> bumped to w600
      expect(theme.titleMedium!.fontWeight, FontWeight.w600);
      // titleSmall base w500 -> bumped to w600
      expect(theme.titleSmall!.fontWeight, FontWeight.w600);
      // bodyLarge base w400 -> bumped to w500
      expect(theme.bodyLarge!.fontWeight, FontWeight.w500);
      // bodyMedium base w400 -> bumped to w500
      expect(theme.bodyMedium!.fontWeight, FontWeight.w500);
      // bodySmall base w400 -> bumped to w500
      expect(theme.bodySmall!.fontWeight, FontWeight.w500);
      // labelLarge base w600 -> bumped to w700
      expect(theme.labelLarge!.fontWeight, FontWeight.w700);
      // labelMedium base w500 -> bumped to w600
      expect(theme.labelMedium!.fontWeight, FontWeight.w600);
      // labelSmall base w500 -> bumped to w600
      expect(theme.labelSmall!.fontWeight, FontWeight.w600);
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('bold=true with scaleFactor applies both transformations',
        (tester) async {
      final theme = AppTypography.scaledTextTheme(scaleFactor: 1.2, bold: true);
      final normal = AppTypography.scaledTextTheme(scaleFactor: 1.0, bold: false);

      // Font size scaled
      final normalSize = normal.bodyMedium!.fontSize!;
      final scaledSize = theme.bodyMedium!.fontSize!;
      expect(scaledSize, closeTo(normalSize * 1.2, 0.01));

      // Font weight bumped: w400 -> w500
      expect(theme.bodyMedium!.fontWeight, FontWeight.w500);

      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });

    testWidgets('w900 is boundary: styles at w700 bump to w800, not w900',
        (tester) async {
      // headlineLarge has base w700 — bold bumps it to w800 (not capped at w900)
      final theme = AppTypography.scaledTextTheme(bold: true);
      expect(theme.headlineLarge!.fontWeight, FontWeight.w800);
      await tester.pumpWidget(_buildWithTheme(theme));
      await tester.pumpAndSettle();
    });
  });
}
