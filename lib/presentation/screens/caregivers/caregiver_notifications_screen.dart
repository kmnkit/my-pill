import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_empty_state.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class CaregiverNotificationsScreen extends ConsumerWidget {
  const CaregiverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: KdAppBar(title: l10n.notifications),
      body: KdEmptyState(
        icon: Icons.notifications_none,
        title: l10n.noNotificationsYet,
        description: l10n.notificationsWillAppear,
      ),
    );
  }
}
