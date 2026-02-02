import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_pill/app.dart';
import 'package:my_pill/data/services/notification_service.dart';
import 'package:my_pill/data/services/home_widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Firebase (graceful failure if not configured)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not configured yet: $e');
  }

  // Initialize notification service
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }

  // Initialize home widget service
  try {
    await HomeWidgetService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize home widget: $e');
  }

  runApp(
    const ProviderScope(
      child: MyPillApp(),
    ),
  );
}
