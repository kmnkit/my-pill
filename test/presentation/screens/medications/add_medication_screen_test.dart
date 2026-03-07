import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/add_medication_screen.dart';

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

class _FakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => const UserProfile(
    id: 'local',
    name: null,
    language: 'en',
    highContrast: false,
    textSize: 'normal',
    notificationsEnabled: true,
    criticalAlerts: false,
    snoozeDuration: 15,
    travelModeEnabled: false,
    removeAds: false,
    defaultIppoka: false,
  );
}

class _FakeMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

/// Records whether addMedication was called and what was passed.
class _SpyMedicationList extends MedicationList {
  Medication? addedMedication;
  bool addCalled = false;

  @override
  Future<List<Medication>> build() async => [];

  @override
  Future<void> addMedication(Medication medication) async {
    addCalled = true;
    addedMedication = medication;
  }
}

/// Always throws when addMedication is called.
class _FailingMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];

  @override
  Future<void> addMedication(Medication medication) async {
    throw Exception('Storage write failed');
  }
}

// ---------------------------------------------------------------------------
// Helper: pump AddMedicationScreen inside a real GoRouter so that
// context.pushReplacement does not throw a NavigatorException.
// ---------------------------------------------------------------------------

// ignore: strict_raw_type
Widget _buildWithRouter({required List<dynamic> overrides}) {
  final router = GoRouter(
    initialLocation: '/add',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Scaffold()),
      GoRoute(
        path: '/add',
        builder: (_, _) => const AddMedicationScreen(),
      ),
      // Destination after successful save.
      GoRoute(
        path: '/medications/:id/schedule',
        builder: (_, _) => const Scaffold(),
      ),
    ],
  );

  // ignore: avoid_dynamic_calls
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

/// Fills the name field (TextFormField at index 0) and the dosage field
/// (TextFormField at index 1), then scrolls to and taps the Continue button.
Future<void> _fillAndSubmit(
  WidgetTester tester, {
  String name = 'Aspirin',
  String dosage = '100',
}) async {
  final formFields = find.byType(TextFormField);
  await tester.enterText(formFields.first, name);
  await tester.pump();
  await tester.enterText(formFields.at(1), dosage);
  await tester.pump();

  // The button is buried in a long scroll view — scroll to it.
  await tester.scrollUntilVisible(
    find.text('Continue'),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text('Continue'));
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AddMedicationScreen', () {
    // ADDMED-HAPPY-001: valid input → addMedication called
    testWidgets(
      'ADDMED-HAPPY-001: valid name and dosage calls addMedication on notifier',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: '100');
        await tester.pump(); // allow async to start

        expect(spy.addCalled, isTrue);
        expect(spy.addedMedication?.name, equals('Aspirin'));
        expect(spy.addedMedication?.dosage, equals(100.0));
      },
    );

    // ADDMED-ERROR-001: empty name → SnackBar, no save
    testWidgets(
      'ADDMED-ERROR-001: empty name shows SnackBar and does not call addMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Leave name empty; enter dosage only then submit.
        await _fillAndSubmit(tester, name: '', dosage: '100');
        await tester.pumpAndSettle();

        expect(spy.addCalled, isFalse);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    // ADDMED-ERROR-002: empty dosage → SnackBar, no save
    testWidgets(
      'ADDMED-ERROR-002: empty dosage shows SnackBar and does not call addMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: '');
        await tester.pumpAndSettle();

        expect(spy.addCalled, isFalse);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    // ADDMED-ERROR-003: non-numeric dosage → SnackBar
    testWidgets(
      'ADDMED-ERROR-003: non-numeric dosage shows SnackBar and does not call addMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: 'abc');
        await tester.pumpAndSettle();

        expect(spy.addCalled, isFalse);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    // ADDMED-ERROR-004: zero dosage → SnackBar
    testWidgets(
      'ADDMED-ERROR-004: zero dosage shows SnackBar and does not call addMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: '0');
        await tester.pumpAndSettle();

        expect(spy.addCalled, isFalse);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    // ADDMED-ERROR-004: negative dosage → SnackBar
    testWidgets(
      'ADDMED-ERROR-004: negative dosage shows SnackBar and does not call addMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(() => spy),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: '-5');
        await tester.pumpAndSettle();

        expect(spy.addCalled, isFalse);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    // ADDMED-EDGE-001: save fails → SnackBar shown, button re-enabled
    testWidgets(
      'ADDMED-EDGE-001: notifier throws on save shows error SnackBar and re-enables button',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationListProvider.overrideWith(
                () => _FailingMedicationList(),
              ),
              userSettingsProvider.overrideWith(() => _FakeUserSettings()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _fillAndSubmit(tester, name: 'Aspirin', dosage: '100');
        await tester.pumpAndSettle();

        // SnackBar shown for error
        expect(find.byType(SnackBar), findsOneWidget);

        // Button re-enabled (label back to 'Continue', not 'Saving...')
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    // Renders app bar title
    testWidgets('renders Add Medication app bar title', (tester) async {
      await tester.pumpWidget(
        _buildWithRouter(
          overrides: [
            medicationListProvider.overrideWith(() => _FakeMedicationList()),
            userSettingsProvider.overrideWith(() => _FakeUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Medication'), findsOneWidget);
    });
  });
}
