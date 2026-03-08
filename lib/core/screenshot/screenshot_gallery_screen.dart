import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:kusuridoki/core/screenshot/screenshot_caption_overlay.dart';
import 'package:kusuridoki/core/screenshot/screenshot_caregiver_override.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/adherence/weekly_summary_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_dashboard_screen.dart';
import 'package:kusuridoki/presentation/screens/home/home_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medications_list_screen.dart';
import 'package:kusuridoki/presentation/screens/travel/travel_mode_screen.dart';

typedef ScreenConfig = ({
  String filenameBase,
  String jaCaption,
  String enCaption,
  Widget screen,
  List<dynamic> overrides,
});

final _configs = <ScreenConfig>[
  (
    filenameBase: '01_home',
    jaCaption: '今日のお薬、ひと目でわかる',
    enCaption: 'Your daily meds, at a glance',
    screen: const HomeScreen(),
    overrides: <dynamic>[],
  ),
  (
    filenameBase: '02_medications_list',
    jaCaption: 'すべての薬を一か所で管理',
    enCaption: 'All your medications, in one place',
    screen: const MedicationsListScreen(),
    overrides: <dynamic>[],
  ),
  (
    filenameBase: '03_weekly_summary',
    jaCaption: '服薬の習慣が見えてくる',
    enCaption: 'Watch your habits come to life',
    screen: const WeeklySummaryScreen(),
    overrides: <dynamic>[],
  ),
  (
    filenameBase: '04_caregiver',
    jaCaption: '家族の服薬を見守る',
    enCaption: 'Keep watch over a loved one',
    screen: const CaregiverDashboardScreen(),
    overrides: <dynamic>[caregiverPatientsOverride],
  ),
  (
    filenameBase: '05_travel_mode',
    jaCaption: '旅先でも飲み忘れゼロ',
    enCaption: 'Never miss a dose, even abroad',
    screen: const TravelModeScreen(),
    overrides: <dynamic>[],
  ),
];

class ScreenshotGalleryScreen extends ConsumerStatefulWidget {
  const ScreenshotGalleryScreen({super.key});

  /// Exposed so tests can verify config count and filenames without rendering.
  static List<ScreenConfig> get screenConfigs => _configs;

  @override
  ConsumerState<ScreenshotGalleryScreen> createState() =>
      _ScreenshotGalleryScreenState();
}

class _ScreenshotGalleryScreenState
    extends ConsumerState<ScreenshotGalleryScreen> {
  final _controller = ScreenshotController();
  bool _capturing = false;

  Future<void> _captureAll() async {
    setState(() => _capturing = true);

    final docDir = await getApplicationDocumentsDirectory();
    var count = 0;

    for (final lang in ['ja', 'en']) {
      final langDir = Directory('${docDir.path}/screenshots/$lang');
      await langDir.create(recursive: true);

      for (final config in _configs) {
        final caption = lang == 'ja' ? config.jaCaption : config.enCaption;

        final widget = ProviderScope(
          overrides: config.overrides.cast(),
          child: MaterialApp(
            locale: Locale(lang),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: ScreenshotCaptionOverlay(
                caption: caption,
                child: config.screen,
              ),
            ),
          ),
        );

        final bytes = await _controller.captureFromWidget(widget);
        final file = File('${langDir.path}/${config.filenameBase}.png');
        await file.writeAsBytes(bytes);
        count++;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count screenshots saved to Documents/screenshots/'),
        ),
      );
      setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screenshot Gallery')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _configs.length,
              itemBuilder:
                  (_, i) => ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text(_configs[i].filenameBase),
                    subtitle: Text(_configs[i].jaCaption),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _capturing ? null : _captureAll,
                child: Text(_capturing ? 'Capturing…' : 'Capture All'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
