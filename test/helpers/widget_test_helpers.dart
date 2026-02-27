import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

/// Wraps a widget with [ProviderScope], [MaterialApp], and localization
/// delegates for widget testing.
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   createTestableWidget(const MyWidget(), overrides: [...]),
/// );
/// ```
// ignore: strict_raw_type
Widget createTestableWidget(
  Widget child, {
  List<dynamic> overrides = const [],
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    // ignore: avoid_dynamic_calls
    overrides: overrides.cast(),
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

/// Same as [createTestableWidget] but with Japanese locale.
Widget createTestableWidgetJa(
  Widget child, {
  List<dynamic> overrides = const [],
}) {
  return createTestableWidget(
    child,
    overrides: overrides,
    locale: const Locale('ja'),
  );
}
