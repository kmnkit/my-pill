import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/premium_banner.dart';

import '../../../../helpers/widget_test_helpers.dart';

List<dynamic> _freeOverrides() => [
  isPremiumProvider.overrideWith((ref) => false),
  subscriptionStatusProvider.overrideWith(
    (ref) => const SubscriptionStatus(isPremium: false),
  ),
];

List<dynamic> _premiumOverrides({DateTime? expiresAt}) => [
  isPremiumProvider.overrideWith((ref) => true),
  subscriptionStatusProvider.overrideWith(
    (ref) => SubscriptionStatus(isPremium: true, expiresAt: expiresAt),
  ),
];

void main() {
  group('PremiumBanner — feature flag enabled', () {
    testWidgets('renders upgrade banner for free user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('Upgrade to Premium'), findsOneWidget);
    });
  });

  group('PremiumBanner — free user', () {
    testWidgets('shows Premium label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Premium'), findsOneWidget);
    });

    testWidgets('shows upgrade message', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upgrade for a cleaner experience'), findsOneWidget);
    });

    testWidgets('shows Upgrade to Premium button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upgrade to Premium'), findsOneWidget);
    });

    testWidgets('shows diamond icon for free user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.diamond), findsOneWidget);
    });
  });

  group('PremiumBanner — premium user', () {
    testWidgets('shows alreadyPremium text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("You're a Premium member"), findsOneWidget);
    });

    testWidgets('shows check_circle icon for premium user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows Manage Subscription button for premium user', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manage Subscription'), findsOneWidget);
    });

    testWidgets('shows Current Plan when expiresAt is null', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current Plan'), findsOneWidget);
    });

    testWidgets('shows expiry date when expiresAt is set', (tester) async {
      final expiry = DateTime(2026, 12, 31);
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(expiresAt: expiry),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('12/31/2026'), findsOneWidget);
    });

    testWidgets('does not show upgrade message for premium user', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upgrade for a cleaner experience'), findsNothing);
    });
  });
}
