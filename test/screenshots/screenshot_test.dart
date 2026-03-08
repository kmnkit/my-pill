/// App Store screenshot capture tests.
///
/// Runs as: flutter test test/screenshots/screenshot_test.dart -v
/// Output:  assets/marketing/screenshots/*.png (1290×2796px)
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/theme/app_theme.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/adherence/weekly_summary_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/family_screen.dart';
import 'package:kusuridoki/presentation/screens/home/home_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medication_detail_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medications_list_screen.dart';
import 'package:kusuridoki/presentation/screens/schedule/schedule_screen.dart';
import 'package:kusuridoki/presentation/screens/settings/settings_screen.dart';
import 'package:kusuridoki/presentation/screens/travel/travel_mode_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../integration_test/utils/mock_services.dart';
import 'screenshot_fixtures.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/// Logical size: 430×932 (iPhone 6.7") → physical 1290×2796 at 3× scale.
const _kLogicalWidth = 430.0;
const _kLogicalHeight = 932.0;
const _kPixelRatio = 3.0;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

MockStorageService _makeStorage() => MockStorageService(
  medications: ScreenshotFixtures.medications,
  schedules: ScreenshotFixtures.schedules,
  reminders: ScreenshotFixtures.reminders,
  adherenceRecords: ScreenshotFixtures.adherenceRecords,
  caregiverLinks: ScreenshotFixtures.caregiverLinks,
  userProfile: ScreenshotFixtures.userProfile,
);

Widget _buildScreenApp({
  required MockStorageService storage,
  required String initialLocation,
  required List<RouteBase> routes,
}) {
  return ProviderScope(
    overrides: [
      storageServiceProvider.overrideWithValue(storage),
      authServiceProvider.overrideWithValue(MockAuthService()),
    ],
    child: MaterialApp.router(
      locale: const Locale('ja'),
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: initialLocation,
        redirect: (_, _) => null,
        routes: routes,
      ),
    ),
  );
}

/// Pumps [screenApp] at iPhone 6.7" resolution and saves PNG to [filename].
Future<void> _capture(
  WidgetTester tester,
  Widget screenApp,
  String filename,
) async {
  tester.view.physicalSize = const Size(
    _kLogicalWidth * _kPixelRatio,
    _kLogicalHeight * _kPixelRatio,
  );
  tester.view.devicePixelRatio = _kPixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(RepaintBoundary(key: boundaryKey, child: screenApp));
  // Let async providers load; shimmer shows while loading.
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump();
  await tester.pump();

  // runAsync so boundary.toImage() can complete via GPU callbacks.
  // flushPaint() is called synchronously before toImage() — no await gap
  // between them — so the !debugNeedsPaint assertion always sees a clean
  // boundary even if a persistent animation (e.g. shimmer) fires
  // markNeedsPaint() when the real event loop resumes inside runAsync.
  final bytes = await tester.runAsync(() async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    RendererBinding.instance.pipelineOwner.flushPaint();
    final image = await boundary.toImage(pixelRatio: _kPixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return byteData?.buffer.asUint8List();
  });
  await tester.runAsync(
    () => File('assets/marketing/screenshots/$filename').writeAsBytes(bytes!),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    // Lexend fonts are bundled in assets/fonts/google_fonts/ for offline use.
    GoogleFonts.config.allowRuntimeFetching = false;
    // Load NotoSansJP so Japanese text renders correctly (not as □) in tests.
    final fontData =
        await File('assets/fonts/NotoSansJP-Regular.ttf').readAsBytes();
    final fontLoader = FontLoader('NotoSansJP')
      ..addFont(Future.value(ByteData.sublistView(fontData)));
    await fontLoader.load();
  });

  testWidgets('screenshot_01_home', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/home',
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        ],
      ),
      '01_home.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_02_medication_detail', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/medications/med-1',
        routes: [
          GoRoute(
            path: '/medications',
            builder: (_, _) => const Scaffold(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => MedicationDetailScreen(
                  medicationId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(path: 'edit', builder: (_, _) => const Scaffold()),
                  GoRoute(
                    path: 'schedule',
                    builder: (_, _) => const Scaffold(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      '02_medication_detail.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_03_weekly_report', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/adherence',
        routes: [
          GoRoute(
            path: '/adherence',
            builder: (_, _) => const WeeklySummaryScreen(),
          ),
        ],
      ),
      '03_weekly_report.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_04_family', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/settings/family',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (_, _) => const Scaffold(),
            routes: [
              GoRoute(
                path: 'family',
                builder: (_, _) => const FamilyScreen(),
              ),
            ],
          ),
        ],
      ),
      '04_family.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_05_schedule', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/medications/med-1/schedule',
        routes: [
          GoRoute(
            path: '/medications',
            builder: (_, _) => const Scaffold(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, _) => const Scaffold(),
                routes: [
                  GoRoute(
                    path: 'schedule',
                    builder: (_, state) => ScheduleScreen(
                      medicationId: state.pathParameters['id'] ?? 'med-1',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      '05_schedule.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_06_travel', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/settings/travel',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (_, _) => const Scaffold(),
            routes: [
              GoRoute(
                path: 'travel',
                builder: (_, _) => const TravelModeScreen(),
              ),
            ],
          ),
        ],
      ),
      '06_travel.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_07_medications_list', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/medications',
        routes: [
          GoRoute(
            path: '/medications',
            builder: (_, _) => const MedicationsListScreen(),
            routes: [
              GoRoute(path: 'add', builder: (_, _) => const Scaffold()),
              GoRoute(
                path: ':id',
                builder: (_, state) => MedicationDetailScreen(
                  medicationId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      '07_medications_list.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('screenshot_08_settings', (tester) async {
    await _capture(
      tester,
      _buildScreenApp(
        storage: _makeStorage(),
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
            routes: [
              GoRoute(path: 'family', builder: (_, _) => const Scaffold()),
              GoRoute(path: 'travel', builder: (_, _) => const Scaffold()),
            ],
          ),
        ],
      ),
      '08_settings.png',
    );
  }, timeout: const Timeout(Duration(seconds: 60)));
}
