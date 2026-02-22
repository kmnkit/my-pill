import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

class CaregiverNotificationsScreen extends ConsumerWidget {
  const CaregiverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MpAppBar(title: l10n.notifications),
      body: MpEmptyState(
        icon: Icons.notifications_none,
        title: l10n.noNotificationsYet,
        description: l10n.notificationsWillAppear,
      ),
    );
  }
}
