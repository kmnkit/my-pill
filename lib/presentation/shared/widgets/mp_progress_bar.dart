import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class MpProgressBar extends StatelessWidget {
  const MpProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 8,
    this.showLabel = true,
    this.lowThreshold = 0.2,
  });

  final int current;
  final int total;
  final double height;
  final bool showLabel;
  final double lowThreshold;

  double get _progress => total > 0 ? current / total : 0;
  bool get _isLow => _progress <= lowThreshold;

  @override
  Widget build(BuildContext context) {
    final fillColor = _isLow ? AppColors.warning : AppColors.primary;
    final progressPercent = (_progress * 100).round();
    return Semantics(
      value: '$progressPercent%',
      label: 'Inventory: $current of $total',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: SizedBox(
                height: height,
                child: LinearProgressIndicator(
                  value: _progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.cardLight,
                  valueColor: AlwaysStoppedAnimation(fillColor),
                  minHeight: height,
                ),
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: AppSpacing.xs),
            ExcludeSemantics(
              child: Text(
                '$current / $total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _isLow ? AppColors.warning : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
