import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';

/// Base shimmer wrapper with theme-aware colors.
class KdShimmer extends StatelessWidget {
  const KdShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A3B39) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A4D4A) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

/// Single shimmer placeholder box.
class KdShimmerBox extends StatelessWidget {
  const KdShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppSpacing.radiusMd,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return KdShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// List shimmer with multiple placeholder rows.
class KdListShimmer extends StatelessWidget {
  const KdListShimmer({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 72,
  });

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return KdShimmer(
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < itemCount - 1 ? AppSpacing.md : 0,
            ),
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          );
        }),
      ),
    );
  }
}
