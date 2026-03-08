import 'package:flutter/material.dart';

/// Wraps a [child] widget with a gradient overlay and [caption] text at the
/// bottom. Used for App Store / ProductHunt screenshot generation.
class ScreenshotCaptionOverlay extends StatelessWidget {
  const ScreenshotCaptionOverlay({
    super.key,
    required this.child,
    required this.caption,
  });

  final Widget child;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                caption,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
