// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_toggle_switch.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdToggleSwitch', () {
    testWidgets('renders without label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(KdToggleSwitch(value: false, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdToggleSwitch), findsOneWidget);
    });

    testWidgets('renders label text when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          KdToggleSwitch(
            value: false,
            onChanged: (_) {},
            label: 'Notifications',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('onChanged fires with toggled value when tapped', (
      tester,
    ) async {
      bool? newValue;
      await tester.pumpWidget(
        createTestableWidget(
          KdToggleSwitch(value: false, onChanged: (v) => newValue = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('onChanged fires false when toggled from true', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        createTestableWidget(
          KdToggleSwitch(value: true, onChanged: (v) => newValue = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(newValue, isFalse);
    });

    testWidgets('Semantics has toggled property reflecting value', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(KdToggleSwitch(value: true, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(find.byType(KdToggleSwitch));
      expect(semantics.hasFlag(SemanticsFlag.isToggled), isTrue);
    });
  });
}
