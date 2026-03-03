/// App Store スクリーンショット — 全8画面を1回のドライブで撮影 (日本語ロケール)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:kusuridoki/app.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/presentation/router/app_router_provider.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/presentation/screens/medications/medication_detail_screen.dart';
import 'package:kusuridoki/presentation/screens/schedule/schedule_screen.dart';

import '../utils/mock_services.dart';
import '../utils/test_app.dart';
import '../utils/test_data.dart';
import '../robots/home_robot.dart';

/// 日本語ロケール + フルデータのスクリーンショット用設定
TestAppConfig _jaConfig() {
  final jaProfile =
      TestData.completedOnboardingPatient.copyWith(language: 'ja');
  return TestAppConfig(
    onboardingComplete: true,
    userRole: 'patient',
    userProfile: jaProfile,
    medications: TestData.sampleMedications,
    schedules: [
      TestData.dailySchedule,
      TestData.specificDaysSchedule,
      TestData.intervalSchedule,
    ],
    reminders: TestData.todayReminders(),
    adherenceRecords: TestData.weeklyAdherenceRecords(),
    isAuthenticated: true,
  );
}

/// サブ画面 (MedicationDetail, Schedule) 用のスタンドアロンテストアプリを構築
Widget _buildDirectRouteApp(TestAppConfig config, GoRouter router) {
  final storageService = MockStorageService(
    medications: config.medications,
    schedules: config.schedules,
    reminders: config.reminders,
    adherenceRecords: config.adherenceRecords,
    caregiverLinks: config.caregiverLinks,
    userProfile: config.userProfile,
  );
  final authService = MockAuthService();

  return ProviderScope(
    overrides: [
      storageServiceProvider.overrideWithValue(storageService),
      authServiceProvider.overrideWithValue(authService),
      appRouterProvider.overrideWith((_) => router),
    ],
    child: const KusuridokiApp(),
  );
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final config = _jaConfig();

  // ─── 01: ホーム画面 (今日のリマインダー) ────────────────────────────────
  testWidgets('screenshot_01_home', (tester) async {
    await tester.pumpWidget(buildPatientShellTestApp(config));
    final robot = HomeRobot(tester);
    await robot.goToHome();
    await binding.takeScreenshot('01_home');
  });

  // ─── 02: 薬の詳細画面 ────────────────────────────────────────────────────
  testWidgets('screenshot_02_medication_detail', (tester) async {
    final router = GoRouter(
      initialLocation: '/medications/med-1',
      redirect: (_, _) => null,
      routes: [
        GoRoute(
          path: '/medications/:id',
          builder: (context, state) => MedicationDetailScreen(
            medicationId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'schedule',
              name: RouteNames.setSchedule,
              builder: (context, state) => ScheduleScreen(
                medicationId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Edit'))),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(_buildDirectRouteApp(config, router));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('02_medication_detail');
  });

  // ─── 03: 週間アドヒアランスレポート ─────────────────────────────────────
  testWidgets('screenshot_03_weekly_report', (tester) async {
    await tester.pumpWidget(buildPatientShellTestApp(config));
    final robot = HomeRobot(tester);
    await robot.goToAdherence();
    await binding.takeScreenshot('03_weekly_report');
  });

  // ─── 04: 家族・介護者画面 ────────────────────────────────────────────────
  testWidgets('screenshot_04_family', (tester) async {
    await tester.pumpWidget(
      buildPatientTestApp(config, initialRoute: '/settings/family'),
    );
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04_family');
  });

  // ─── 05: スケジュール設定画面 ────────────────────────────────────────────
  testWidgets('screenshot_05_schedule', (tester) async {
    final router = GoRouter(
      initialLocation: '/medications/med-1/schedule',
      redirect: (_, _) => null,
      routes: [
        GoRoute(
          path: '/medications/:id/schedule',
          name: RouteNames.setSchedule,
          builder: (context, state) => ScheduleScreen(
            medicationId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/medications/:id',
          builder: (context, state) => MedicationDetailScreen(
            medicationId: state.pathParameters['id']!,
          ),
        ),
      ],
    );

    await tester.pumpWidget(_buildDirectRouteApp(config, router));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('05_schedule');
  });

  // ─── 06: 旅行モード画面 ─────────────────────────────────────────────────
  testWidgets('screenshot_06_travel', (tester) async {
    tz.initializeTimeZones(); // TravelModeScreen uses tz.local via TimezoneService
    await tester.pumpWidget(
      buildPatientTestApp(config, initialRoute: '/settings/travel'),
    );
    await tester.pumpAndSettle();
    await binding.takeScreenshot('06_travel');
  });

  // ─── 07: 薬一覧画面 ─────────────────────────────────────────────────────
  testWidgets('screenshot_07_medications_list', (tester) async {
    await tester.pumpWidget(buildPatientShellTestApp(config));
    final robot = HomeRobot(tester);
    await robot.goToMedications();
    await binding.takeScreenshot('07_medications_list');
  });

  // ─── 08: 設定画面 ────────────────────────────────────────────────────────
  testWidgets('screenshot_08_settings', (tester) async {
    await tester.pumpWidget(
      buildPatientTestApp(config, initialRoute: '/settings'),
    );
    // pumpAndSettle は使わない — KdShimmer (無限アニメーション) でタイムアウトするため
    await tester.pump(const Duration(seconds: 2));
    await binding.takeScreenshot('08_settings');
  });
}
