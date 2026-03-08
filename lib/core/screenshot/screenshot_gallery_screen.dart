// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:kusuridoki/core/screenshot/screenshot_caregiver_override.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/adherence/weekly_summary_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_dashboard_screen.dart';
import 'package:kusuridoki/presentation/screens/home/home_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medications_list_screen.dart';
import 'package:kusuridoki/presentation/screens/travel/travel_mode_screen.dart';

typedef ScreenConfig = ({
  String filenameBase,
  Widget screen,
});

final _configs = <ScreenConfig>[
  (filenameBase: '01_home', screen: const HomeScreen()),
  (
    filenameBase: '02_medications_list',
    screen: const MedicationsListScreen(),
  ),
  (
    filenameBase: '03_weekly_summary',
    screen: const WeeklySummaryScreen(),
  ),
  (
    filenameBase: '04_caregiver',
    screen: ProviderScope(
      overrides: [caregiverPatientsOverride],
      child: const CaregiverDashboardScreen(),
    ),
  ),
  (filenameBase: '05_travel_mode', screen: const TravelModeScreen()),
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
  int _currentIndex = 0;
  String _currentLang = 'ja';

  Future<void> _captureAll() async {
    setState(() => _capturing = true);

    final docDir = await getApplicationDocumentsDirectory();
    var count = 0;

    for (final lang in ['ja', 'en']) {
      final langDir = Directory('${docDir.path}/screenshots/$lang');
      await langDir.create(recursive: true);

      for (var i = 0; i < _configs.length; i++) {
        // Rebuild with new screen and locale, then wait for render.
        setState(() {
          _currentLang = lang;
          _currentIndex = i;
        });
        await Future.delayed(const Duration(milliseconds: 800));

        final bytes = await _controller.capture();
        if (bytes == null) continue;

        final file = File(
          '${langDir.path}/${_configs[i].filenameBase}.png',
        );
        await file.writeAsBytes(bytes);
        count++;
      }
    }

    if (mounted) {
      setState(() => _capturing = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$count screenshots saved to Documents/screenshots/'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // While capturing: show the target screen full-screen inside Screenshot.
    if (_capturing) {
      final config = _configs[_currentIndex];
      return Screenshot(
        controller: _controller,
        child: Localizations.override(
          context: context,
          locale: Locale(_currentLang),
          delegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: config.screen,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Screenshot Gallery')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _configs.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(_configs[i].filenameBase),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _captureAll,
                child: const Text('Capture All'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
