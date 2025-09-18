import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class SpinnerPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  SpinnerPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.width * 0.08;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - strokeWidth;

    final Paint bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final double rotation = progress * 2 * pi;

    final double minSweep = pi * 0.25;
    final double maxSweep = pi * 1.1;
    final double sweep = lerpDouble(
      minSweep,
      maxSweep,
      (sin(progress * 2 * pi) + 1) / 2,
    )!;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final SweepGradient sweepGradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: colors,
      transform: GradientRotation(-pi / 2 + rotation),
    );

    final Paint arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = sweepGradient.createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      rotation - (sweep / 2),
      sweep,
      false,
      arcPaint,
    );

    final double dotAngle = rotation + (sweep / 2);
    final Offset dotPos = Offset(
      center.dx + radius * cos(dotAngle),
      center.dy + radius * sin(dotAngle),
    );
    final Paint dotPaint = Paint()..color = colors[1].withValues(alpha: 1.0);
    canvas.drawCircle(dotPos, strokeWidth * 0.52, dotPaint);
  }

  @override
  bool shouldRepaint(covariant SpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}
