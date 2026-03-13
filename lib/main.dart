import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kusuridoki/app.dart';
import 'package:kusuridoki/core/utils/ad_consent_service.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/utils/sentry_scrubber.dart';
import 'package:kusuridoki/data/services/ad_service.dart';
import 'package:kusuridoki/data/services/notification_service.dart';
import 'package:kusuridoki/data/services/home_widget_service.dart';

const _sentryDsn = String.fromEnvironment('SENTRY_DSN');

Future<void> main() async {
  if (_sentryDsn.isEmpty) {
    await _initializeApp();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      options.environment = kDebugMode ? 'debug' : 'production';
      options.sendDefaultPii = false;
      options.tracesSampleRate = kDebugMode ? 1.0 : 0.2;
      // ignore: experimental_member_use
      options.profilesSampleRate = 1.0; // iOS only, alpha
      // ignore: experimental_member_use
      options.enableLogs = true;
      options.attachScreenshot = false;
      // ignore: experimental_member_use
      options.attachViewHierarchy = false;
      // Session Replay — explicitly enforce masking for PHI safety
      // (defaults are true, but set explicitly as defense-in-depth)
      // ignore: experimental_member_use
      options.privacy.maskAllText = true;
      // ignore: experimental_member_use
      options.privacy.maskAllImages = true;
      // ignore: experimental_member_use
      options.replay.sessionSampleRate = kDebugMode ? 1.0 : 0.1;
      // ignore: experimental_member_use
      options.replay.onErrorSampleRate = 1.0;
      options.beforeSend = scrubPhiFromEvent;
    },
    appRunner: _initializeApp,
  );
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Firebase (graceful failure if not configured)
  try {
    await Firebase.initializeApp();
  } catch (e, stackTrace) {
    ErrorHandler.captureException(e, stackTrace, 'Firebase.initializeApp');
  }

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

  runApp(SentryWidget(child: const ProviderScope(child: KusuridokiApp())));
}
