import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class MpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MpAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
    this.actions,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              iconSize: AppSpacing.iconMd,
            )
          : null,
      title: title != null ? Text(title!) : null,
      actions: actions,
    );
  }
}
