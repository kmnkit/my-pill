import 'package:flutter/material.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/theme/app_theme.dart';
import 'package:my_pill/presentation/router/app_router.dart';

class MyPillApp extends StatelessWidget {
  const MyPillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyPill',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
