// Tests for AppleAuthErrorMessages extension.
// getLocalizedMessage() requires a BuildContext with AppLocalizations, so
// widget tests are used for that part. shouldShowSnackbar is pure logic and
// is tested directly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kusuridoki/data/enums/apple_auth_error.dart';
import 'package:kusuridoki/core/utils/apple_auth_error_messages.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

// Helper: pump a minimal localised app and call [callback] with a BuildContext
// that has AppLocalizations available.
Future<void> withLocalizedContext(
  WidgetTester tester,
  Future<void> Function(BuildContext) callback,
) async {
  late BuildContext capturedContext;

  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  await callback(capturedContext);
}

void main() {
  // ─── shouldShowSnackbar — pure logic, no widget needed ───────────────────

  group('AppleAuthError.shouldShowSnackbar', () {
    test('returns false only for userCancelled', () {
      expect(AppleAuthError.userCancelled.shouldShowSnackbar, isFalse);
    });

    test('returns true for credentialAlreadyInUse', () {
      expect(AppleAuthError.credentialAlreadyInUse.shouldShowSnackbar, isTrue);
    });

    test('returns true for invalidCredential', () {
      expect(AppleAuthError.invalidCredential.shouldShowSnackbar, isTrue);
    });

    test('returns true for operationNotAllowed', () {
      expect(AppleAuthError.operationNotAllowed.shouldShowSnackbar, isTrue);
    });

    test('returns true for providerAlreadyLinked', () {
      expect(AppleAuthError.providerAlreadyLinked.shouldShowSnackbar, isTrue);
    });

    test('returns true for networkRequestFailed', () {
      expect(AppleAuthError.networkRequestFailed.shouldShowSnackbar, isTrue);
    });

    test('returns true for unknown', () {
      expect(AppleAuthError.unknown.shouldShowSnackbar, isTrue);
    });

    test('all non-cancel errors show snackbar', () {
      final shouldAll = AppleAuthError.values
          .where((e) => e != AppleAuthError.userCancelled)
          .every((e) => e.shouldShowSnackbar);
      expect(shouldAll, isTrue);
    });
  });

  // ─── getLocalizedMessage — requires BuildContext ──────────────────────────

  group('AppleAuthError.getLocalizedMessage', () {
    testWidgets('userCancelled returns non-empty message', (tester) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.userCancelled.getLocalizedMessage(ctx);
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('credentialAlreadyInUse returns non-empty message', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.credentialAlreadyInUse.getLocalizedMessage(
          ctx,
        );
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('invalidCredential returns non-empty message', (tester) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.invalidCredential.getLocalizedMessage(ctx);
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('operationNotAllowed returns non-empty message', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.operationNotAllowed.getLocalizedMessage(ctx);
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('providerAlreadyLinked returns non-empty message', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.providerAlreadyLinked.getLocalizedMessage(
          ctx,
        );
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('networkRequestFailed returns non-empty message', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.networkRequestFailed.getLocalizedMessage(
          ctx,
        );
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('unknown returns non-empty message', (tester) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.unknown.getLocalizedMessage(ctx);
        expect(msg, isNotEmpty);
      });
    });

    testWidgets('all enum values produce distinct messages', (tester) async {
      await withLocalizedContext(tester, (ctx) async {
        final messages = AppleAuthError.values
            .map((e) => e.getLocalizedMessage(ctx))
            .toSet();
        // Every value should map to a unique l10n string.
        expect(messages.length, AppleAuthError.values.length);
      });
    });

    testWidgets('userCancelled message matches expected English string', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.userCancelled.getLocalizedMessage(ctx);
        expect(msg, 'Apple sign in was cancelled');
      });
    });

    testWidgets('networkRequestFailed message mentions network', (
      tester,
    ) async {
      await withLocalizedContext(tester, (ctx) async {
        final msg = AppleAuthError.networkRequestFailed.getLocalizedMessage(
          ctx,
        );
        expect(msg.toLowerCase(), contains('network'));
      });
    });
  });
}
