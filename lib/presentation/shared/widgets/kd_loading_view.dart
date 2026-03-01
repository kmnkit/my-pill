import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';

class KdLoadingView extends StatelessWidget {
  const KdLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
