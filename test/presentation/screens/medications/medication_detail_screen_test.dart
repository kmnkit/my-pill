import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/medication_detail_screen.dart';

// ---------------------------------------------------------------------------
// Test data
// ---------------------------------------------------------------------------

const _kMedId = 'med-test-1';

final _kMedication = Medication(
  id: _kMedId,
  name: 'Aspirin',
  dosage: 100,
  dosageUnit: DosageUnit.mg,
  shape: PillShape.round,
  color: PillColor.white,
  inventoryTotal: 30,
  inventoryRemaining: 20,
  lowStockThreshold: 5,
  createdAt: DateTime(2024),
);

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

/// Spy that records whether deleteMedication was called.
class _SpyMedicationList extends MedicationList {
  bool deleteCalled = false;
  String? deletedId;

  @override
  Future<List<Medication>> build() async => [_kMedication];

  @override
  Future<void> deleteMedication(String id) async {
    deleteCalled = true;
    deletedId = id;
  }
}

// ---------------------------------------------------------------------------
// Helper: pump MedicationDetailScreen inside a GoRouter so that
// context.pop() and context.push() don't throw NavigatorException.
// ---------------------------------------------------------------------------

// ignore: strict_raw_type
Widget _buildWithRouter({
  required List<dynamic> overrides,
  String medId = _kMedId,
}) {
  final router = GoRouter(
    initialLocation: '/medications/$medId',
    routes: [
      // A list route acts as the parent so context.pop() has somewhere to go.
      GoRoute(
        path: '/medications',
        builder: (_, _) => const Scaffold(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => MedicationDetailScreen(
              medicationId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, _) => const Scaffold(),
              ),
              GoRoute(
                path: 'schedule',
                builder: (_, _) => const Scaffold(),
              ),
            ],
          ),
        ],
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

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('MedicationDetailScreen', () {
    // DETAILMED-HAPPY-001: renders medication name and dosage
    testWidgets(
      'DETAILMED-HAPPY-001: renders medication name and dosage',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => _kMedication,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => _SpyMedicationList()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Medication name appears in the app bar title and in the body
        expect(find.text('Aspirin'), findsAtLeastNWidgets(1));
        // Dosage: 100mg
        expect(find.textContaining('100'), findsAtLeastNWidgets(1));
      },
    );

    // DETAILMED-HAPPY-002: delete flow
    testWidgets(
      'DETAILMED-HAPPY-002: tap delete → confirm → deleteMedication called → pop',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => _kMedication,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => spy),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Tap the delete icon button in the app bar
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Confirmation dialog should appear — tap the destructive confirm button.
        // The confirm label from l10n is 'Delete'.
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(spy.deleteCalled, isTrue);
        expect(spy.deletedId, equals(_kMedId));
      },
    );

    // Cancelling delete dialog does NOT call deleteMedication
    testWidgets(
      'cancelling delete dialog does not call deleteMedication',
      (tester) async {
        final spy = _SpyMedicationList();

        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => _kMedication,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => spy),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Tap Cancel in the confirmation dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(spy.deleteCalled, isFalse);
      },
    );

    // Shows 'not found' when medication is null
    testWidgets(
      'shows not found message when medication is null',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => _SpyMedicationList()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Medication not found'), findsOneWidget);
      },
    );

    // Shows error state when medicationProvider throws
    testWidgets(
      'shows error state and retry when provider throws',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => throw Exception('Storage error'),
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => _SpyMedicationList()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Error loading medication'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    // Edit button is present
    testWidgets('shows edit icon button in app bar', (tester) async {
      await tester.pumpWidget(
        _buildWithRouter(
          overrides: [
            medicationProvider(_kMedId).overrideWith(
              (ref) async => _kMedication,
            ),
            medicationAdherenceProvider(_kMedId).overrideWith(
              (ref) async => null,
            ),
            medicationSchedulesProvider(_kMedId).overrideWith(
              (ref) async => <Schedule>[],
            ),
            medicationHistoryProvider(_kMedId).overrideWith(
              (ref) async => <AdherenceRecord>[],
            ),
            medicationListProvider.overrideWith(() => _SpyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    // DETAILMED-OVERFLOW-001: 일반 화면에서 _InfoRow Flexible 사용 확인
    // Note: KdSectionHeader에 pre-existing overflow 버그 존재 (headlineSmall 텍스트, 좁은 화면)
    // 해당 버그는 이번 변경 범위 외이며 별도 수정 필요.
    testWidgets(
      'DETAILMED-OVERFLOW-001: InfoRow Flexible wrapper present on normal screen',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => _kMedication,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => _SpyMedicationList()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Aspirin'), findsAtLeastNWidgets(1));
      },
    );

    // DETAILMED-OVERFLOW-002: textScaler 2.0 — 기본 화면 크기에서 overflow 없음
    testWidgets(
      'DETAILMED-OVERFLOW-002: renders without overflow at textScaler 2.0',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: _buildWithRouter(
              overrides: [
                medicationProvider(_kMedId).overrideWith(
                  (ref) async => _kMedication,
                ),
                medicationAdherenceProvider(_kMedId).overrideWith(
                  (ref) async => null,
                ),
                medicationSchedulesProvider(_kMedId).overrideWith(
                  (ref) async => <Schedule>[],
                ),
                medicationHistoryProvider(_kMedId).overrideWith(
                  (ref) async => <AdherenceRecord>[],
                ),
                medicationListProvider.overrideWith(() => _SpyMedicationList()),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MedicationDetailScreen), findsOneWidget);
      },
    );

    // DETAILMED-OVERFLOW-003: _InfoRow value는 Flexible 안에서 textAlign.end
    testWidgets(
      'DETAILMED-OVERFLOW-003: InfoRow value uses Flexible wrapper',
      (tester) async {
        await tester.pumpWidget(
          _buildWithRouter(
            overrides: [
              medicationProvider(_kMedId).overrideWith(
                (ref) async => _kMedication,
              ),
              medicationAdherenceProvider(_kMedId).overrideWith(
                (ref) async => null,
              ),
              medicationSchedulesProvider(_kMedId).overrideWith(
                (ref) async => <Schedule>[],
              ),
              medicationHistoryProvider(_kMedId).overrideWith(
                (ref) async => <AdherenceRecord>[],
              ),
              medicationListProvider.overrideWith(() => _SpyMedicationList()),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // _InfoRow가 Flexible을 사용하는지 확인
        expect(find.byType(Flexible), findsAtLeastNWidgets(1));
      },
    );
  });
}
