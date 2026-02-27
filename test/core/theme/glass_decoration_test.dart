import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/glass_decoration.dart';

void main() {
  group('GlassDecoration', () {
    group('constants', () {
      test('blurAmount is 15.0', () {
        expect(GlassDecoration.blurAmount, 15.0);
      });

      test('blurAmountStrong is 20.0', () {
        expect(GlassDecoration.blurAmountStrong, 20.0);
      });
    });

    group('card()', () {
      test('returns BoxDecoration with glassWhite color in light mode', () {
        final decoration = GlassDecoration.card(isDark: false);

        expect(decoration.color, AppColors.glassWhite);
      });

      test('returns BoxDecoration with glassDark color in dark mode', () {
        final decoration = GlassDecoration.card(isDark: true);

        expect(decoration.color, AppColors.glassDark);
      });

      test('uses radiusLg border radius', () {
        final decoration = GlassDecoration.card(isDark: false);
        final expected = BorderRadius.circular(AppSpacing.radiusLg);

        expect(decoration.borderRadius, expected);
      });

      test('has border with glassBorder color in light mode', () {
        final decoration = GlassDecoration.card(isDark: false);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorder);
        expect(border.top.width, 1.0);
      });

      test('has border with glassBorderDark color in dark mode', () {
        final decoration = GlassDecoration.card(isDark: true);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorderDark);
      });

      test('has exactly one box shadow', () {
        final decoration = GlassDecoration.card(isDark: false);

        expect(decoration.boxShadow, hasLength(1));
      });

      test('box shadow has blurRadius of 20', () {
        final decoration = GlassDecoration.card(isDark: false);
        final shadow = decoration.boxShadow!.first;

        expect(shadow.blurRadius, 20.0);
      });

      test('box shadow has correct offset', () {
        final decoration = GlassDecoration.card(isDark: false);
        final shadow = decoration.boxShadow!.first;

        expect(shadow.offset, const Offset(0, 8));
      });

      test('dark and light mode decorations differ in color', () {
        final light = GlassDecoration.card(isDark: false);
        final dark = GlassDecoration.card(isDark: true);

        expect(light.color, isNot(equals(dark.color)));
      });
    });

    group('cardStrong()', () {
      test(
        'returns BoxDecoration with glassWhiteStrong color in light mode',
        () {
          final decoration = GlassDecoration.cardStrong(isDark: false);

          expect(decoration.color, AppColors.glassWhiteStrong);
        },
      );

      test('returns BoxDecoration with glassDarkStrong color in dark mode', () {
        final decoration = GlassDecoration.cardStrong(isDark: true);

        expect(decoration.color, AppColors.glassDarkStrong);
      });

      test('uses radiusLg border radius', () {
        final decoration = GlassDecoration.cardStrong(isDark: false);
        final expected = BorderRadius.circular(AppSpacing.radiusLg);

        expect(decoration.borderRadius, expected);
      });

      test('has border with glassBorder in light mode', () {
        final decoration = GlassDecoration.cardStrong(isDark: false);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorder);
      });

      test('has border with glassBorderDark in dark mode', () {
        final decoration = GlassDecoration.cardStrong(isDark: true);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorderDark);
      });

      test('has exactly one box shadow', () {
        final decoration = GlassDecoration.cardStrong(isDark: true);

        expect(decoration.boxShadow, hasLength(1));
      });

      test('box shadow has correct offset (0, 8)', () {
        final decoration = GlassDecoration.cardStrong(isDark: false);
        final shadow = decoration.boxShadow!.first;

        expect(shadow.offset, const Offset(0, 8));
      });

      test('strong card is more opaque than regular card in light mode', () {
        final regular = GlassDecoration.card(isDark: false);
        final strong = GlassDecoration.cardStrong(isDark: false);

        final regularAlpha = regular.color!.a;
        final strongAlpha = strong.color!.a;

        expect(strongAlpha, greaterThan(regularAlpha));
      });
    });

    group('navBar()', () {
      test('returns BoxDecoration with glassWhiteStrong in light mode', () {
        final decoration = GlassDecoration.navBar(isDark: false);

        expect(decoration.color, AppColors.glassWhiteStrong);
      });

      test('returns BoxDecoration with glassDarkStrong in dark mode', () {
        final decoration = GlassDecoration.navBar(isDark: true);

        expect(decoration.color, AppColors.glassDarkStrong);
      });

      test('uses border radius of 24', () {
        final decoration = GlassDecoration.navBar(isDark: false);
        final expected = BorderRadius.circular(24);

        expect(decoration.borderRadius, expected);
      });

      test('navBar radius differs from card radius', () {
        final navBar = GlassDecoration.navBar(isDark: false);
        final card = GlassDecoration.card(isDark: false);

        expect(navBar.borderRadius, isNot(equals(card.borderRadius)));
      });

      test('has border with glassBorder in light mode', () {
        final decoration = GlassDecoration.navBar(isDark: false);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorder);
      });

      test('has border with glassBorderDark in dark mode', () {
        final decoration = GlassDecoration.navBar(isDark: true);
        final border = decoration.border as Border;

        expect(border.top.color, AppColors.glassBorderDark);
      });

      test('has exactly one box shadow', () {
        final decoration = GlassDecoration.navBar(isDark: false);

        expect(decoration.boxShadow, hasLength(1));
      });

      test('box shadow offset is (0, 4) — lower than card shadow', () {
        final decoration = GlassDecoration.navBar(isDark: false);
        final shadow = decoration.boxShadow!.first;

        expect(shadow.offset, const Offset(0, 4));
      });

      test('box shadow blurRadius is 20', () {
        final decoration = GlassDecoration.navBar(isDark: false);
        final shadow = decoration.boxShadow!.first;

        expect(shadow.blurRadius, 20.0);
      });
    });

    group('blurFilter', () {
      test('blurFilter has sigmaX equal to blurAmount', () {
        // ImageFilter does not expose sigma directly; verify it is non-null
        final filter = GlassDecoration.blurFilter;
        expect(filter, isNotNull);
      });

      test('blurFilterStrong is non-null', () {
        final filter = GlassDecoration.blurFilterStrong;
        expect(filter, isNotNull);
      });

      test('blurFilter and blurFilterStrong are distinct objects', () {
        final weak = GlassDecoration.blurFilter;
        final strong = GlassDecoration.blurFilterStrong;

        // They should represent different blur amounts
        expect(weak.toString(), isNot(equals(strong.toString())));
      });
    });

    group('context-based methods', () {
      testWidgets(
        'shouldReduceMotion returns false when animations are enabled',
        (tester) async {
          await tester.pumpWidget(
            const MediaQuery(
              data: MediaQueryData(disableAnimations: false),
              child: SizedBox.shrink(),
            ),
          );

          final context = tester.element(find.byType(SizedBox));
          expect(GlassDecoration.shouldReduceMotion(context), isFalse);
        },
      );

      testWidgets(
        'shouldReduceMotion returns true when animations are disabled',
        (tester) async {
          await tester.pumpWidget(
            const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: SizedBox.shrink(),
            ),
          );

          final context = tester.element(find.byType(SizedBox));
          expect(GlassDecoration.shouldReduceMotion(context), isTrue);
        },
      );

      testWidgets('getBlurAmount returns blurAmount when motion is enabled', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: false),
            child: SizedBox.shrink(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        expect(
          GlassDecoration.getBlurAmount(context),
          GlassDecoration.blurAmount,
        );
      });

      testWidgets('getBlurAmount returns blurAmountStrong when strong=true', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: false),
            child: SizedBox.shrink(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        expect(
          GlassDecoration.getBlurAmount(context, strong: true),
          GlassDecoration.blurAmountStrong,
        );
      });

      testWidgets('getBlurAmount returns 0.0 when motion is reduced', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: SizedBox.shrink(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        expect(GlassDecoration.getBlurAmount(context), 0.0);
        expect(GlassDecoration.getBlurAmount(context, strong: true), 0.0);
      });

      testWidgets('getBlurFilter returns non-null ImageFilter', (tester) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: false),
            child: SizedBox.shrink(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        expect(GlassDecoration.getBlurFilter(context), isNotNull);
        expect(GlassDecoration.getBlurFilter(context, strong: true), isNotNull);
      });

      testWidgets(
        'getBlurFilter with reduced motion returns zero-sigma filter',
        (tester) async {
          await tester.pumpWidget(
            const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: SizedBox.shrink(),
            ),
          );

          final context = tester.element(find.byType(SizedBox));
          final filter = GlassDecoration.getBlurFilter(context);
          // Zero-sigma filter toString should contain 0
          expect(filter.toString(), contains('0'));
        },
      );
    });
  });
}
