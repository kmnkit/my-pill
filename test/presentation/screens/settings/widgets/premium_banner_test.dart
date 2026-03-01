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
  // kPremiumEnabled = false → PremiumBanner always returns SizedBox.shrink()
  group('PremiumBanner — feature flag disabled', () {
    testWidgets('returns SizedBox.shrink when kPremiumEnabled is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Premium'), findsNothing);
      expect(find.text('Upgrade to Premium'), findsNothing);
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
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows upgrade message', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upgrade for a cleaner experience'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows Upgrade to Premium button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upgrade to Premium'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows diamond icon for free user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _freeOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.diamond), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false
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
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows check_circle icon for premium user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

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
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows Current Plan when expiresAt is null', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current Plan'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows expiry date when expiresAt is set', (tester) async {
      final expiry = DateTime(2026, 12, 31);
      await tester.pumpWidget(
        createTestableWidget(
          const PremiumBanner(),
          overrides: _premiumOverrides(expiresAt: expiry),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('2026-12-31'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

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
    }, skip: true); // kPremiumEnabled is false
  });
}
