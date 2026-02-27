import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_alert_banner.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpAlertBanner', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const MpAlertBanner(title: 'Low inventory')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Low inventory'), findsOneWidget);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpAlertBanner(
            title: 'Warning',
            description: 'You are running low',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('You are running low'), findsOneWidget);
    });

    testWidgets('description absent when not provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const MpAlertBanner(title: 'Alert only')),
      );
      await tester.pumpAndSettle();

      // Only title, no description text
      expect(find.text('Alert only'), findsOneWidget);
      expect(find.byType(MpAlertBanner), findsOneWidget);
    });

    testWidgets('renders default warning icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const MpAlertBanner(title: 'Warning')),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('renders custom icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpAlertBanner(title: 'Info', icon: Icons.info_outline),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('onTap fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpAlertBanner(title: 'Tap me', onTap: () => tapped = true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders with error color variant', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpAlertBanner(
            title: 'Critical',
            color: AppColors.error,
            icon: Icons.error_outline,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Critical'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
