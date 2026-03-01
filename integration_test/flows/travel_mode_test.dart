/// E2E tests for the Travel Mode screen (TM-01 ~ TM-12)
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/settings_robot.dart';
import '../robots/travel_mode_robot.dart';

void main() {
  ensureTestInitialized();

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------
  group('Travel Mode — Navigation', () {
    testWidgets('TM-01: Settings → Travel Mode 진입', (tester) async {
      // Arrange: start on Settings screen
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final settingsRobot = SettingsRobot(tester);
      final travelRobot = TravelModeRobot(tester);

      // Act: tap Travel Mode
      await settingsRobot.tapTravelMode();

      // Assert: navigated to Travel Mode screen
      await travelRobot.verifyOnTravelModeScreen();
    });
  });

  // ---------------------------------------------------------------------------
  // Initial State
  // ---------------------------------------------------------------------------
  group('Travel Mode — Initial State', () {
    testWidgets('TM-02: 초기 상태 — 토글 OFF, 조건부 UI 숨김', (tester) async {
      // Arrange: start directly on Travel Mode
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Assert: disabled state
      await robot.verifyDisabledState();
    });

    testWidgets('TM-03: LocationDisplay 상시 표시', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Assert: location info always visible regardless of toggle
      await robot.verifyLocationDisplayVisible();
    });
  });

  // ---------------------------------------------------------------------------
  // Toggle
  // ---------------------------------------------------------------------------
  group('Travel Mode — Toggle', () {
    testWidgets('TM-04: ON → 조건부 UI 표시', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable travel mode
      await robot.tapEnableToggle();

      // Assert: conditional UI visible
      await robot.verifyEnabledState();
    });

    testWidgets('TM-05: OFF → 조건부 UI 재비표시', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: toggle ON then OFF
      await robot.tapEnableToggle();
      await robot.verifyEnabledState();
      await robot.tapEnableToggle();

      // Assert: back to disabled state
      await robot.verifyDisabledState();
    });
  });

  // ---------------------------------------------------------------------------
  // Mode Selection
  // ---------------------------------------------------------------------------
  group('Travel Mode — Mode Selection', () {
    testWidgets('TM-06: 기본 모드 = Fixed Interval', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable to reveal mode selector
      await robot.tapEnableToggle();

      // Assert: Fixed Interval is selected by default
      await robot.verifyFixedIntervalSelected();
    });

    testWidgets('TM-07: Local Time 전환', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable then switch to Local Time
      await robot.tapEnableToggle();
      await robot.tapLocalTime();

      // Assert: Local Time is selected
      await robot.verifyLocalTimeSelected();
    });

    testWidgets('TM-08: Fixed Interval 재전환', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable → Local Time → Fixed Interval
      await robot.tapEnableToggle();
      await robot.tapLocalTime();
      await robot.verifyLocalTimeSelected();
      await robot.tapFixedInterval();

      // Assert: Fixed Interval selected again
      await robot.verifyFixedIntervalSelected();
    });
  });

  // ---------------------------------------------------------------------------
  // Medications with Data
  // ---------------------------------------------------------------------------
  group('Travel Mode — Medications with Data', () {
    testWidgets('TM-09: 약 리스트 표시', (tester) async {
      // Arrange: patient with medications + schedules
      final app = buildPatientTestApp(
        TestAppConfig.patientWithMedications(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable travel mode
      await robot.tapEnableToggle();

      // Assert: medication names displayed
      await robot.verifyMedicationDisplayed('Aspirin');
    });

    testWidgets('TM-10: 시간 표시 확인', (tester) async {
      // Arrange: patient with medications + schedules
      final app = buildPatientTestApp(
        TestAppConfig.patientWithMedications(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable travel mode
      await robot.tapEnableToggle();

      // Assert: time displayed in AM/PM format
      await robot.verifyTimeDisplayed();
    });
  });

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------
  group('Travel Mode — Empty State', () {
    testWidgets('TM-11: 약 없음 → 빈 상태', (tester) async {
      // Arrange: patient with no medications
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable travel mode
      await robot.tapEnableToggle();

      // Assert: empty state message
      await robot.verifyNoScheduledMedications();
    });
  });

  // ---------------------------------------------------------------------------
  // Info Box
  // ---------------------------------------------------------------------------
  group('Travel Mode — Info Box', () {
    testWidgets('TM-12: 인포박스 표시', (tester) async {
      // Arrange
      final app = buildPatientTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/travel',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = TravelModeRobot(tester);

      // Act: enable travel mode
      await robot.tapEnableToggle();

      // Assert: info box with consult doctor text and info icon
      expect(robot.consultDoctorInfo, findsOneWidget);
      expect(robot.infoIcon, findsOneWidget);
    });
  });
}
