import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kusuridoki/app.dart';
import 'package:kusuridoki/core/utils/screenshot_data_seeder.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

/// Screenshot entry point: seeds sample data with ads hidden.
///
/// Usage: `flutter run -t lib/main_screenshot.dart`
///
/// AdService._hideAdsForScreenshots is already `true` in ad_service.dart,
/// so all banner and interstitial ads are suppressed.
///
/// To reset, run the normal `flutter run` (uses lib/main.dart).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not configured yet: $e');
  }

  // Seed sample data for screenshots
  final storage = StorageService();
  await storage.initializeEncryption();
  await storage.clearAll();
  await ScreenshotDataSeeder(storage).seed();
  debugPrint('[Screenshot Mode] Sample data seeded successfully');

  runApp(const ProviderScope(child: KusuridokiApp()));
}
