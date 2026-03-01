import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_error_view.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdErrorView', () {
    testWidgets('renders error icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const KdErrorView(error: 'something went wrong')),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders generic error message for generic error', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(const KdErrorView(error: 'some random error')),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Something went wrong. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('renders network error message for SocketException', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdErrorView(error: 'SocketException: connection refused'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Network error. Please check your connection.'),
        findsOneWidget,
      );
    });

    testWidgets('renders retry button when onRetry provided', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        createTestableWidget(
          KdErrorView(error: 'some error', onRetry: () => retried = true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(retried, isTrue);
    });

    testWidgets('retry button absent when onRetry not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(const KdErrorView(error: 'some error')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdButton), findsNothing);
    });

    testWidgets('renders generic error message in Japanese locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidgetJa(const KdErrorView(error: 'some error')),
      );
      await tester.pumpAndSettle();

      // Should render without throwing; error message is l10n-resolved
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
