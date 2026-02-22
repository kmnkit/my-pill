// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Generates the app icon for Kusuridoki (くすりどき)
/// Run: flutter test tool/generate_icon.dart
void main() {
  test('generate app icon', () async {
    const size = 1024.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    _drawIcon(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final file = File('assets/images/app_icon.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    print('Icon generated: ${file.path} (${bytes.length} bytes)');
  });
}

void _drawIcon(Canvas canvas, double size) {
  // === Background: deep blue gradient ===
  final bgPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size, size),
      [
        const Color(0xFF1565C0), // Blue 800
        const Color(0xFF0D47A1), // Blue 900
      ],
    );
  canvas.drawRect(Rect.fromLTWH(0, 0, size, size), bgPaint);

  // === Subtle radial glow at center ===
  final glowPaint = Paint()
    ..shader = ui.Gradient.radial(
      Offset(size * 0.45, size * 0.45),
      size * 0.5,
      [
        const Color(0x201E88E5), // subtle light blue
        const Color(0x00000000),
      ],
    );
  canvas.drawRect(Rect.fromLTWH(0, 0, size, size), glowPaint);

  // === Capsule pill (tilted -15 degrees) ===
  canvas.save();
  canvas.translate(size * 0.5, size * 0.44);
  canvas.rotate(-15 * math.pi / 180);

  final capsuleWidth = size * 0.58;
  final capsuleHeight = size * 0.24;
  final capsuleRadius = capsuleHeight / 2;
  final capsuleRect = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: Offset.zero,
      width: capsuleWidth,
      height: capsuleHeight,
    ),
    Radius.circular(capsuleRadius),
  );

  // Capsule shadow
  final shadowPaint = Paint()
    ..color = const Color(0x40000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
  canvas.drawRRect(capsuleRect.shift(const Offset(0, 12)), shadowPaint);

  // Capsule body - left half (white)
  canvas.save();
  canvas.clipRect(Rect.fromCenter(
    center: Offset(-capsuleWidth * 0.25, 0),
    width: capsuleWidth * 0.5,
    height: capsuleHeight + 2,
  ));
  final whitePaint = Paint()..color = const Color(0xFFF5F5F5);
  canvas.drawRRect(capsuleRect, whitePaint);
  canvas.restore();

  // Capsule body - right half (light blue)
  canvas.save();
  canvas.clipRect(Rect.fromCenter(
    center: Offset(capsuleWidth * 0.25, 0),
    width: capsuleWidth * 0.5 + 2,
    height: capsuleHeight + 2,
  ));
  final bluePaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0, -capsuleHeight / 2),
      Offset(0, capsuleHeight / 2),
      [
        const Color(0xFFBBDEFB), // Blue 100
        const Color(0xFF90CAF9), // Blue 200
      ],
    );
  canvas.drawRRect(capsuleRect, bluePaint);
  canvas.restore();

  // Capsule center divider line
  final dividerPaint = Paint()
    ..color = const Color(0x30000000)
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke;
  canvas.drawLine(
    Offset(0, -capsuleHeight / 2 + 4),
    Offset(0, capsuleHeight / 2 - 4),
    dividerPaint,
  );

  // Capsule highlight (glossy effect on top)
  final highlightPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0, -capsuleHeight / 2),
      Offset(0, 0),
      [
        const Color(0x40FFFFFF),
        const Color(0x00FFFFFF),
      ],
    );
  final highlightRect = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: Offset(0, -capsuleHeight * 0.15),
      width: capsuleWidth * 0.85,
      height: capsuleHeight * 0.5,
    ),
    Radius.circular(capsuleRadius * 0.6),
  );
  canvas.drawRRect(highlightRect, highlightPaint);

  canvas.restore();

  // === Clock circle (bottom-right) ===
  final clockCenter = Offset(size * 0.68, size * 0.65);
  final clockRadius = size * 0.13;

  // Clock shadow
  final clockShadowPaint = Paint()
    ..color = const Color(0x30000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  canvas.drawCircle(clockCenter + const Offset(0, 6), clockRadius, clockShadowPaint);

  // Clock background
  final clockBgPaint = Paint()..color = const Color(0xFFFFFFFF);
  canvas.drawCircle(clockCenter, clockRadius, clockBgPaint);

  // Clock border
  final clockBorderPaint = Paint()
    ..color = const Color(0xFF1565C0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.008;
  canvas.drawCircle(clockCenter, clockRadius, clockBorderPaint);

  // Clock hour marks (12 marks)
  for (int i = 0; i < 12; i++) {
    final angle = (i * 30 - 90) * math.pi / 180;
    final isQuarter = i % 3 == 0;
    final outerR = clockRadius * 0.88;
    final innerR = isQuarter ? clockRadius * 0.72 : clockRadius * 0.78;
    final markPaint = Paint()
      ..color = const Color(0xFF0D47A1)
      ..strokeWidth = isQuarter ? 3.5 : 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      clockCenter + Offset(math.cos(angle) * innerR, math.sin(angle) * innerR),
      clockCenter + Offset(math.cos(angle) * outerR, math.sin(angle) * outerR),
      markPaint,
    );
  }

  // Clock hands - showing ~10:10 (classic clock display)
  // Hour hand (pointing to 10)
  final hourAngle = (300 - 90) * math.pi / 180;
  final hourPaint = Paint()
    ..color = const Color(0xFF0D47A1)
    ..strokeWidth = size * 0.008
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(
    clockCenter,
    clockCenter + Offset(
      math.cos(hourAngle) * clockRadius * 0.5,
      math.sin(hourAngle) * clockRadius * 0.5,
    ),
    hourPaint,
  );

  // Minute hand (pointing to 2)
  final minuteAngle = (60 - 90) * math.pi / 180;
  final minutePaint = Paint()
    ..color = const Color(0xFF1565C0)
    ..strokeWidth = size * 0.006
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(
    clockCenter,
    clockCenter + Offset(
      math.cos(minuteAngle) * clockRadius * 0.7,
      math.sin(minuteAngle) * clockRadius * 0.7,
    ),
    minutePaint,
  );

  // Clock center dot
  canvas.drawCircle(clockCenter, size * 0.006, Paint()..color = const Color(0xFF0D47A1));

  // === App name hint: small "K" letterform (optional subtle branding) ===
  // Keeping it clean - no text on icon for maximum clarity at small sizes
}
