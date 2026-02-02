import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

class CaregiverNotificationsScreen extends ConsumerWidget {
  const CaregiverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MpAppBar(title: 'Notifications'),
      body: MpEmptyState(
        icon: Icons.notifications_none,
        title: 'No notifications yet',
        description: 'You\'ll be notified when your patients take or miss medications',
      ),
    );
  }
}
