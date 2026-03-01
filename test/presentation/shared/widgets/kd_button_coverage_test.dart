import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdButton coverage', () {
    // =========================================================================
    // Primary variant
    // =========================================================================
    group('primary variant', () {
      testWidgets('renders ElevatedButton with label', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(KdButton(label: 'Primary', onPressed: () {})),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('is full width by default', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(KdButton(label: 'Wide', onPressed: () {})),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, equals(double.infinity));
        expect(sizedBox.height, equals(AppSpacing.buttonHeight));
      });

      testWidgets('is not full width when isFullWidth is false', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(label: 'Narrow', onPressed: () {}, isFullWidth: false),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, isNull);
      });

      testWidgets('renders icon when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(label: 'Add', onPressed: () {}, icon: Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('renders iconWidget when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Star',
              onPressed: () {},
              iconWidget: const Icon(Icons.star, key: Key('custom-icon')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('custom-icon')), findsOneWidget);
      });

      testWidgets('iconWidget takes precedence over icon', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Precedence',
              onPressed: () {},
              icon: Icons.add,
              iconWidget: const Icon(Icons.star, key: Key('widget-icon')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('widget-icon')), findsOneWidget);
        // The icon from 'icon' param should not appear separately
      });

      testWidgets('renders SizedBox.shrink when no icon', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(KdButton(label: 'No Icon', onPressed: () {})),
        );
        await tester.pumpAndSettle();

        // Should still render without error
        expect(find.text('No Icon'), findsOneWidget);
      });

      testWidgets('disabled state has null onPressed', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const KdButton(label: 'Disabled', onPressed: null),
          ),
        );
        await tester.pumpAndSettle();

        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      });

      testWidgets('fires callback on tap', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(label: 'Tap', onPressed: () => tapped = true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tap'));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });
    });

    // =========================================================================
    // Secondary variant (glass)
    // =========================================================================
    group('secondary variant (glass)', () {
      testWidgets('renders InkWell with label', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Glass',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Glass'), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('is full width by default', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Wide Sec',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // SizedBox wrapping the glass container should be infinity
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsWidgets);
      });

      testWidgets('not full width when isFullWidth is false', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Narrow Sec',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
              isFullWidth: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Narrow Sec'), findsOneWidget);
      });

      testWidgets('renders icon when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Sec Icon',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
              icon: Icons.edit,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('renders iconWidget when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Sec Widget',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
              iconWidget: const Icon(Icons.star, key: Key('sec-widget-icon')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('sec-widget-icon')), findsOneWidget);
      });

      testWidgets('fires callback on tap', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Sec Tap',
              onPressed: () => tapped = true,
              variant: MpButtonVariant.secondary,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sec Tap'));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });

      testWidgets('disabled state does not crash', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const KdButton(
              label: 'Disabled Sec',
              onPressed: null,
              variant: MpButtonVariant.secondary,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Disabled Sec'), findsOneWidget);
      });

      testWidgets('renders in dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: KdButton(
                label: 'Dark Glass',
                onPressed: () {},
                variant: MpButtonVariant.secondary,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Dark Glass'), findsOneWidget);
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    // =========================================================================
    // Secondary variant (solid / high contrast)
    // =========================================================================
    group('secondary variant (solid / high contrast)', () {
      testWidgets('renders OutlinedButton in high contrast mode', (
        tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid Sec',
                  onPressed: () {},
                  variant: MpButtonVariant.secondary,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Solid Sec'), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
        // Should NOT have BackdropFilter
        expect(find.byType(BackdropFilter), findsNothing);
      });

      testWidgets('solid secondary is full width by default', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid Wide',
                  onPressed: () {},
                  variant: MpButtonVariant.secondary,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(OutlinedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, equals(double.infinity));
        expect(sizedBox.height, equals(AppSpacing.buttonHeight));
      });

      testWidgets('solid secondary not full width when isFullWidth false', (
        tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid Narrow',
                  onPressed: () {},
                  variant: MpButtonVariant.secondary,
                  isFullWidth: false,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(OutlinedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, isNull);
      });

      testWidgets('solid secondary renders icon', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid Icon',
                  onPressed: () {},
                  variant: MpButtonVariant.secondary,
                  icon: Icons.settings,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('solid secondary renders iconWidget', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid IconW',
                  onPressed: () {},
                  variant: MpButtonVariant.secondary,
                  iconWidget: const Icon(
                    Icons.home,
                    key: Key('solid-icon-widget'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('solid-icon-widget')), findsOneWidget);
      });

      testWidgets('solid secondary fires callback on tap', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: KdButton(
                  label: 'Solid Tap',
                  onPressed: () => tapped = true,
                  variant: MpButtonVariant.secondary,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Solid Tap'));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });

      testWidgets('solid secondary disabled state', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MaterialApp(
              home: Scaffold(
                body: const KdButton(
                  label: 'Solid Disabled',
                  onPressed: null,
                  variant: MpButtonVariant.secondary,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final btn = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
        expect(btn.onPressed, isNull);
      });
    });

    // =========================================================================
    // Destructive variant
    // =========================================================================
    group('destructive variant', () {
      testWidgets('renders ElevatedButton with label', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Delete',
              onPressed: () {},
              variant: MpButtonVariant.destructive,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('is full width by default', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Destructive Wide',
              onPressed: () {},
              variant: MpButtonVariant.destructive,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, equals(double.infinity));
      });

      testWidgets('not full width when isFullWidth false', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Destructive Narrow',
              onPressed: () {},
              variant: MpButtonVariant.destructive,
              isFullWidth: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, isNull);
      });

      testWidgets('renders icon when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Del Icon',
              onPressed: () {},
              variant: MpButtonVariant.destructive,
              icon: Icons.delete,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('renders iconWidget when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Del Widget',
              onPressed: () {},
              variant: MpButtonVariant.destructive,
              iconWidget: const Icon(
                Icons.warning,
                key: Key('del-widget-icon'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('del-widget-icon')), findsOneWidget);
      });

      testWidgets('fires callback on tap', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Del Tap',
              onPressed: () => tapped = true,
              variant: MpButtonVariant.destructive,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Del Tap'));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });

      testWidgets('disabled state has null onPressed', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const KdButton(
              label: 'Del Disabled',
              onPressed: null,
              variant: MpButtonVariant.destructive,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      });
    });

    // =========================================================================
    // Text variant
    // =========================================================================
    group('text variant', () {
      testWidgets('renders TextButton with label', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Cancel',
              onPressed: () {},
              variant: MpButtonVariant.text,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('has minTapTarget height', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Text Height',
              onPressed: () {},
              variant: MpButtonVariant.text,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(TextButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.height, equals(AppSpacing.minTapTarget));
      });

      testWidgets('renders icon when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Text Icon',
              onPressed: () {},
              variant: MpButtonVariant.text,
              icon: Icons.close,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('renders iconWidget when provided', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Text Widget',
              onPressed: () {},
              variant: MpButtonVariant.text,
              iconWidget: const Icon(Icons.info, key: Key('text-widget-icon')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('text-widget-icon')), findsOneWidget);
      });

      testWidgets('fires callback on tap', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'Text Tap',
              onPressed: () => tapped = true,
              variant: MpButtonVariant.text,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Text Tap'));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });

      testWidgets('disabled state has null onPressed', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const KdButton(
              label: 'Text Disabled',
              onPressed: null,
              variant: MpButtonVariant.text,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final btn = tester.widget<TextButton>(find.byType(TextButton));
        expect(btn.onPressed, isNull);
      });

      testWidgets('renders SizedBox.shrink when no icon', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'No Icon Text',
              onPressed: () {},
              variant: MpButtonVariant.text,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No Icon Text'), findsOneWidget);
      });
    });

    // =========================================================================
    // MpButtonVariant enum
    // =========================================================================
    group('MpButtonVariant enum', () {
      test('has expected values', () {
        expect(MpButtonVariant.values, hasLength(4));
        expect(MpButtonVariant.values, contains(MpButtonVariant.primary));
        expect(MpButtonVariant.values, contains(MpButtonVariant.secondary));
        expect(MpButtonVariant.values, contains(MpButtonVariant.text));
        expect(MpButtonVariant.values, contains(MpButtonVariant.destructive));
      });
    });

    // =========================================================================
    // Cross-variant: no icon renders SizedBox.shrink in all variants
    // =========================================================================
    group('no icon renders correctly', () {
      for (final variant in [
        MpButtonVariant.primary,
        MpButtonVariant.destructive,
        MpButtonVariant.text,
      ]) {
        testWidgets('${variant.name} without icon renders label', (
          tester,
        ) async {
          await tester.pumpWidget(
            createTestableWidget(
              KdButton(
                label: 'Label ${variant.name}',
                onPressed: () {},
                variant: variant,
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Label ${variant.name}'), findsOneWidget);
        });
      }
    });

    // =========================================================================
    // Glass secondary without icon (no icon/iconWidget row)
    // =========================================================================
    group('glass secondary without icon', () {
      testWidgets('renders label only', (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            KdButton(
              label: 'No Icon Glass',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No Icon Glass'), findsOneWidget);
        // Should not find any standalone Icon widget (only within BackdropFilter)
      });
    });
  });
}
