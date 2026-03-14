import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kusuridoki/app.dart';
import 'package:kusuridoki/core/utils/ad_consent_service.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/services/ad_service.dart';
import 'package:kusuridoki/data/services/notification_service.dart';
import 'package:kusuridoki/data/services/home_widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Firebase (graceful failure if not configured)
  try {
    await Firebase.initializeApp();
  } catch (e, stackTrace) {
    ErrorHandler.debugLog(e, stackTrace, 'Firebase.initializeApp');
    // Firebase failed — skip Crashlytics setup, just run the app
    _runApp();
    return;
  }

  // Set up Crashlytics
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await _initializeServices();
  _runApp();
}

Future<void> _initializeServices() async {
  // Initialize notification service
  try {
    await NotificationService().initialize();
  } catch (e, stackTrace) {
    ErrorHandler.captureException(e, stackTrace, 'NotificationService.init');
  }

  // Initialize home widget service
  try {
    await HomeWidgetService.initialize();
  } catch (e, stackTrace) {
    ErrorHandler.captureException(e, stackTrace, 'HomeWidgetService.init');
  }

  // UMP consent must complete before MobileAds.instance.initialize()
  try {
    await AdConsentService().initialize();
    await AdConsentService().showFormIfRequired();
  } catch (e, stackTrace) {
    ErrorHandler.captureException(e, stackTrace, 'AdConsentService.init');
  }
  await AdService().initialize();
}

void _runApp() {
  runApp(const ProviderScope(child: KusuridokiApp()));
}
